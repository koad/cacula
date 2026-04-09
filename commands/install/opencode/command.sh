#!/usr/bin/env bash
set -euo pipefail

# Branded opencode build — pinned to a known-good upstream commit.
# Update KOAD_IO_OPENCODE_COMMIT after reviewing upstream changes.

source "$HOME/.koad-io/.env" 2>/dev/null || true

KOAD_IO_OPENCODE_REPO="${KOAD_IO_OPENCODE_REPO:?KOAD_IO_OPENCODE_REPO not set in ~/.koad-io/.env}"
KOAD_IO_OPENCODE_COMMIT="${KOAD_IO_OPENCODE_COMMIT:?KOAD_IO_OPENCODE_COMMIT not set in ~/.koad-io/.env}"
KOAD_IO_OPENCODE_BIN="$HOME/.koad-io/bin/opencode"
KOAD_IO_OPENCODE_SRC="$HOME/.cache/koad-io/opencode"
KOAD_IO_OPENCODE_PATCH="$HOME/.koad-io/patches/opencode.patch"
KOAD_IO_OPENCODE_STAMP="$HOME/.koad-io/bin/.opencode-commit"

echo "=========================================="
echo "  koad:io opencode — branded build"
echo "=========================================="
echo ""

echo "[1/5] Detecting platform..."
ARCH="$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/x64/' | sed 's/aarch64/arm64/')"
echo "  Platform: $ARCH"

echo ""
if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt &>/dev/null; then
    echo "[2/5] Ensuring clipboard helpers (wl-clipboard/xclip/xsel/xdotool)"
    sudo apt update >/dev/null && sudo apt install -y wl-clipboard xclip xsel xdotool
else
    echo "[2/5] Skipping clipboard helpers (apt not available)"
fi

echo ""
echo "[3/5] Preparing source ($KOAD_IO_OPENCODE_COMMIT) ..."
if [ ! -d "$KOAD_IO_OPENCODE_SRC/.git" ]; then
    git clone "$KOAD_IO_OPENCODE_REPO" "$KOAD_IO_OPENCODE_SRC"
fi
cd "$KOAD_IO_OPENCODE_SRC"
git fetch origin
git checkout "$KOAD_IO_OPENCODE_COMMIT"
git reset --hard "$KOAD_IO_OPENCODE_COMMIT"

if [ -f "$KOAD_IO_OPENCODE_PATCH" ]; then
    echo "  Applying branding patch ..."
    git apply --reject --whitespace=fix "$KOAD_IO_OPENCODE_PATCH"
fi

echo ""
echo "[4/5] Building ..."
cd packages/opencode
bun install
OPENCODE_CHANNEL=latest bun run build -- --single

echo ""
echo "[5/5] Installing ..."
mkdir -p "$(dirname "$KOAD_IO_OPENCODE_BIN")"
cp "dist/opencode-${ARCH}/bin/opencode" "$KOAD_IO_OPENCODE_BIN"
echo "$KOAD_IO_OPENCODE_COMMIT" > "$KOAD_IO_OPENCODE_STAMP"

echo "=========================================="
echo "  koad:io opencode $($KOAD_IO_OPENCODE_BIN --version) installed"
echo "  commit: $KOAD_IO_OPENCODE_COMMIT"
echo "=========================================="
