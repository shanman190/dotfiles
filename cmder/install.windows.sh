#!/usr/bin/env bash

set -e

CMDER_VERSION="v1.3.14"

running "Installing cmder"
if [[ ! -d ~/opt/cmder ]]; then
    curl -q -s -L https://github.com/cmderdev/cmder/releases/download/${CMDER_VERSION}/cmder_mini.zip -o ${DOTFILES_TEMP}/cmder_mini.zip
    mkdir -p ~/opt/cmder
    pushd ~/opt/cmder > /dev/null
        unzip -u ${DOTFILES_TEMP}/cmder_mini.zip > /dev/null
    popd > /dev/null
    ln -s ${DOTFILES_ROOT}/cmder/ConEmu.xml ~/opt/cmder/config/user-ConEmu.xml
fi
ok

if [[ ! (-n "$(ls -A /c/Windows/Fonts/Ubuntu* 2> /dev/null)" || -n "$(ls -A ${HOME}/AppData/Local/Microsoft/Windows/Fonts/Ubuntu* 2> /dev/null)") ]]; then
    curl -q -s -L https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip -o ${DOTFILES_TEMP}/ubuntu-font-family.zip
    pushd ${DOTFILES_TEMP} > /dev/null
        unzip -u ${DOTFILES_TEMP}/ubuntu-font-family.zip > /dev/null
    popd > /dev/null

    action "Please install all contained font files. Press any key to continue"
    start ${DOTFILES_TEMP}/ubuntu-font-family-0.83

    read -n 1 junk
    ok
fi
