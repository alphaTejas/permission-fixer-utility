# Permission Fixer Utility

Permission Fixer Utility is a small Bash command-line tool that scans a directory tree, checks file and directory permissions against a simple policy, and optionally fixes them.

It is designed both as a practical helper for Linux systems and as a learning project to practice Bash scripting, Linux permissions, and command-line tooling. [web:209][web:26][web:64]

---

## What it does

The script enforces this basic policy:

- Directories should have permissions `755` (owner: read/write/execute, group: read/execute, others: read/execute). [web:57][web:64]
- Regular files should have permissions `644` (owner: read/write, group: read, others: read). [web:57][web:26][web:64]

For every file and directory under a target path, it:

- Reports when permissions are correct (`[OK]`).
- Reports when permissions are wrong (`[VIOLATION]`).
- In dry-run mode, shows what it would change.
- In fix mode, uses `chmod` to actually correct the permissions. [web:64][web:233]

---

## Features

- Recursively scans a directory tree using `find`. [web:182][web:189]
- Distinguishes between:
  - Directories → checks for `755`.
  - Regular files → checks for `644`.
- Safe by default:
  - Starts in dry-run mode (no changes to the filesystem).
  - Only changes permissions when `--fix` is explicitly provided.
- Clear, structured Bash code using functions and simple argument parsing. [web:100][web:98]

---
