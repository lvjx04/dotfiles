#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${repo_root}"

default_packages=(zsh kitty git nvim fish)
if [[ $# -gt 0 ]]; then
  packages=("$@")
else
  packages=("${default_packages[@]}")
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This bootstrap script is written for macOS.\n' >&2
  exit 1
fi

if ! command -v xcode-select >/dev/null 2>&1 || ! xcode-select -p >/dev/null 2>&1; then
  printf 'Installing Xcode Command Line Tools...\n'
  xcode-select --install || true
  printf 'Re-run ./install.sh after Command Line Tools finish installing.\n'
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is not installed. Install it from https://brew.sh, then re-run ./install.sh.\n' >&2
  exit 1
fi

eval "$(brew shellenv)"

printf 'Installing Homebrew dependencies...\n'
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file="${repo_root}/Brewfile"

if ! command -v stow >/dev/null 2>&1; then
  printf 'GNU Stow is required but was not found after brew bundle.\n' >&2
  exit 1
fi

printf 'Backing up existing files...\n'
"${repo_root}/scripts/backup-existing.sh" "${packages[@]}"

printf 'Linking dotfiles with GNU Stow...\n'
stow --dir="${repo_root}" --target="${HOME}" --verbose "${packages[@]}"

printf '\nDone.\n'
printf 'Optional next steps:\n'
printf '  - Install Oh My Zsh if missing: https://ohmyz.sh\n'
printf '  - Install Powerlevel10k under ~/.oh-my-zsh/custom/themes if missing.\n'
printf '  - Install zsh-autosuggestions and zsh-syntax-highlighting plugins if missing.\n'
printf '  - Copy local/*.example to ~/.zshrc.local or ~/.zprofile.local for machine-specific settings.\n'
