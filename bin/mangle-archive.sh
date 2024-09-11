#!/bin/bash

set -eux -o pipefail

debounce 1 d npm install --save-dev cheerio prettier

find . -name "*.html" -type f -exec sed -i '' 's/\t/    /g' {} \;
find . -name "*.html" -type f -exec sed -i '' 's|</hr>||g' {} \;
find . -name "*.html" -type f -print0 | xargs -0 -n1 node bin/deduplicate.js

npx prettier --write "**/*.html"
