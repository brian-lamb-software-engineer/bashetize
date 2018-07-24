#!/bin/bash
# isntalls the files, using rsync, ignoring any existing files, not changing any perms, and ignoring specific git files
#first does a very basic check for a custom dir name.  Make sure you run this from the package root

# if dir exists, install the files
if [ -d ./userhome ]; then
    rsync -rlp --no-perms --ignore-existing --exclude=".git*" --exclude ".ssh/cm_socket/.gitignore" ./userhome/ ~/
fi
