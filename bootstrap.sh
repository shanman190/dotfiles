#!/usr/bin/env bash

set -e

# OS specific support (must be 'true' or 'false').
msys=false
case "`uname`" in
  MINGW* )
    msys=true
    ;;
esac

# Source scripts
if [ "$msys" = "true" ]; then
  source scripts/windows.sh
else
  source scripts/linux.sh
fi


# Execute
setup
if [ "$1" = "update" ]; then
  info 'updating dotfiles'
  pull_repos

  run_installers

  install_formulas
else
  info 'installing dotfiles'
  bootstrap_install
fi
cleanup

info 'complete!'
echo ''
