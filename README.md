# Common environment for development machines

Quickly get up and running on a new server/VM with the environment you are used to. Sets up a common directory structure, installs helpful tools and config files. Provides helper libs (Python, bash), including credentials management.

I'm currently using this on:
- x86_64:
    - Debian/Ubuntu
    - SLES
    - Red Hat
- aarch64 Graviton3 (AWS)
    - SLES
- aarch64 macOS (Apple Silicon)

It could be adapted to more environments of course.

Config files will be symlinked to the repo version and thus be shared among all users. Be aware of that for `root`, and don't use this in production!

Optimized for VS Code, bash and tmux. Can reattach to running tmux sessions from the VS Code console and keep opening files from inside tmux into VS Code, even after VS Code has reloaded.

See [settings.sh](https://github.com/mrichtarsky/linux-shared/blob/main/env/settings.sh) and [functions.sh](https://github.com/mrichtarsky/linux-shared/blob/main/env/functions.sh) for bash aliases and functions available.

# Usage

It's probably best to fork this repo so you can easily make modifications. In that case, set `GITHUB_USER` in the command below to your GitHub user.

As `root` execute `setup_system`:
``` sh
export GITHUB_USER=mrichtarsky; curl -sSf https://raw.githubusercontent.com/$GITHUB_USER/linux-shared/main/setup/setup_system | bash -s -- /project/dir ssh://user@host/path/to/secrets/repo
```

The two arguments are:

- `/project/dir` - Central directory where all your projects are stored. Will be symlinked to `/p` for easy access. **Warning**: Do not use your home directory for this, since it will be made group readable, which some SSH daemons don't like and will prevent login.
- `ssh://user@host/path/to/secrets/repo` - Credential repo with private access data. (e.g. your email or `telegram.conf` used by [telegram_notify.sh](https://github.com/mrichtarsky/linux-shared/blob/main/scripts/telegram_notify)). If you don't have one just create an empty one somewhere, reference it here and populate it later.

What does `setup_system` do?
- This repo and the credential repo are both cloned to `/repos/`
- Specified packages are installed (see below)
- `rust` is installed
- Some other `bash` add-ons are installed
- Cronjobs are added for:
  - Detecting modifications of the repo (which should be committed and pushed)
  - Auto-updating from the latest central state, including install
  - Cleaning disk caches

Afterwards, for every user that should have the common environment, run `/r/setup/install_for_user username` as `root`, passing the user as argument. The common config from [homedir/](https://github.com/mrichtarsky/linux-shared/tree/main/homedir) will be linked into that users' home. The credential repo will be symlinked to `~username/.secrets` and `username` added to the `linux-shared` group which has read access to the repo. Finally `source /r/_init.sh` is added to `~username/.bashrc` to set up the environment during login. `_init.sh` in turn sources `functions.sh` and `settings.sh`.

**Note**: If you are running `install_for_user` from a VS Code shell, the group membership will not be refreshed until you restart the VS Code server (`pkill -f vscode-server`)

# Directory Structure

``` sh
/r -> /repos/linux-shared  # This repo - Easy access to all scripts etc.
/p -> /project/dir  # Easy access to your projects
/p/tools  # Tools including the rust toolchain (note: cargo should not be used concurrently)
```

# Tools Installed

- Via package manager: `duf, expect, fswatch [not on SLES], git, htop, mc, moreutils, nano, ncdu, nnn, progress, python3, ripgrep, shellcheck, sysstat, tmux, tree, ugrep [not on SLES], yank`
- Custom: `bashmarks, bat, bottom, broot, btop, choose, cht.sh, du-dust, fd, easy-move+resize [macOS only], forgit, fzf, fzf-obc, git, git-delta, gron, httm, hyperfine, lazydocker, libtree, lsd, tmux plugin manager, viddy, zenith, zoxide`
- Python: `pyp,  rich, telegram-send, trash-cli`
- tmux plugins: `extracto`

You can adjust this in [setup_system](https://github.com/mrichtarsky/linux-shared/blob/main/setup/setup_system).

# Mail Server Setup

All mail to local accounts is forwarded to a remote account. The email of that account is taken from the `notify_email` file in the `secrets` repo. You need to have a working email setup that can send emails from your server to that address. Since the setup is much too complex to generalize, you have to do that manually. Here's an example how to configure Postfix after you have set up your server according to the **Usage** section above.

- Install `postfix`
- In `/etc/postfix/main.cf` make sure these are set:
  - If you have a mail server that accepts email from your server just by virtue of its IP address/PTR record:
    ```
    myhostname = FQDN of your server
    mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
    relayhost = FQDN:port_of_mail_server that accepts email from your server
    alias_maps = lmdb:/etc/aliases or hash:/etc/aliases
    smtp_tls_security_level = encrypt
    ```
  - If you need to authenticate with your mail server also add these:
    ```
    smtp_sasl_auth_enable = yes
    smtp_sasl_tls_security_options = noanonymous
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    ```
    - Generate `/etc/postfix/sasl_passwd` with the following content:
      ```
      FQDN:port_of_mail_server   user:password
      ```
    - Run `sudo postmap /etc/postfix/sasl_passwd`
    - Run `sudo chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db`
- Run `sudo newaliases` to generate the alias DB
- Run `systemctl reload postfix`
- Test whether email can be delivered: `echo 'test' | mail root -s test`

# Tools Docs

## [bashmarks](https://github.com/huyng/bashmarks)

```
ds <bookmark_name>    - Saves the current directory as "bookmark_name"
j, dj <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
dp <bookmark_name>    - Prints the directory associated with "bookmark_name"
dd <bookmark_name>    - Deletes the bookmark
dl                    - Lists all available bookmarks
```

## [bottom](https://github.com/ClementTsang/bottom)

## [broot](https://github.com/Canop/broot)

``` sh
br -s  # sizes
/      # regex search
c/     # search file contents
ctrl → # open dir in new panel
-w     # check what takes up bytes
```

## [choose](https://github.com/theryangeary/choose)

## [cht.sh](https://github.com/chubin/cheat.sh)

## [Easy Move+Resize](https://github.com/dmarcotte/easy-move-resize) [macOS only]

## [fzf-tab-completion](https://github.com/lincheney/fzf-tab-completion)

## [git-delta](https://github.com/dandavison/delta)

- integrated into .gitconfig
- https://dandavison.github.io/delta/full---help-output.html

## [forgit](https://github.com/wfxr/forgit)

## [httm](https://github.com/kimono-koans/httm)

- ZFS navigator

## [hyperfine](https://github.com/sharkdp/hyperfine)

## [lazydocker](https://github.com/jesseduffield/lazydocker)

## [lsd](https://github.com/lsd-rs/lsd)

## [nnn](https://github.com/jarun/nnn)

## [progress](https://github.com/Xfennec/progress)

## [pyp](https://github.com/hauntsaninja/pyp)

- last expression is printed, or explicit print
- `x`, `l` or `line` - current line.
- `lines` - list of rstripped lines
- `stdin`
- `i`, `idx` or `index` - line number
- autoimported: collections, math, itertools, pathlib.Path, pprint.pp

## [symbex](https://github.com/simonw/symbex)

- Find definition of functions, classes in sources on disk
- `symbex my_func`

## [tmux plugin manager](https://github.com/tmux-plugins/tpm)

- Press `prefix + I (capital i, as in Install)` to fetch the plugins.

## [tmux-extracto](https://github.com/laktak/extrakto)

## [trash-cli](https://github.com/andreafrancia/trash-cli)

## [ugrep](https://github.com/Genivia/ugrep)

- grep TUI

## [vidir](https://man.archlinux.org/man/community/moreutils/vidir.1.en)

## [zmv](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv)

## [Zoxide](https://github.com/ajeetdsouza/zoxide)

# Libraries

There are custom libraries for languages located in `lib/` (Python and bash at the moment). They are used by some of the scripts contained in this repo, but can also be used by other scripts.

## Python

For any user set up with this script, `PYTHONPATH` already includes the library dir, so the libraries can be used for any code running in the environment of the user. Typically this is not the case for cron jobs, but the version of `cronic` included in this repo has been modified to source the custom environment.

## `tools.secrets`
Functions for dealing with passwords. They are stored encrypted on disk using the `keyring` library.

- For any operations using the key store, set the environment variable `KEY` to your passphrase
- Credendials are defined in the `secrets` repo (see above) in `add_credentials.setup()`:
  ```
  def setup(addCredential):
      addCredential(system1, user1)
      addCredential(system1, user2)
      addCredential(system2, user1)
      ...
  ```
- Passwords for the defined credentials are added via `/r/s/keyring_add system user` (password will be
  prompted). The keyring is located at `/repos/secrets/keyring`.
- Passwords will be decrypted on demand:
  ```
  from tools.secrets import credentials

  login(credentials.hackernews.user,
        credentials.hackernews.password)

  ```

## Bash

To use the bash tools, source them with an absolute path, e.g. `source /r/lib/bash/tools.sh`.

# Updating

There is a built-in update mechanism. So if you make any modifications to the tools
installed system-wide (in [setup_system](https://github.com/mrichtarsky/linux-shared/blob/main/setup/setup_system))
or per user ([install_for_user](https://github.com/mrichtarsky/linux-shared/blob/main/setup/_impl/install_for_user)),
you only need to bump the version in [SYSTEM_VERSION](https://github.com/mrichtarsky/linux-shared/blob/main/setup/SYSTEM_VERSION)
or [USER_VERSION](https://github.com/mrichtarsky/linux-shared/blob/main/setup/USER_VERSION).
Then commit and push these changes.

A [cronjob](https://github.com/mrichtarsky/linux-shared/blob/main/scripts/git/pull) will
automatically fetch the latest update on all machines and update to it. When the
`SYSTEM_VERSION` did change, `setup_system` is re-run, otherwise only `install_for_user` for each user that has the environment set up.

You can also trigger the update manually by running `/r/setup/update`.

# Misc

- The git prompt can slow things down for large repos. Disable on a repo basis as follows:

``` sh
$ cd $repo
$ git config prompt.ignore 1
```

- A `sitecustomize.py` script is added so Python reports more info during an exception. However, Debian already has `/usr/lib/python3.xx/sitecustomize.py` with a (pretty useless) `apport` hook which takes precedence over our hook. If you don't need the `apport` hook just delete it and the error reporting hook will work.


# ToDo

- Do not use /usr/local/bin but /p/tools/bin
- Move /repos to /p
