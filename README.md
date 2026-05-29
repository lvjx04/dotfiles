# dotfiles

My macOS dotfiles, managed with Git and GNU Stow.

## Install

```sh
git clone git@github.com:lvjx04/dotfiles.git ~/Work/dotfiles
cd ~/Work/dotfiles
./install.sh
```

`install.sh` installs Homebrew dependencies, backs up existing files to
`~/.dotfiles-backup/`, then links configs into `$HOME`.

## Contents

- `zsh`: zsh, Oh My Zsh and Powerlevel10k config.
- `kitty`: kitty terminal config.
- `git`: Git config and global ignore rules.
- `nvim`: Neovim config.
- `fish`: Fish config.
- `ssh`: SSH config example only.

Machine-specific settings belong in `~/.zshrc.local` and `~/.zprofile.local`.
Private keys, tokens and generated session files should never be committed.
