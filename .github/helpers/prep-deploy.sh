#!/usr/bin/env bash

# this script deploys a desk to a ship from a github repository
# assumes gcloud credentials are loaded and gcloud installed.

repo=$1
desk=$2
ref=${3:-.}
folder=$ship/$desk

set -e
set -o pipefail
cmdfile=$(mktemp "${TMPDIR:-/tmp/}janeway.XXXXXXXXX")
cmds='
source_repo=$(mktemp --dry-run /tmp/repo.janeway.XXXXXXXXX)
git clone git@github.com:'$repo'.git $source_repo
urbit_repo=$(mktemp --dry-run /tmp/repo.urbit.XXXXXXXXX)
git clone git@github.com:urbit/urbit.git $urbit_repo
cd $source_repo
git checkout '$ref'
cd /home/urb || return
curl -s --data '"'"'{"source":{"dojo":"+hood/mount %'$desk'"},"sink":{"app":"hood"}}'"'"' http://localhost:12321
rsync -avL --delete $source_repo/desk/ '$folder'
rsync -avL $urbit_repo/pkg/base-dev/ '$folder'
curl -s --data '"'"'{"source":{"dojo":"+hood/commit %'$desk'"},"sink":{"app":"hood"}}'"'"' http://localhost:12321
rm -rf $source_repo
rm -rf $urbit_repo
'
echo "$cmds"
echo "$cmds" >> "$cmdfile"

key=$(echo "$SSH_SEC_KEY" | base64 -d)
echo "key=$(echo $key)" >> $GITHUB_OUTPUT
echo "cmdfile=$(echo $cmdfile)" >> $GITHUB_OUTPUT