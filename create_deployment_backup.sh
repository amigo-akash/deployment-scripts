#!/bin/bash
# This shell script takes repository name and environment name as the parameter 
OWNER="<account-owner>"     
REPO=$1
GHA_TOKEN="<your-github-token>"
ENV=$2

JSON_FILE="./deployments/deployments__${ENV}__${REPO}.json"

echo "[]" | jq > deployments.json

PAGE_NUMBER=1

while true; do
  echo $(curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GHA_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${OWNER}/${REPO}/deployments?environment=${ENV}&per_page=100&page=${PAGE_NUMBER}") > deployments.tmp.json
  
  if [ "$(cat deployments.tmp.json | jq)" = "[]" ]; then
    break
  fi

  # Append the content of deployments.tmp.json to deployments.json using jq
  jq '. += input' deployments.json deployments.tmp.json > tmp.json
  mv -f tmp.json deployments.json
  rm deployments.tmp.json

  # Increment PAGE_NUMBER for the next iteration
  PAGE_NUMBER=$((PAGE_NUMBER + 1))
done

# move the deployments.json file to the specific directory
mv deployments.json ${JSON_FILE}

# Use jq to get the length of the array
ARRAY_LENGTH=$(jq 'length' "$JSON_FILE")

# Echo the length of the array
echo "Length of deployments array is: $ARRAY_LENGTH"
