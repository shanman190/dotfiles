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
    file_dest="${HOME}/.$(basename "${file_source%.*}")"
    install_file "link" "${file_source}" "${file_dest}"
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
  find -L . -name install.linux.sh | while read installer ; do run "running ${installer}" "${installer}" ; done
}

install_formulas () {
  for file in $(dotfiles_find install.sdkman); do
    for formula in $(cat "${file}"); do
      sdkman_install "${formula}"
    done
  done
}

bootstrap_install () {
  install_dotfiles

  run_installers

  install_formulas
}

bootstrap_update () {

}