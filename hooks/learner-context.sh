#!/usr/bin/env bash
set -euo pipefail
#
# ~/.alice/hooks/learner-context.sh
#
# "I remember who I'm walking with."
#
# Loads the learner's persistent state and outputs a context block
# that can be prepended to Alice's session prompt.
#
# Reads from ~/.alice/.credentials (gitignored — learner data is private)
# Falls back to defaults for first-time learners.
#
# Surfaces:
#   - Prepended to opencode prompts via the launch hook
#   - CLI: alice learner (shows current learner state)
#   - Called by Alice's agent prompt via {file:} directive
#

ALICE_DIR="${ENTITY_DIR:-$HOME/.alice}"
LEARNER_FILE="$ALICE_DIR/.credentials"

# Defaults for a new learner
NAME="friend"
LEVEL="0"
LEVEL_NAME="First Contact"
LAST_SESSION="never"
LAST_TOPIC=""
STRUGGLED_WITH=""
EXCITED_ABOUT=""
QUESTS_DONE=""
SESSION_COUNT="0"

# Load persistent state if it exists
if [ -f "$LEARNER_FILE" ]; then
  source "$LEARNER_FILE" 2>/dev/null || true
  NAME="${LEARNER_NAME:-$NAME}"
  LEVEL="${LEARNER_LEVEL:-$LEVEL}"
  LAST_SESSION="${LEARNER_LAST_SESSION:-$LAST_SESSION}"
  LAST_TOPIC="${LEARNER_LAST_TOPIC:-$LAST_TOPIC}"
  STRUGGLED_WITH="${LEARNER_STRUGGLED_WITH:-$STRUGGLED_WITH}"
  EXCITED_ABOUT="${LEARNER_EXCITED_ABOUT:-$EXCITED_ABOUT}"
  QUESTS_DONE="${LEARNER_QUESTS_DONE:-$QUESTS_DONE}"
  SESSION_COUNT="${LEARNER_SESSION_COUNT:-$SESSION_COUNT}"
fi

# Map level number to name
case "$LEVEL" in
  0) LEVEL_NAME="First Contact" ;;
  1) LEVEL_NAME="Novice Explorer" ;;
  2|3) LEVEL_NAME="Apprentice" ;;
  4|5|6) LEVEL_NAME="Journeyer" ;;
  7|8|9|10) LEVEL_NAME="Expert" ;;
  11|12) LEVEL_NAME="Master" ;;
  *) LEVEL_NAME="Level $LEVEL" ;;
esac

echo "── Learner Context ──"
echo "name: $NAME"
echo "level: $LEVEL ($LEVEL_NAME)"
echo "sessions: $SESSION_COUNT"
echo "last session: $LAST_SESSION"

if [ -n "$LAST_TOPIC" ]; then
  echo "last topic: $LAST_TOPIC"
fi
if [ -n "$STRUGGLED_WITH" ]; then
  echo "struggled with: $STRUGGLED_WITH"
fi
if [ -n "$EXCITED_ABOUT" ]; then
  echo "excited about: $EXCITED_ABOUT"
fi
if [ -n "$QUESTS_DONE" ]; then
  echo "quests completed: $QUESTS_DONE"
fi

echo ""
echo "Alice: remember this person. Meet them where they are."
echo "── end learner context ──"
