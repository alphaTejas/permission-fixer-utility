#!/usr/bin/env bash

set -euo pipefail

TEST_ROOT="test_perm_demo"

echo "[TEST] Creating test directory tree at: $TEST_ROOT"
rm -rf "$TEST_ROOT"
mkdir -p "$TEST_ROOT/dir1" "$TEST_ROOT/dir2/subdir"
touch "$TEST_ROOT/file1" "$TEST_ROOT/dir1/file2" "$TEST_ROOT/dir2/subdir/file3"

echo "[TEST] Setting wrong permissions..."
chmod 700 "$TEST_ROOT/dir1"
chmod 777 "$TEST_ROOT/dir2"
chmod 600 "$TEST_ROOT/file1"
chmod 666 "$TEST_ROOT/dir1/file2"
chmod 640 "$TEST_ROOT/dir2/subdir/file3"

echo
echo "[TEST] Current permissions (before):"
find "$TEST_ROOT" -type d -o -type f -print0 | xargs -0 stat -c "%a %n"

echo
echo "[TEST] Running permission-fixer in DRY-RUN mode..."
./permission-fixer.sh "$TEST_ROOT"

echo
echo "[TEST] Running permission-fixer with --fix..."
./permission-fixer.sh --fix "$TEST_ROOT"

echo
echo "[TEST] Permissions after fix:"
find "$TEST_ROOT" -type d -o -type f -print0 | xargs -0 stat -c "%a %n"

echo
echo "[TEST] Done."
