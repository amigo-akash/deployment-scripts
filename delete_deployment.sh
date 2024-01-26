#!/bin/bash
# This shell script takes repository name abd json file as the parameter 
OWNER="<owner-name>"
REPO=$1
GHA_TOKEN="<your-github-token>
JSON_FILE=$2

COUNTER=0

# Use jq to parse the JSON and extract the "id" for each object
ids=$(jq -r '.[].id' "$JSON_FILE")

# Loop through each id and delete it using REST API
IFS=$'\n' # Set Internal Field Separator to newline to handle multiple lines

for id in $ids; do
echo $(curl -L \
    -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GHA_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${OWNER}/${REPO}/deployments/${id}")

# print the deployment id which is deleted inside the each iteration
echo "Deployment deleted: $id"

# increment the counter 
COUNTER=$((COUNTER + 1))
done

#  echo total no.of deleted deployments
echo "Total no of deployment deleted is : $COUNTER"
