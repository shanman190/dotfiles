#!/usr/bin/env bash
#
# common script functions and variables

function sdkman_install() {
  set +e
  export SDKMAN_DIR="${HOME}/.sdkman"
  [[ -s ${HOME}/.sdkman/bin/sdkman-init.sh ]] && source ${HOME}/.sdkman/bin/sdkman-init.sh
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

function setup() {
  export DOTFILES_ROOT
  export DOTFILES_TEMP

  mkdir -p "${DOTFILES_TEMP}"
}

function cleanup() {
  rm -rf "${DOTFILES_TEMP}"

  unset DOTFILES_ROOT
  unset DOTFILES_TEMP
}

function git_pull() {
  local remoteRepo=$1
  local localRepo=$2

  if [[ -d ${localRepo} ]]; then
    pushd ${localRepo} > /dev/null
      git remote set-url origin ${remoteRepo}
      git pull > /dev/null
    popd > /dev/null
  else
    git clone ${remoteRepo} ${localRepo}
  fi
}

function install_script() {
  local script=$1

  running "Running script ${script}"
  
  logs=$(source ${script} 2>&1)
  if [[ $? != 0 ]]; then
    echo $logs
    exit 1
  fi
  
  ok
}

function install_vscode_extension() {
  local extension=$1

  if [[ ! -d "${DOTFILES_TEMP}/cache/" || ! -f "${DOTFILES_TEMP}/cache/packages.vscode" ]]; then
    mkdir -p "${DOTFILES_TEMP}/cache/"
    code --list-extensions > "${DOTFILES_TEMP}/cache/packages.vscode"
  fi

  running "Installing ${extension}"
  if ! cat "${DOTFILES_TEMP}/cache/packages.vscode" | grep "${package}" > /dev/null; then
    code --install-extension ${extension} > /dev/null
  fi
  ok
}
