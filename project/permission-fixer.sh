#!/usr/bin/env bash

# Permission Fixer Utility
# ========================
# Scans a folder tree and enforces permission rules:
# - Directories: 755 (owner:rwx, group:rx, others:rx)
# - Regular files: 644 (owner:rw, group:r, others:r)
#
# Usage: ./permission-fixer.sh [--fix] [ROOT_PATH]
#   --fix        : actually apply changes (default: dry-run only)
#   ROOT_PATH    : folder to scan (default: current directory .)
#
# Safety:
# - Defaults to dry-run (list violations only)
# - Skips symlinks initially
# - In fix mode, will ask for confirmation before changes (you can add later)
#
# Author: Tejas Kumar K L

# ---- Globals ----
DRY_RUN=true          # start in dry-run mode
ROOT_PATH="."         # default to current directory

# Expected permission modes
EXPECTED_DIR_MODE=755
EXPECTED_FILE_MODE=644

print_usage() {
  echo "Usage: ./permission-fixer.sh [--fix] [ROOT_PATH]"
  echo "  --fix        : actually apply changes (default: dry-run only)"
  echo "  ROOT_PATH    : folder to scan (default: current directory .)"
}

# Walk the directory tree
walk_tree() {
  # Directories and files only; skip symlinks
  find "$ROOT_PATH" -type d -o -type f | while read -r path; do
    check_path "$path"
  done
}

# Decide how to handle each path
check_path() {
  local path="$1"

  if [ -d "$path" ]; then
    check_dir_permissions "$path"
  elif [ -f "$path" ]; then
    check_file_permissions "$path"
  else
    echo "[SKIP] Not a regular file or directory: $path"
  fi
}

# Check directory permissions
check_dir_permissions() {
  local path="$1"
  local mode
  mode=$(stat -c "%a" "$path")

  if [ "$mode" != "$EXPECTED_DIR_MODE" ]; then
    echo "[VIOLATION] Directory: $path (mode=$mode, expected=$EXPECTED_DIR_MODE)"
    fix_permissions "$path" "$EXPECTED_DIR_MODE"
  else
    echo "[OK] Directory: $path (mode=$mode)"
  fi
}

# Check file permissions
check_file_permissions() {
  local path="$1"
  local mode
  mode=$(stat -c "%a" "$path")

  if [ "$mode" != "$EXPECTED_FILE_MODE" ]; then
    echo "[VIOLATION] File: $path (mode=$mode, expected=$EXPECTED_FILE_MODE)"
    fix_permissions "$path" "$EXPECTED_FILE_MODE"
  else
    echo "[OK] File: $path (mode=$mode)"
  fi
}

# Fix permissions (obeys DRY_RUN)
fix_permissions() {
  local path="$1"
  local expected_mode="$2"

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] Would chmod $expected_mode '$path'"
  else
    echo "[FIX] chmod $expected_mode '$path'"
    chmod "$expected_mode" "$path" || {
      echo "[ERROR] Failed to chmod $expected_mode '$path'" >&2
    }
  fi
}

main() {
  # 1) Parse arguments
  for arg in "$@"; do
    case "$arg" in
      --fix)
        DRY_RUN=false
        ;;
      -h|--help)
        print_usage
        exit 0
        ;;
      *)
        ROOT_PATH="$arg"
        ;;
    esac
  done

  # 2) Validate ROOT_PATH exists and is a directory
  if [ ! -d "$ROOT_PATH" ]; then
    echo "Error: '$ROOT_PATH' is not a directory or does not exist." >&2
    exit 1
  fi

  # 3) Debug
  echo "[DEBUG] Permission Fixer Utility starting..."
  echo "[DEBUG] Dry-run mode: $DRY_RUN (set to false with --fix to apply changes)"
  echo "[DEBUG] Root path   : $ROOT_PATH"

  # 4) Walk tree and check/fix permissions
  walk_tree
}

# Entry point
main "$@"
