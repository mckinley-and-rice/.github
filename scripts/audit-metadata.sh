#!/usr/bin/env bash
#
# Reports repositories whose description or topics do not meet docs/REPO-NAMING.md.
#
# A rule nothing checks is a preference, and GitHub has no setting that requires either
# field. This is the check: run it, or wire it into a scheduled workflow.
#
#   ./scripts/audit-metadata.sh mckinley-and-rice
#   ./scripts/audit-metadata.sh redrob-labs --fail
#
# --fail exits non-zero when anything is missing, so a workflow can gate on it. Without it
# the script always exits 0 and just reports, which is what you want while a backlog exists.
#
# If you wire this into a scheduled workflow, note that the automatic GITHUB_TOKEN cannot do
# it: that token is scoped to the repository it runs in and cannot list another repository's
# metadata, so a private repository is simply absent from the result rather than reported as
# failing. A silently short list looks like a passing audit. It needs a token with read access
# across the organization, stored as a secret.

set -euo pipefail

ORG="${1:-}"
if [ -z "$ORG" ]; then
  echo "usage: $0 <org> [--fail]" >&2
  exit 2
fi
FAIL_MODE="${2:-}"

MIN_DESCRIPTION_CHARS=20
MIN_TOPICS=3

# repositoryTopics is null rather than [] when a repository has none, so normalise it before
# counting. Archived repositories are excluded: their metadata is a historical record and
# editing them to satisfy a current rule rewrites what they were.
rows="$(gh repo list "$ORG" --limit 500 --json name,description,repositoryTopics,visibility,isArchived \
  --jq '.[] | select(.isArchived == false)
        | {
            name: .name,
            visibility: .visibility,
            desc: ((.description // "") | length),
            topics: ((.repositoryTopics // []) | length)
          }
        | [.name, .visibility, (.desc|tostring), (.topics|tostring)] | @tsv')"

total=0
bad=0

printf '%-44s %-8s %-14s %s\n' REPOSITORY VISIBILITY DESCRIPTION TOPICS
printf '%-44s %-8s %-14s %s\n' "$(printf '%.0s-' {1..44})" -------- -------------- ------

while IFS=$'\t' read -r name visibility desc topics; do
  [ -z "$name" ] && continue
  total=$((total + 1))

  problems=""
  if [ "$desc" -eq 0 ]; then
    problems="missing"
  elif [ "$desc" -lt "$MIN_DESCRIPTION_CHARS" ]; then
    problems="too short ($desc)"
  fi

  topic_note=""
  if [ "$topics" -lt "$MIN_TOPICS" ]; then
    topic_note="$topics, need $MIN_TOPICS"
  fi

  if [ -n "$problems" ] || [ -n "$topic_note" ]; then
    bad=$((bad + 1))
    printf '%-44s %-8s %-14s %s\n' "$name" "$visibility" "${problems:-ok}" "${topic_note:-ok}"
  fi
done <<< "$rows"

echo
echo "$bad of $total repositories need work in $ORG"

if [ -n "$FAIL_MODE" ] && [ "$FAIL_MODE" = "--fail" ] && [ "$bad" -gt 0 ]; then
  exit 1
fi
exit 0
