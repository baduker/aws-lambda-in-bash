#!/bin/sh

STARRED="/var/task/starred_repos.json"

# the handler function is called by the lambda runtime
function handler() {
 	EVENT_DATA=$1
  echo "$EVENT_DATA" 1>&2;
  RESPONSE=$(jq -r --arg repo $(shuf -n1 -e $(jq -r '.[].repo_name' < "$STARRED")) \
    '.[] |
    {
      statusCode: 200,
      random_repo: select(.repo_name == $repo)
    }' < "$STARRED")
  echo "$RESPONSE"
}
