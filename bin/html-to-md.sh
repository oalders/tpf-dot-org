#!/bin/bash

set -eux -o pipefail

cd www.perlfoundation.org || (echo "chdir" && exit 1)

for file in *.html; do
    pandoc "$file" \
        --strip-comments \
        --wrap=none \
        -f html \
        -t markdown \
        -o "../static/content/${file%.html}.md"
done

