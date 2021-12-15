#!/usr/bin/env bash

MODIFIED_TF_FILES=`git diff --cached --name-only \
                    | grep -E '(\.tf|\.terraform)$' \
                    | grep -v '/\.terraform/'`

for f in $MODIFIED_TF_FILES; do
    directory=$(dirname $f);
    readme="$directory/README.md"
    terraform-docs markdown $directory > $readme
done
