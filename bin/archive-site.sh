#!/bin/bash

wget --mirror \
    --convert-links \
    --adjust-extension \
    --page-requisites \
    --no-parent \
    https://www.perlfoundation.org/
