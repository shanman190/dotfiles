#!/usr/bin/env bash

function install_package_repository() {
  if [[ $# != 2 ]]; then
    error "Invalid usage"
    exit 1
  fi

  local name=$1
  local repo=$2
  
  choco source add -n="${name}" -s="${repo}"
}

function install_package() {
  if [[ $# != 1 && $# != 2 ]]; then
    error "Invalid usage"
    exit 1
  fi

  local package=$1
  if [[ $# == 2 ]]; then
    local version=$2

    running "Installing ${package}:${version}"

    if ! choco list "${package}" --version ${version} 2> /dev/null | grep -q -i -E "^${package}\s"; then
      error "Could not find package: ${package}:${version}"
      exit 1
    fi

    set +e
    logs=$(choco install "${package}" --version "${version}" --yes)
    if [[ $? != 0 ]]; then
      echo $logs
      exit 1
    fi
    set -e
    ok
  else
    running "Installing ${package}"

    if ! choco list "${package}" 2> /dev/null | grep -q -i -E "^${package}\s"; then
      error "Could not find package: ${package}"
      exit 1
    fi

    set +e
    logs=$(choco install "${package}" --yes)
    if [[ $? != 0 ]]; then
      echo $logs
      exit 1
    fi
    set -e
    ok
  fi
}

function link() {
  local source=$1
  local target=$2

  if [[ "$MSYS" == *"winsymlinks:nativestrict"* ]]; then
    if [[ ! -L ${target} ]]; then
      ln -s ${source} ${target}
    fi
  else
    if [[ -f ${target} ]]; then
      rm ${target}
    fi
    cp ${source} ${target}
  fi
}
