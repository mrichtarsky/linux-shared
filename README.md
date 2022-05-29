# Setup script for Debian/Ubuntu and SLES development machines

Quickly get up and running on a new server/VM with the environment you are used to.

Sets up a common directory structure, installs helpful tools and config files. Config files will be symlinked to the repo version and thus be shared among all users. Be aware of that for `root`, and don't use this in production!

Optimized for VS Code, bash and tmux. Can reattach to running tmux sessions from the VS Code console and keep opening files from the command line, even after VS Code reloads.

See [settings.sh](https://github.com/mrichtarsky/linux-shared/blob/main/env/settings.sh) and [functions.sh](https://github.com/mrichtarsky/linux-shared/blob/main/env/functions.sh) for bash aliases and functions available.

# Usage

It's probably best to fork this repo so you can easily make modifications and share them across your machines. In that care, replace `mrichtarsky` in the clone `curl` command with your GitHub user.

As root execute `setup_system`:
```
curl https://raw.githubusercontent.com/mrichtarsky/linux-shared/main/setup_system | bash -s -- /project/dir ssh://user@host/path/to/secrets/repo
```

The two arguments are:

- `/project/dir` - Central directory where all your projects are stored. Will be symlinked to `/p` for easy access.
- `ssh://user@host/path/to/secrets/repo` - Credential repo with private access data. (e.g. `telegram.conf` used by [telegram_notify.sh](https://github.com/mrichtarsky/linux-shared/blob/main/scripts/telegram_notify))

What does `setup_system` do?
- This repo and the credential repo are both cloned to `/root/repos/`
- Specified packages are installed (see below)
- rust is installed
- Some other `bash` add-ons are installed

Afterwards, for every user that should have the common environment, run `/r/install_for_user username` as `root`, passing the user as argument. The common config from [homedir/](https://github.com/mrichtarsky/linux-shared/tree/main/homedir) will be linked into that users' home. The credential repo will be symlinked to `~username/.secrets` and `username` added to the `linux-shared` group which has read access to the repo. Finally `source /r/_init.sh` is added to `~username/.bashrc` to set up the environment during login. `_init.sh` in turn sources `functions.sh` and `settings.sh`.

# Directory Structure

```
/r -> /root/repos/linux-shared  # This repo - Easy access to all scripts etc.
/p -> /project/dir  # Easy access to your projects
/p/tools  # Tools including the rust toolchain (note: cargo should not be used concurrently)
```

# Tools Installed

- Via package manager: `expect, git, htop, mc, nano, ncdu, python3, ripgrep, sysstatt, tmux`
- Custom: `broot, fzf, fzf tab completion, git-delta, pyp`

You can adjust this in [setup_system](https://github.com/mrichtarsky/linux-shared/blob/main/setup_system).

# Quick Docs

## pyp

https://github.com/hauntsaninja/pyp

- last expression is printed, or explicit print
- `x`, `l` or `line` - current line.
- `lines` - list of rstripped lines
- `stdin`
- `i`, `idx` or `index` - line number
- autoimported: collections, math, itertools, pathlib.Path, pprint.pp

## broot

```
br -s  # sizes
/      # regex search
c/     # search file contents
ctrl → # open dir in new panel
-w     # check what takes up bytes
```

## git-delta

- integrated into .gitconfig
- https://dandavison.github.io/delta/full---help-output.html
