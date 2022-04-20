# Setup script for SLES and Ubuntu development machines

Sets up a common directory structure, installs helpful tools and config files. Config files will be symlinked to the repo version and thus shared among all users. Be aware of that for `root`, and don't use this in production!

Optimized for VS Code, bash and tmux. Can reattach to running tmux sessions from the console and keep opening files from the command line.

See [settings.sh](https://github.com/mrichtarsky/linux-shared/blob/main/env/settings.sh) and [functions.sh](https://github.com/mrichtarsky/linux-shared/blob/main/env/functions.sh) for bash aliases and functions.

# Usage

```
sudo git clone https://github.com/mrichtarsky/linux-shared.git /projects/repos/linux-shared
sudo /projects/repos/linux-shared/setup_system.sh
```

You can also change `/projects/repos/linux-shared` to some other dir.

For every user that should have the setup, run `/r/install.sh` as the user.

# Directory Structure

```
/r -> /projects/repos/linux-shared  # This repo - Easy access to all scripts etc.
/p -> /projects  # Easy access to projects
/projects/tools  # Tools including the rust toolchain (note: cargo should not be used concurrently)
```

# Tools

- Via package manager: mc, tmux, htop, ncdu, git, ripgrep, python3, sysstat
- Custom: pyp, fzf, fzf tab completion, broot, git-delta

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
