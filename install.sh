#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${repo_root}"

default_packages=(zsh kitty nvim ssh)
if [[ $# -gt 0 ]]; then
  packages=("$@")
else
  packages=("${default_packages[@]}")
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This bootstrap script is written for macOS.\n' >&2
  exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
  printf 'GNU Stow is required. Install it manually, then re-run ./install.sh.\n' >&2
  printf 'Suggested command: brew install stow\n' >&2
  exit 1
fi

missing=()
for command_name in zsh kitty nvim; do
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    missing+=("${command_name}")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  printf 'Warning: missing optional commands: %s\n' "${missing[*]}" >&2
  printf 'Install them manually if you want the corresponding configs to be useful.\n' >&2
fi

printf 'Backing up existing files...\n'
"${repo_root}/scripts/backup-existing.sh" "${packages[@]}"

printf 'Linking dotfiles with GNU Stow...\n'
stow --dir="${repo_root}" --target="${HOME}" --verbose "${packages[@]}"

printf '\nDone.\n'
printf 'Optional next steps:\n'
printf '  - Install dependencies manually. See Brewfile for a reference list.\n'
printf '  - Install Oh My Zsh if missing: https://ohmyz.sh\n'
printf '  - Install Powerlevel10k under ~/.oh-my-zsh/custom/themes if missing.\n'
printf '  - Install zsh-autosuggestions and zsh-syntax-highlighting plugins if missing.\n'
printf '  - Copy local/*.example to ~/.zshrc.local or ~/.zprofile.local for machine-specific settings.\n'
