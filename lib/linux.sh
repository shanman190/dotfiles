#!/usr/bin/env bash

function install_package_repository() {
  error "Invalid usage"
  exit 1
}

function install_package() {
  if [[ $# != 1 && $# != 2 ]]; then
    error "Invalid usage"
    exit 1
  fi

  error "Not yet implemented yet..."
  exit 1
}

function link() {
  local source=$1
  local target=$2

  if [[ -z ${target} ]]; then
    unlink ${target}
  fi
  ln -s ${source} ${target}
}