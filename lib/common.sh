#!/usr/bin/env bash
#
# common script functions and variables

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
DOTFILES_TEMP="${DOTFILES_ROOT}/tmp"

set -e

info () {
  printf "  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user () {
  printf "  [ \033[0;33m??\033[0m ] %s " "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [ \033[0;31m!!\033[0m ] %s\n" "$1"
  echo ""
  exit
}

run () {
  set +e
  info "$1"
  output=$($2 2>&1)
  if [ $? -ne 0 ]; then
    fail "failed to run '$1': $output"
    exit
  fi
  set -e
}

dotfiles_find () {
  if [ "$msys" = "true" ]; then
    find -L "${DOTFILES_ROOT}" -maxdepth 3 -name "$1" | grep -v  ".linux."
  else
    find -L "${DOTFILES_ROOT}" -maxdepth 3 -name "$1" | grep -v ".windows."
  fi
}

link_files () {
  case "$1" in
    link )
      link_file "$2" "$3"
      ;;
    copy )
      copy_file "$2" "$3"
      ;;
    git )
      git_clone "$2" "$3"
      ;;
    * )
      fail "Unknown link type: $1"
      ;;
  esac
}

link_file () {
  ln -s "$1" "$2"
  success "linked $1 to $2"
}

copy_file () {
  cp "$1" "$2"
  success "copied $1 to $2"
}

git_clone () {
  repo=$(head -n 1 "$1")
  dest="$2"
  if ! git clone --quiet "$repo" "$dest"; then
    fail "clone from $repo failed"
  fi

  success "cloned $repo to $(basename "$dest")"

  dir=$(dirname "$1")
  base=$(basename "${1%.*}")
  for patch in $(find "${dir}" -maxdepth 2 -name "${base}\*.gitpatch"); do
    pushd "$dest" >> /dev/null
    if ! git am --quiet "$patch"; then
      fail "apply patch failed"
    fi

    sucess "applied $patch"
    popd >> /dev/null
  done
}

install_file () {
  file_type="$1"
  file_source="$2"
  file_dest="$3"
  if [ -f "${file_dest}" ] || [ -d "${file_dest}" ]; then
    overwrite=false
    backup=false
    skip=false

    if [ "${overwrite_all}" == "false" ] && [ "${backup_all}" == "false" ] && [ "${skip_all}" == "false" ]; then
      user "File already exists: $(basename "${file_dest}"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -n 1 action

      case "${action}" in
        o )
          overwrite=true;;
        O )
          overwrite_all=true;;
        b )
          backup=true;;
        B )
          backup_all=true;;
        s )
          skip=true;;
        S )
          skip_all=true;;
        * )
          ;;
      esac
    fi

    if [ "${overwrite}" == "true" ] || [ "${overwrite_all}" == "true" ]; then
      rm -rf "${file_dest}"
      success "removed ${file_dest}"
    fi

    if [ "${backup}" == "true" ] || [ "${backup_all}" == "true" ]; then
      mv "${file_dest}" "${file_dest}\.backup"
      success "moved ${file_dest} to ${file_dest}.backup"
    fi

    if [ "${skip}" == "false" ] && [ "${skip_all}" == "false" ]; then
      link_files "${file_type}" "${file_source}" "${file_dest}"
    else
      success "skipped ${file_source}"
    fi
  else
    link_files "${file_type}" "${file_source}" "${file_dest}"
  fi
}

pull_repos () {
  for file in $(dotfiles_find \*.gitrepo); do
    repo="${HOME}/.$(basename "${file%.*}")"
    pushd "${repo}" > /dev/null
    if ! git pull --rebase --quiet origin master; then
      fail "could not update ${repo}"
    fi
    success "updated ${repo}"
    popd >> /dev/null
  done
}

sdkman_install () {
  set +e
  #export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh
  IFS=':' read -a formula <<< "$1"
  if ! sdk list "${formula[0]}" 2> /dev/null | grep -q "* ${formula[1]}"; then
    output=$(echo 'n' | sdk install ${formula[0]} ${formula[1]} 2>&1)
    if [ $? -eq 0 ]; then
      success "installed ${formula[0]}:${formula[1]}"
    else
      fail "failed to install ${formula[0]}:${formula[1]}: ${output}"
      exit
    fi
  fi
  set -e
}

setup () {
  export DOTFILES_ROOT
  export DOTFILES_TEMP

  mkdir -p "${DOTFILES_TEMP}"
}

cleanup () {
  rm -rf "${DOTFILES_TEMP}"
}