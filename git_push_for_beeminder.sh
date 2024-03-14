#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


# Require
# There are no changes staged for commit
if ! git diff --cached --exit-code --quiet; then
    # If the command does not exit with 0, there are changes staged
    echo "Error: You must first commit before using this script." >&2
    exit 1
fi


rm -f for_beeminder.md; find . -name "*.e" |  xargs -I {} sh -c 'echo "# Filename: {}"; cat {}; echo'  >> for_beeminder.md
git add for_beeminder.md
git commit -am "auto generate for_beeminder so that it can count the lines of code."
git push
