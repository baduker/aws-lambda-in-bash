#!/bin/bash

set -e
shopt -s extglob

USER="baduker"
STARRED="starred_repos.json"
API_URL="https://api.github.com/users/$USER/starred?per_page=100"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


while IFS=':' read -r key value; do
    # trim whitespace in "value"
    value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}

    case "$key" in
        link) LINK="$value"
                ;;
        HTTP*) read -r _ STATUS _ <<< "$key{$value:+:$value}"
                ;;
     esac
done < <(curl -sI "$API_URL")
echo "API response status: $STATUS"

TOTAL_PAGES=$(
  echo "$LINK" \
    | cut -d ' ' -f 3 \
    | sed -n 's/.*page=\([0-9]*\).*/\1/p'
    )
echo "Found $TOTAL_PAGES pages of starred repos for user: $USER."

echo "Collecting starred repos data..."
for page_number in $(seq 1 "$TOTAL_PAGES"); do
    echo "Page $page_number of $TOTAL_PAGES"
    curl -s "$API_URL"\&page="$page_number" | \
      jq -r '
      . | .[]
        |
          {
            repo_name: .name,
            data: {
                url: .html_url,
                description: .description,
                language: .language,
                full_url: .html_url,
                stars: .stargazers_count,
                name: .name,
                homepage: .homepage,
                ssh_url: .ssh_url,
              }
          }'  \
      >> "${0%.sh}_$page_number.json"
done

jq --slurp 'map(.)' "$SCRIPT_DIR"/*.json > "$STARRED"
rm "$SCRIPT_DIR"/"${0%.sh}"_*.json

echo "All done."
