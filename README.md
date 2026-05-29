# dotfiles

My macOS dotfiles, managed with Git and GNU Stow.

## Install

```sh
git clone git@github.com:lvjx04/dotfiles.git ~/Work/dotfiles
cd ~/Work/dotfiles
./install.sh
```

`install.sh` does not install apps. It checks for required tools, backs up
existing files to `~/.dotfiles-backup/`, then links configs into `$HOME`.
Use `Brewfile` only as a reference for manual installation.

## Contents

- `zsh`: zsh, Oh My Zsh and Powerlevel10k config.
- `kitty`: kitty terminal config.
- `nvim`: Neovim config.
- `ssh`: SSH host config.

Machine-specific settings belong in `~/.zshrc.local` and `~/.zprofile.local`.
Private keys, tokens and generated session files should never be committed.
