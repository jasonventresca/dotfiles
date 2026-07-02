dotfiles
========

Personal dotfiles and dev environment setup for macOS and Linux. Supports both
**bash** (Linux, or Homebrew bash on macOS) and the **zsh that ships with
macOS** — shared configuration lives in one place and each shell layers its
own settings on top.

Installation
------------

```
cd ~
git clone git@github.com:jasonventresca/dotfiles.git
mv dotfiles dotfiles.jason_ventresca
~/dotfiles.jason_ventresca/bootstrap.sh
```

`bootstrap.sh` runs two scripts, which can also be run individually:

- `setup/dev_tools.sh` — installs packages (vim, tmux, jq, tree, etc.) via
  Homebrew on macOS or apt on Debian/Ubuntu, plus Vim plugins (pathogen,
  fugitive, ctrlp, ...). On macOS it also installs the zsh niceties:
  Oh My Zsh, zsh-autosuggestions, zsh-syntax-highlighting, and starship.
- `setup/dotfiles.sh` — runs `link_everything.sh` (below), and on Linux also
  appends a guarded `source` line to `~/.bash_profile`.

All symlinking lives in one script, which is idempotent — re-run it any time
to relink:

```
./link_everything.sh
```

It links the core dotfiles (`~/.vimrc`, `~/.tmux.conf`, `~/.gitconfig`,
`~/.inputrc`, `~/.bashrc`, `~/.zshrc`, ...), `~/.ssh/config`, and — on macOS —
the login-shell entry points (`~/.bash_profile`, `~/.zprofile`). Any
pre-existing real files (not symlinks) are backed up to `~/dotfiles.old/`
before being replaced.

To bootstrap a remote Ubuntu host over ssh:

```
./setup/dotfiles_remote.sh <host> <port>
```

### macOS notes

- If your login shell is still bash, switch with `chsh -s /bin/zsh`.
- The starship prompt uses Nerd Font glyphs. Set your terminal's font to an
  installed Nerd Font (e.g. *JetBrainsMono Nerd Font*) or the prompt will
  render `?` boxes. Ghostty handles this out of the box; iTerm2 needs the
  font set under Settings → Profiles → Text.
- iTerm2 preferences are tracked in this repo:
  - `setup/macos/iterm2_prefs.sh` — restore tracked prefs onto this machine
  - `setup/macos/iterm2_prefs_export.sh` — export this machine's prefs back
    into the repo (run after changing iTerm2 settings you want to keep)

Repo layout
-----------

```
bootstrap.sh              One-shot setup: dev tools + dotfile symlinks
link_everything.sh        (Re)symlink all dotfiles + ~/.ssh/config into $HOME
bin/                      Small executables, added to PATH by shell_common.sh
dotfiles/                 The actual dotfiles (symlink targets)
  shell_common.sh         Aliases/functions/exports shared by bash AND zsh
  bashrc                  bash-only settings; sources shell_common.sh
  zshrc                   zsh-only settings; sources shell_common.sh
  profile_macos.sh        Mac login-shell config shared by both shells
  bash_profile            Mac bash login entry: profile_macos.sh + bashrc
  zprofile                Mac zsh login entry: profile_macos.sh (zsh then
                          sources zshrc automatically for interactive shells)
  inputrc                 readline config (vi mode) — bash only; zshrc mirrors
                          these bindings natively with bindkey
  vimrc, vim/             Vim config and plugins (pathogen-managed)
  tmux.conf, gitconfig    tmux and git config
other_dotfiles/           Configs that don't live directly in $HOME
                          (ssh-config → ~/.ssh/config; iTerm2 plist, managed
                          by the setup/macos/iterm2_prefs*.sh scripts)
scripts/                  Standalone utility scripts (Python)
setup/                    Installation scripts
  dev_tools.sh            Package + plugin installation (macOS and Debian)
  dotfiles.sh             Shell entry-point symlinking
  dotfiles_remote.sh      Bootstrap a remote Ubuntu host
  macos/, debian/, linux/ Platform-specific extras
util/                     Helpers sourced by setup scripts (platform detection)
```

How the shell config fits together
----------------------------------

```
zsh (macOS):   ~/.zprofile ─→ profile_macos.sh
               ~/.zshrc    ─→ oh-my-zsh → zsh options/keybindings
                              → shell_common.sh → starship/plugins

bash (macOS):  ~/.bash_profile ─→ profile_macos.sh
                                  → bashrc ─→ bash options → shell_common.sh

bash (Linux):  ~/.bash_profile sources dotfiles/bashrc (guarded by an env
               var so it only applies to my sessions on shared hosts)
```

The rule of thumb for where things go:

- **`shell_common.sh`** — anything that works in both shells: aliases,
  functions, exports, PATH entries. Keep it portable (no `shopt`, no
  `setopt`, no bash arrays, quote `"$@"` in loops).
- **`bashrc`** — bash-only: `shopt`, `HISTCONTROL`, readline/`INPUTRC`,
  bash-completion.
- **`zshrc`** — zsh-only: `setopt`, `bindkey`, completion, prompt plugins.
- **`profile_macos.sh`** — macOS login-shell one-timers: `brew shellenv`,
  `ssh-add`, machine-specific PATH entries.

Everyday usage
--------------

- `source-rc` — reload the config for whichever shell you're in
  (`source-bashrc` / `source-zshrc` also exist)
- `dotfiles-reload` — `git pull` this repo, then reload
- `edit-config <file>` — open a dotfile in vim, e.g. `edit-config zshrc`
- The full alias/function catalog lives in `dotfiles/shell_common.sh` —
  highlights: `ll`/`la`/`lf`/`ld`, `gits`/`gitd`/`gitco`, `g` (recursive
  source grep), `jsonp`, `tf`/`tfp`, `wt`/`cd-wt` (git worktrees)

Developing on this repo
-----------------------

Because `~/.zshrc` etc. are symlinks, edits to files under `dotfiles/` take
effect in your next shell (or immediately via `source-rc`) — there is no
build or install step for config-only changes. New *files* need wiring in
`link_everything.sh`.

Before committing shell changes, sanity-check both shells:

```
# syntax
bash -n dotfiles/bashrc dotfiles/shell_common.sh dotfiles/profile_macos.sh
zsh  -n dotfiles/zshrc  dotfiles/shell_common.sh dotfiles/profile_macos.sh

# smoke test: do aliases/functions actually load?
bash --noprofile --norc -c 'PS1=x source dotfiles/bashrc && alias ll && type rebase'
zsh -f -c 'source dotfiles/zshrc && alias ll && whence -w rebase'
```

Gotchas worth knowing:

- zsh does **not** word-split unquoted variables like bash does. Shared
  functions must not rely on `$var` expanding to multiple arguments — use
  `"$@"` loops or `eval` (see `grep_multi` for an example).
- `git` and `vim` are aliased to run with `HOME=$DOTFILES` so they pick up
  the repo's `gitconfig`/`vimrc` without symlinking those into `$HOME`.
  (`vim` gets the real home back via `REAL_HOME`.)
- `inputrc` only affects bash/readline. Keybinding changes there should be
  mirrored in the `bindkey` section of `zshrc` (e.g. `jj` → escape,
  `jrr` → reverse history search, `jae` → expand aliases).
- Vim plugins under `dotfiles/vim/bundle/` are vendored directly (not
  submodules); `setup/dev_tools.sh` clones missing ones.
