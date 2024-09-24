#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

# Add git-lfs to PATH if not already present
pushd bin/ >/dev/null
export PATH="${PATH}:${PWD}"
popd >/dev/null

# Download dataset
pushd c4/ >/dev/null

git lfs install --local --skip-smudge
git lfs fetch
git lfs pull

popd >/dev/null

# Compile stats
# this is to have an idea of the internal state of the dataset
for d in c4/
do
	printf "%s\n" "${d}"
done | sort -u | ./scripts/stats.sh

git-annex add --fast -c annex.largefiles=nothing *.stats

# Verify dataset
if [[ -f md5sums ]]
then
	md5sum -c md5sums
fi
list -- --fast | while read f
do
	if [[ -z "$(echo "${f}" | grep -E "^bin/")" ]] &&
		[[ -z "$(grep -E " (\./)?${f//\./\\.}$" md5sums)" ]]
	then
		md5sum "${f}" >> md5sums
	fi
done
