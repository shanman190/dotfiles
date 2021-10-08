#!/usr/bin/env bash

function install_package_repository() {
  error "Invalid usage"
  exit 1
}

function install_package() {
  if [[ $# < 1 || 3 < $# ]]; then
    error "Invalid usage"
    exit 1
  fi

  local package_type=$1
  if [[ $# == 3 ]]; then
    _install_${package_type}_package $2 $3
  else
    _install_${package_type}_package $2
  fi
}

function _install_apt_package() {
  if [[ $# < 1 || 2 < $# ]]; then
    error "Invalid usage"
    exit 1
  fi

  local package=$1
  if [[ $# == 2 ]]; then
    local options=$2
    sudo apt install ${package} ${options}
  else
    sudo apt install ${package}
  fi
}

function _install_snap_package() {
  if [[ $# < 1 || 2 < $# ]]; then
    error "Invalid usage"
    exit 1
  fi

  local package=$1
  running "Installing ${package}"
    
  if ! snap search ${package} | grep -q -i -E "^${package}\s"; then
    error "Could not find package: ${package}"
    exit 1
  fi
    
  set +e
  logs=$(sudo snap install ${package} ${@:2} 2>&1)
  if [[ $? != 0 ]]; then
    echo $logs
    exit 1
  fi
  set -e
  ok
}

function link() {
  local source=$1
  local target=$2
  
  if [[ -L ${target} ]]; then
    unlink ${target}
  fi
  ln -s ${source} ${target}
}
