#!/usr/bin/env bash

set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_TEMP="${DOTFILES_ROOT}/tmp"

# OS specific support (must be 'true' or 'false').
msys=false
case "`uname`" in
  MINGW* )
    msys=true
    ;;
esac

# include helper libraries
source lib/echos.sh
source lib/requirers.sh
source lib/common.sh
if [ "$msys" = "true" ]; then
  source lib/windows.sh
else
  source lib/linux.sh
fi

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

#################################################
bot "Checking requirements..."
#################################################
requires_git
if [ "$msys" = "true" ]; then
  requires_choco
fi

ok "Your system has all of the required software. Let's get to work!"

setup

# Execute
bot "Cloning Git repos"

running "Cloning gdub (gw)..."
git_pull "https://github.com/dougborg/gdub.git" "${HOME}/.gw"
link "${HOME}/.gw/bin/gw" "${HOME}/bin/gw"
ok

ok "Finished cloning git repos"

## Install dotfiles
if [[ ! -f ./homedir/.gitconfig ]] || grep "name = GIT_FULLNAME" ./homedir/.gitconfig > /dev/null 2>&1 ; then
  read -r -p "What is your first name? " firstname
  read -r -p "What is your last name? " lastname

  fullname="${firstname} ${lastname}"

  bot "Great ${fullname}, "

  read -r -p "What is your email address? " email
  if [[ ! $email ]]; then
    error "You must provide an email to configure .gitconfig"
    exit 1
  fi

  running "Replacing items in .gitconfig with your info (${COL_YELLOW}${fullname}, ${email}${COL_RESET})"

  cp ./homedir/.gitconfig.template ./homedir/.gitconfig
  sed -i "s/GIT_FULLNAME/${fullname}/" ./homedir/.gitconfig
  sed -i "s/GIT_EMAIL/${email}/" ./homedir/.gitconfig
  if [ "$msys" = "true" ]; then
    sed -i "s/CORE_AUTOCRLF/true/" ./homedir/.gitconfig
  else
    sed -i "s/CORE_AUTOCRLF/input/" ./homedir/.gitconfig
  fi
fi

bot "Creating symlinks for project dotfiles..."

pushd ./homedir > /dev/null
  for file in .*; do
    if [[ "${file}" == "." || "${file}" == ".." || "${file}" == ".gitconfig.template" ]]; then
      continue
    fi

    running "linking ~/${file} ..."
    link "${DOTFILES_ROOT}/homedir/${file}" "${HOME}/${file}"
    ok
  done
popd > /dev/null

ok "Finished installing dotfiles"

## Install applications
bot "Installing applications..."

if [ "$msys" = "true" ]; then
  install_package "chocolatey"
  install_package "7zip"
  install_package "ditto"
  install_package "docker-toolbox"
  install_package "notepadplusplus"
  install_package "virtualbox"
  install_package "vscode"
  install_package "wiztree"

  install_script "${DOTFILES_ROOT}/cmder/install.windows.sh"
  install_script "${DOTFILES_ROOT}/sdkman/install.windows.sh"
else
  install_script "${DOTFILES_ROOT}/sdkman/install.linux.sh"
fi

ok "Finished installing applications"

## Install vscode extensions
bot "Installing VS Code extensions"

install_vscode_extension "ms-vscode.go"

ok "Finished installing VS Code extensions"

cleanup

bot "Woot! All done. Kill this terminal and launch Bash"
