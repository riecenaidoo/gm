#!/bin/bash

echo Initialise dir. Cloning repos...

ls -d v*/* | xargs -n 1 ./clone_repos.sh
# If I knew how to do the things, I'd have this as one script.
# I probably don't need xargs, but, fun!