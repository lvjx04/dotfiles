#!/usr/bin/env bash
set -euo pipefail

repo_url="${1:-}"
target_dir="${2:-${HOME}/Work/dotfiles}"

if [[ -z "${repo_url}" ]]; then
  printf 'Usage: %s <repo-url> [target-dir]\n' "$0" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  printf 'git is required. Install Xcode Command Line Tools first: xcode-select --install\n' >&2
  exit 1
fi

if [[ ! -d "${target_dir}/.git" ]]; then
  mkdir -p "$(dirname "${target_dir}")"
  git clone "${repo_url}" "${target_dir}"
fi

cd "${target_dir}"
./install.sh
