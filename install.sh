#!/bin/bash

set -e

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="git-bootstrap"
REPO_URL="https://raw.githubusercontent.com/waynehuang/git-bootstrap/main/git_bootstrap/cli.py"

echo "Installing git-bootstrap to $INSTALL_DIR..."

cat > /tmp/git-bootstrap <<'WRAPPER'
#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys


def run(cmd, cwd=None):
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    return result.returncode, result.stdout.strip(), result.stderr.strip()


def main():
    parser = argparse.ArgumentParser(
        description="Initialize a local folder as a git repo and link it to a remote GitHub repository."
    )
    parser.add_argument("folder", help="Path to the local folder")
    parser.add_argument("remote", help="GitHub repo URL (e.g. git@github.com:user/repo.git)")
    parser.add_argument("--branch", default="main", help="Branch name (default: main)")
    args = parser.parse_args()

    folder = os.path.abspath(args.folder)
    remote = args.remote
    branch = args.branch

    if not os.path.isdir(folder):
        print(f"Error: '{folder}' is not a valid directory.")
        sys.exit(1)

    git_dir = os.path.join(folder, ".git")
    if os.path.isdir(git_dir):
        print(f"Warning: '{folder}' is already a git repository.")
        confirm = input("Continue and set remote? (y/n): ")
        if confirm.lower() != "y":
            print("Aborted.")
            sys.exit(0)
    else:
        code, _, err = run(["git", "init"], cwd=folder)
        if code != 0:
            print(f"Error: git init failed: {err}")
            sys.exit(1)
        print(f"Initialized git repository in {folder}")

    code, existing, _ = run(["git", "remote", "get-url", "origin"], cwd=folder)
    if code == 0:
        print(f"Remote 'origin' already exists: {existing}")
        replace = input(f"Replace with {remote}? (y/n): ")
        if replace.lower() == "y":
            run(["git", "remote", "set-url", "origin", remote], cwd=folder)
            print(f"Updated remote 'origin' to {remote}")
    else:
        run(["git", "remote", "add", "origin", remote], cwd=folder)
        print(f"Added remote 'origin': {remote}")

    run(["git", "branch", "-M", branch], cwd=folder)

    print(f"\nDone! '{folder}' is now linked to {remote}")
    print(f"You can push with: git push -u origin {branch}")


if __name__ == "__main__":
    main()
WRAPPER

chmod +x /tmp/git-bootstrap

if [ -w "$INSTALL_DIR" ]; then
    mv /tmp/git-bootstrap "$INSTALL_DIR/$SCRIPT_NAME"
else
    sudo mv /tmp/git-bootstrap "$INSTALL_DIR/$SCRIPT_NAME"
fi

echo "Installed! Run 'git-bootstrap' from anywhere."
