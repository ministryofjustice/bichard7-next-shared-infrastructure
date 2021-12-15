#!/usr/bin/env bash

is_valid_json () {
    # Replace template variables with `true` to pass JSON verification
    # ${foo}           => true
    # "${foo}",        => "true",
    # "foo:${bar}:baz" => "foo:true:baz"
    sed -E 's/\$\{[^\}]*\}/true/g' $1 | jq empty
}

MODIFIED_JSON_FILES=`git diff --cached --name-only | grep -E '(\.json|\.json.tpl)$'`

for f in $MODIFIED_JSON_FILES; do
    if ! is_valid_json "$f"; then
        echo "$f: Invalid JSON" >&2
        exit 1
    fi
done
