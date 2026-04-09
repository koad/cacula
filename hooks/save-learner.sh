#!/usr/bin/env bash
set -euo pipefail
#
# ~/.alice/hooks/save-learner.sh
#
# Saves learner state to persistent storage.
# Called at end of session (or by Alice via bash tool).
#
# Usage:
#   save-learner.sh --name "koad" --level 3 --topic "trust bonds" --struggled "gpg signing" --excited "entity gestation"
#   alice save-learner  (from CLI)
#

ALICE_DIR="${ENTITY_DIR:-$HOME/.alice}"
LEARNER_FILE="$ALICE_DIR/.credentials"

# Load existing state
if [ -f "$LEARNER_FILE" ]; then
  source "$LEARNER_FILE" 2>/dev/null || true
fi

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --name) LEARNER_NAME="$2"; shift 2 ;;
    --level) LEARNER_LEVEL="$2"; shift 2 ;;
    --topic) LEARNER_LAST_TOPIC="$2"; shift 2 ;;
    --struggled) LEARNER_STRUGGLED_WITH="$2"; shift 2 ;;
    --excited) LEARNER_EXCITED_ABOUT="$2"; shift 2 ;;
    --quest) if [ -n "${LEARNER_QUESTS_DONE:-}" ]; then LEARNER_QUESTS_DONE="${LEARNER_QUESTS_DONE},$2"; else LEARNER_QUESTS_DONE="$2"; fi; shift 2 ;;
    *) shift ;;
  esac
done

# Increment session count
LEARNER_SESSION_COUNT=$(( ${LEARNER_SESSION_COUNT:-0} + 1 ))
LEARNER_LAST_SESSION=$(date '+%Y-%m-%d')

# Write state
cat > "$LEARNER_FILE" << EOF
# Alice learner state — private, gitignored
# Updated: $(date '+%Y-%m-%d %H:%M')
LEARNER_NAME="${LEARNER_NAME:-friend}"
LEARNER_LEVEL="${LEARNER_LEVEL:-0}"
LEARNER_SESSION_COUNT="$LEARNER_SESSION_COUNT"
LEARNER_LAST_SESSION="$LEARNER_LAST_SESSION"
LEARNER_LAST_TOPIC="${LEARNER_LAST_TOPIC:-}"
LEARNER_STRUGGLED_WITH="${LEARNER_STRUGGLED_WITH:-}"
LEARNER_EXCITED_ABOUT="${LEARNER_EXCITED_ABOUT:-}"
LEARNER_QUESTS_DONE="${LEARNER_QUESTS_DONE:-}"
EOF

echo "Learner state saved. Session #$LEARNER_SESSION_COUNT."
