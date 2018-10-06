#!/usr/bin/env bash

function install_package() {
  if [[ $# != 1 && $# != 2 ]]; then
    error "Invalid usage"
    exit 1
  fi

  local package=$1
  if [[ $# == 2 ]]; then
    local version=$2

    running "Installing ${package}:${version}"

    if ! choco list "${package}" --version ${version} 2> /dev/null | grep -q -E "^${package}\s"; then
      error "Could not find package: ${package}:${version}"
      exit 1
    fi

    choco install "${package}" --version "${version}" --yes > /dev/null
    ok
  else
    running "Installing ${package}"

    if ! choco list "${package}" 2> /dev/null | grep -q -E "^${package}\s"; then
      error "Could not find package: ${package}"
      exit 1
    fi

    choco install "${package}" --yes > /dev/null
    ok
  fi
}

function link() {
  local source=$1
  local target=$2

  if [[ -f ${target} ]]; then
    rm ${target}
  fi
  cp ${source} ${target}
}