#!/bin/bash

pushd $@ > /dev/null 2>&1
# -a read from file
# -r do not run if std. in empty 
# -n 1 how many args per cmd exec
xargs -a repos.txt -r -n 1 bash -c 'git clone "$@"' _
# tbh I don't know why the `_` is neccessary, but without it the args don't get passed in
popd > /dev/null 2>&1