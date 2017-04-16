#!/usr/bin/env bash
#
# bootstrap dotfiles

source scripts/common.sh

set +x

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

install_dotfiles () {
  overwrite_all=false
  backup_all=false
  skip_all=false

  # symlinks
  for file_source in $(dotfiles_find \*.symlink); do
    file_dest="${HOME}/.$(basename "${file_source%.*}")"
    install_file "link" "${file_source}" "${file_dest}"
  done

  # git repositories
  for file_source in $(dotfiles_find \*.gitrepo); do
    file_dest="${HOME}/.$(basename "${file_source%.*}")"
    install_file "git" "${file_source}" "${file_dest}"
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

run_installers  () {
  info "running installers"
  find -L . -name install.sh | while read installer ; do run "running ${installer}" "${installer}" ; done
}

install_formulas () {
  for file in $(dotfiles_find install.sdkman); do
    for formula in $(cat "${file}"); do
      sdkman_install "${formula}"
    done
  done
}

sdkman_install () {
  set +e
  export SDKMAN_DIR="/home/shannon/.sdkman"
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

if [ "$1" = "update" ]; then
  info 'updating dotfiles'
  pull_repos

  run_installers

  install_formulas
else
  info 'installing dotfiles'
  install_dotfiles

  run_installers

  install_formulas
fi

info 'complete!'
echo ''
