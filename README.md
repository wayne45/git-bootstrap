# git-bootstrap

Turn any existing local folder into a git repo linked to a remote GitHub repository with one command.

## Install

```bash
pip install git+https://github.com/waynehuang/git-bootstrap.git
```

Or install locally:

```bash
pip install -e /path/to/git-bootstrap
```

Or use the install script (no pip required):

```bash
curl -sSL https://raw.githubusercontent.com/waynehuang/git-bootstrap/main/install.sh | bash
```

## Usage

1. Create an empty repo on GitHub (no README, no .gitignore)
2. Run:

```bash
git-bootstrap /path/to/your/folder git@github.com:youruser/yourrepo.git
```

Options:

```
git-bootstrap <folder> <remote-url> [--branch main]
```

| Argument   | Description                    |
|------------|--------------------------------|
| `folder`   | Path to the local folder       |
| `remote`   | GitHub repo URL (SSH or HTTPS) |
| `--branch` | Branch name (default: `main`)  |

## What it does

1. Runs `git init` in the target folder
2. Adds the GitHub URL as `origin` remote
3. Commits all files
4. Pushes to the specified branch

