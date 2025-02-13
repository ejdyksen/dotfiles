#!/bin/bash

if command -v delta &> /dev/null; then
    exec delta "$@"
else
    # Use Git's default pager (usually less)
    exec "${PAGER:-less}" "$@"
fi
