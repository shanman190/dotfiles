#!/usr/bin/env bash
#
# Installs sdkman

echo $HOME

# Install zip.exe as it's needed for sdkman...
curl -L http://downloads.sourceforge.net/gnuwin32/zip-3.0-bin.zip -o ${DOTFILES_TEMP}/zip-3.0-bin.zip
mkdir -p ~/opt/zip
pushd ~/opt/zip > /dev/null
    unzip -u ${DOTFILES_TEMP}/zip-3.0-bin.zip
popd > /dev/null
cp ~/opt/zip/bin/zip.exe ~/bin/zip.exe

# Finally install sdkman
curl -L https://get.sdkman.io | bash -
