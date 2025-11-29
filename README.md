# Permission Fixer Utility

A small Bash command-line tool that scans a directory tree, checks file and directory permissions against a simple policy, and optionally fixes them.

- Directories should be `755`
- Regular files should be `644`

This project is for learning and practicing:
- Practical Linux file permission management
- Bash scripting with functions, `find`, `stat`, loops, and argument parsing

## Features

- Recursively scans a target directory
- Reports permission violations:
  - `[VIOLATION]` when a file/dir does not match the expected mode
  - `[OK]` when permissions are correct
- **Dry-run mode** (default): only prints what would be changed
- **Fix mode** (`--fix`): applies `chmod` to enforce the policy

## Usage

