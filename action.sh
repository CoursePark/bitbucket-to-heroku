#!/bin/sh

# Git clones a branch of a source repo and pushes it as another branch on a
# target repo. Assumes that a SSH private key is provided as the environment
# variable PRIVATE_KEY or is base64 encoded as PRIVATE_KEY_BASE64
#
# Four required arguments:
#
#     ./action.sh <source_repo_url> <source_branch> <target_repo_url> <target_branch>

export SOURCE_REPO="$1"
export SOURCE_BRANCH_COMMIT="$2"
export TARGET_REPO="$3"
export TARGET_BRANCH="$4"

export SOURCE_HOST="$(printf '%s' "$SOURCE_REPO" | sed 's/.*@//; s/[:/].*//')";
export TARGET_HOST="$(printf '%s' "$TARGET_REPO" | sed 's/.*@//; s/[:/].*//')";

# use PRIVATE_KEY_BASE64 over PRIVATE_KEY if available
[ -n "$PRIVATE_KEY_BASE64" ] && export PRIVATE_KEY="$(printf '%s' "$PRIVATE_KEY_BASE64" | base64 -d)"

# get a random 20 character letter/number string as a temporary branch name
export TEMP_BRANCH="$(cat /dev/urandom | base64 | head -c 1000 | sed 's|[+/]||g' | head -c 20)"

ssh-agent sh -c "printf '%s' \"\$PRIVATE_KEY\" | ssh-add - \
  && ssh -o StrictHostKeyChecking=no \$SOURCE_HOST 'exit' || true \
  && ssh -o StrictHostKeyChecking=no \$TARGET_HOST 'exit' || true \
  && git clone -n \"\$SOURCE_REPO\" deploy \
  && cd deploy \
  && git checkout -b \${TEMP_BRANCH} \"\$SOURCE_BRANCH_COMMIT\" \
  && git remote set-url origin \"\$TARGET_REPO\" \
  && git push --force origin \"\${TEMP_BRANCH}:\${TARGET_BRANCH}\" \
  "
