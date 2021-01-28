#!/usr/bin/env bash

set -e

set -x # FIXME

echo "$CIRRUS_REPO_FULL_NAME" # FIXME

# Ideally we would like to check whether we we triggered from a release, but
# releases are created from an independent Github action. Trigger for releases
# here and hope that the upload below succeeds (otherwise we need to manually
# retry after the release was created).
if [[ "$CIRRUS_RELEASE" == "" ]]; then
    CIRRUS_RELEASE=$CIRRUS_TAG
fi

if [[ "$CIRRUS_RELEASE" == "" ]]; then
  echo "Not a release. No need to deploy!"
  exit 0
fi

if [[ "$GITHUB_TOKEN" == "" ]]; then
  echo "Please provide GitHub access token via GITHUB_TOKEN environment variable!"
  exit 1
fi

file_content_type="application/octet-stream"
files_to_upload=(
  ./stamp.txt # FIXME
)

RELEASE_ID=$(curl https://api.github.com/repos/$CIRRUS_REPO_FULL_NAME/releases | jq '.[] | select(.tag_name=="'$CIRRUS_RELEASE'") | .id')

for fpath in $files_to_upload
do
  echo "Uploading $fpath..."
  name=$(basename "$fpath")
  url_to_upload="https://api.github.com/repos/$CIRRUS_REPO_FULL_NAME/releases/$RELEASE_ID/assets?name=$name"
  curl -X POST \
    --insecure \
    --data-binary @$fpath \
    --header "Authorization: token $GITHUB_TOKEN" \
    --header "Content-Type: $file_content_type" \
    $url_to_upload
done
