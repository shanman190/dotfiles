#!/usr/bin/env bash

set -e

CMDER_VERSION="v1.3.6"

curl -s -L https://github.com/cmderdev/cmder/releases/download/${CMDER_VERSION}/cmder_mini.zip -o ${DOTFILES_TEMP}/cmder_mini.zip
mkdir -p ~/opt/cmder
pushd ~/opt/cmder > /dev/null
    unzip -u ${DOTFILES_TEMP}/cmder_mini.zip
popd > /dev/null
cp ${DOTFILES_ROOT}/cmder/ConEmu.xml ~/opt/cmder/vendor/conemu-maximus5/ConEmu.xml

curl -s -L https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip -o ${DOTFILES_TEMP}/ubuntu-font-family.zip
pushd ${DOTFILES_TEMP} > /dev/null
    unzip -u ${DOTFILES_TEMP}/ubuntu-font-family.zip
popd > /dev/null

echo "Please install all contained font files. Sleeping for 30 seconds to allow time to install..."
start ${DOTFILES_TEMP}/ubuntu-font-family-0.83

sleep 30