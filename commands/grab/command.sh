#!/bin/bash

#==============================================================================
# Remote Folder Transfer Utility
#==============================================================================
#
# Description:
#   This script efficiently transfers entire directories from remote systems
#   to the local machine using SSH and SCP. It creates compressed archives
#   on the remote system (using /dev/shm for speed when available) and
#   transfers them locally, with optional automatic unpacking.
#
# Features:
#   - Intelligent temporary storage selection (/dev/shm vs /tmp)
#   - Automatic exclusion of common cache/build directories
#   - File counting and size reporting for transfer visibility
#   - Robust error handling with cleanup on failure
#   - Optional local unpacking with cleanup
#
# Author: koad
# Created: July 2025
# Version: 1.0
#
# Dependencies:
#   - SSH access to remote system
#   - tar, gzip available on remote system
#   - scp for file transfer
#
# Security Notes:
#   - Requires SSH key-based or password authentication
#   - Uses secure file transfer protocols (SSH/SCP)
#   - Temporary files are cleaned up automatically
#
#==============================================================================

# Usage: ./grab_remote_folder.sh user@host:/path/to/folder [--tarball]

set -e  # Exit on any error

# Define common exclusions
EXCLUDES=(
  "node_modules"
  ".npm"
  "local"
  ".local"
)

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[info]${NC} Starting workspace transfer process..."

REMOTE_ARG="$1"
SKIP_UNPACK=false
[[ "$2" == "--tarball" ]] && SKIP_UNPACK=true

if [[ -z "$REMOTE_ARG" ]]; then
    echo -e "${RED}[error]${NC} No remote argument provided"
    echo "Usage: $0 user@host:/path/to/folder [--unpack]"
    exit 1
fi

# Extract user/host and folder path first
REMOTE_HOST="${REMOTE_ARG%%:*}"
REMOTE_PATH="${REMOTE_ARG#*:}"
BASENAME="$(basename "$REMOTE_PATH")"
DIRNAME="$(dirname "$REMOTE_PATH")"

echo -e "${GREEN}[info]${NC} Remote host: $REMOTE_HOST"

# Check if the host is reachable
# Check if the remote folder exists
echo -e "${GREEN}[info]${NC} Verifying remote folder existence: $REMOTE_PATH..."
if ssh "$REMOTE_HOST" "ls -d '$REMOTE_PATH'" &>/dev/null; then
    echo -e "${GREEN}[info]${NC} Remote folder $REMOTE_PATH exists."
else
    echo -e "${RED}[error]${NC} Remote folder $REMOTE_PATH does not exist or is not accessible. Please check the path."
    exit 1
fi

echo -e "${GREEN}[info]${NC} Remote path: $REMOTE_PATH"
echo -e "${GREEN}[info]${NC} Target folder: $BASENAME"

HOSTNAME=$(ssh "$REMOTE_HOST" "hostname")
CURRENT_DATE=$(date +%Y-%m-%d-%H-%M-%S)
PACKAGE_NAME="${CURRENT_DATE}-${BASENAME}-from-${HOSTNAME}"
TMP_NAME="${PACKAGE_NAME}.tar.gz"

# Check /dev/shm available space on REMOTE system
echo -e "${GREEN}[info]${NC} Checking remote /dev/shm available space..."
REMOTE_SHMP_AVAIL=$(ssh "$REMOTE_HOST" "df /dev/shm | awk 'NR==2 {print \$4}'")
REMOTE_SHMP_AVAIL_HUMAN=$(ssh "$REMOTE_HOST" "df -h /dev/shm | awk 'NR==2 {print \$4}'")
echo -e "${GREEN}[info]${NC} Remote /dev/shm available space: $REMOTE_SHMP_AVAIL_HUMAN"

# If remote /dev/shm has less than 2GB available, use /tmp instead
if [[ $REMOTE_SHMP_AVAIL -lt 2097152 ]]; then
    echo -e "${YELLOW}[warning]${NC} Remote /dev/shm has limited space, using /tmp as fallback"
    TMP_PATH="/tmp/$TMP_NAME"
else
    echo -e "${GREEN}[info]${NC} Using /dev/shm for temporary storage"
    TMP_PATH="/dev/shm/$TMP_NAME"
fi

echo -e "${GREEN}[info]${NC} Temporary file will be: $TMP_PATH"

# Count files before compression (with exclusions)
EXCLUDE_FIND_ARGS=""
for EXCL in "${EXCLUDES[@]}"; do
  EXCLUDE_FIND_ARGS+="! -path '*/$EXCL/*' "
done

echo -e "${GREEN}[info]${NC} Counting files in remote directory (with exclusions)..."
FILE_COUNT=$(ssh "$REMOTE_HOST" "find '$REMOTE_PATH' -type f $EXCLUDE_FIND_ARGS | wc -l")
echo -e "${GREEN}[info]${NC} Found $FILE_COUNT files to transfer"

# SSH: tar folder into shared memory with recursive exclusions
echo -e "${GREEN}[info]${NC} Creating compressed archive on remote system..."
EXCLUDE_TAR_ARGS=""
for EXCL in "${EXCLUDES[@]}"; do
  EXCLUDE_TAR_ARGS+="--exclude='*/$EXCL' "
done

if ssh "$REMOTE_HOST" "tar -czf '$TMP_PATH' \
  $EXCLUDE_TAR_ARGS \
  -C '$REMOTE_PATH' ."; then
    echo -e "${GREEN}[info]${NC} Archive created successfully"
else
    echo -e "${RED}[error]${NC} Failed to create archive"
    echo -e "${GREEN}[info]${NC} Cleaning up any partial files..."
    ssh "$REMOTE_HOST" "rm -f '$TMP_PATH'" 2>/dev/null || true
    exit 1
fi

# SSH: get file size and print in human-readable form
echo -e "${GREEN}[info]${NC} Checking archive size..."
if ARCHIVE_SIZE=$(ssh "$REMOTE_HOST" "du -h '$TMP_PATH'" | awk '{print $1}'); then
    echo -e "${GREEN}[info]${NC} Remote tarball size: $ARCHIVE_SIZE"
else
    echo -e "${RED}[error]${NC} Failed to get archive size"
fi

# SCP: retrieve tarball
echo -e "${GREEN}[info]${NC} Transferring archive to local system..."
if scp "$REMOTE_HOST:$TMP_PATH" ./; then
    echo -e "${GREEN}[info]${NC} Transfer completed successfully"
else
    echo -e "${RED}[error]${NC} Failed to transfer archive"
    echo -e "${GREEN}[info]${NC} Cleaning up remote temporary file..."
    ssh "$REMOTE_HOST" "rm -f '$TMP_PATH'" 2>/dev/null || true
    exit 1
fi

# SSH: cleanup
echo -e "${GREEN}[info]${NC} Cleaning up remote temporary file..."
ssh "$REMOTE_HOST" "rm -f '$TMP_PATH'"

# Local unpack (default behavior)
if ! $SKIP_UNPACK; then
    echo -e "${GREEN}[info]${NC} Unpacking archive locally..."
    mkdir -p "$PACKAGE_NAME"
    if tar -xzf "$TMP_NAME" -C "$PACKAGE_NAME"; then
        echo -e "${GREEN}[info]${NC} Archive unpacked successfully to ./$PACKAGE_NAME/"
        rm -f "$TMP_NAME"
        echo -e "${GREEN}[info]${NC} Temporary archive file removed"
    else
        echo -e "${RED}[error]${NC} Failed to unpack archive"
        exit 1
    fi
fi

echo -e "${GREEN}[info]${NC} Workspace transfer process completed successfully"
