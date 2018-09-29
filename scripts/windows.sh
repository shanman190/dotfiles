#!/usr/bin/env bash
#
# bootstrap dotfiles

source scripts/common.sh

install_dotfiles () {
  overwrite_all=false
  backup_all=false
  skip_all=false

  # symlinks
  for file_source in $(dotfiles_find \*.symlink); do
    file_name="${file_source%.*}"
    file_name="${file_name%.*}"
    file_dest="${HOME}/.$(basename "${file_name}")"
    install_file "copy" "${file_source}" "${file_dest}"
  done

  # git repositories
  for file_source in $(dotfiles_find \*.gitrepo); do
    file_dest="${HOME}/.$(basename "${file_source%.*}")"
    install_file "git" "${file_source}" "${file_dest}"
  done
}

run_installers  () {
  info "running installers"
  find -L . -name install.sh | while read installer ; do run "running ${installer}" "${installer}" ; done
  find -L . -name install.windows.sh | while read installer ; do run "running ${installer}" "${installer}" ; done
}

choco_install () {
  set +e
  IFS=':' read -a formula <<< "$1"
  if ! choco list "${formula[0]}" 2> /dev/null | grep -q -E "^${formula[1]}\s"; then
    if [ ${#formula} -gt 1 ]; then
      output=$(choco install ${formula[0]} -y 2>&1)
      if [ $? -eq 0 ]; then
        success "installed ${formula[0]}"
      else
        fail "failed to install ${formula[0]}: ${output}"
        exit
      fi
    else
      output=$(choco install ${formula[0]} --version ${formula[1]} -y 2>&1)
      if [ $? -eq 0 ]; then
        success "installed ${formula[0]}:${formula[1]}"
      else
        fail "failed to install ${formula[0]}:${formula[1]}: ${output}"
        exit
      fi
    fi
  fi
  set -e
}

install_sdkman_formulas () {
  for file in $(dotfiles_find install.sdkman); do
    for formula in $(cat "${file}"); do
      sdkman_install "${formula}"
    done
  done
}

install_choco_formulas () {
  for file in $(dotfiles_find install.choco); do
    for formula in $(cat "${file}"); do
      choco_install "${formula}"
    done
  done
}

bootstrap_install () {
  install_dotfiles

  run_installers

  install_sdkman_formulas

  install_choco_formulas

  return
}

bootstrap_update () {
  return
}