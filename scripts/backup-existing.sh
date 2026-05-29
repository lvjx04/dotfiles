#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_home="${HOME}"
timestamp="${DOTFILES_BACKUP_TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"
backup_root="${DOTFILES_BACKUP_DIR:-${target_home}/.dotfiles-backup/${timestamp}}"

packages=("$@")
if [[ ${#packages[@]} -eq 0 ]]; then
  packages=(zsh kitty git nvim fish)
fi

mkdir -p "${backup_root}"

backup_path() {
  local source_path="$1"
  local relative_path="${source_path#${repo_root}/*/}"
  local target_path="${target_home}/${relative_path}"

  if [[ -L "${target_path}" ]]; then
    local link_target
    local resolved_target
    link_target="$(readlink "${target_path}")"
    if [[ "${link_target}" = /* ]]; then
      resolved_target="${link_target}"
    else
      resolved_target="$(cd "$(dirname "${target_path}")" && cd "$(dirname "${link_target}")" && pwd)/$(basename "${link_target}")"
    fi
    case "${resolved_target}" in
      "${repo_root}"/*)
        return 0
        ;;
    esac
  fi

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    local backup_path="${backup_root}/${relative_path}"
    mkdir -p "$(dirname "${backup_path}")"
    mv "${target_path}" "${backup_path}"
    printf 'Backed up %s -> %s\n' "${target_path}" "${backup_path}"
  fi
}

for package in "${packages[@]}"; do
  package_dir="${repo_root}/${package}"
  [[ -d "${package_dir}" ]] || continue

  while IFS= read -r -d '' source_path; do
    backup_path "${source_path}"
  done < <(find "${package_dir}" -mindepth 1 -type f -print0)
done

printf 'Backup directory: %s\n' "${backup_root}"
