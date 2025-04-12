#!/bin/bash

ymd=$(git log -1 --date=format:'%y.%m.%d' --pretty=%ad)
hm=$(git log -1 --date=format:'%H%M' --pretty=%ad)
branch=$(git branch --show-current | tr -cd '[:alnum:].-')
semver=$ymd-$branch.$hm
sha=$(git log -1 --pretty=%h)

echo "semVer=$semver" >> "$GITHUB_OUTPUT"
echo "shortSha=$sha" >> "$GITHUB_OUTPUT"
