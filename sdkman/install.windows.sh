#!/usr/bin/env bash
#
# Installs sdkman

# Install zip.exe as it's needed for sdkman...
running "Installing sdkman"
if [[ -d ~/opt/zip ]]; then
    curl -q -s -L http://downloads.sourceforge.net/gnuwin32/zip-3.0-bin.zip -o ${DOTFILES_TEMP}/zip-3.0-bin.zip
    mkdir -p ~/opt/zip
    pushd ~/opt/zip > /dev/null
        unzip -u ${DOTFILES_TEMP}/zip-3.0-bin.zip > /dev/null
    popd > /dev/null
    cp ~/opt/zip/bin/zip.exe ~/bin/zip.exe
fi

# Finally install sdkman
if [[ -d ~/.sdkman ]]; then
    export SDKMAN_DIR="${HOME}/.sdkman"
    [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
    
    sdk selfupdate
else
    curl -L https://get.sdkman.io | bash -
fi
