#!/usr/bin/env bash
# Creates a groomed issue in one of the two pipeline target repos, using the
# CROSS_REPO_TOKEN env var (a short-lived, issues-only GitHub App installation
# token) rather than a token the caller has to handle directly. Body is read
# from stdin so callers can heredoc it in without shell-quoting headaches.
#
# Usage: create-target-issue.sh <repo> <title>   (body piped via stdin)
set -euo pipefail

repo="${1:?usage: create-target-issue.sh <repo> <title> (body on stdin)}"
title="${2:?usage: create-target-issue.sh <repo> <title> (body on stdin)}"

case "$repo" in
  dougp13/this-dang-house-ios|dougp13/this-dang-house) ;;
  *)
    echo "refusing: unexpected target repo '$repo'" >&2
    exit 1
    ;;
esac

: "${CROSS_REPO_TOKEN:?CROSS_REPO_TOKEN is not set}"

GH_TOKEN="$CROSS_REPO_TOKEN" gh issue create \
  --repo "$repo" \
  --title "$title" \
  --label groomed \
  --body-file -
