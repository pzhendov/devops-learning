#!/usr/bin/env bash

name="${1:-DevOps learner}"
file="${2:-hello.txt}"

echo "Hello, $name"

if [[ -f "$file" ]]; then

    echo "Found the file: $file"
    echo "It contains $(wc -l < "$file") lines."
else
    echo "Error: $file was not found." >&2
    exit 1
fi
