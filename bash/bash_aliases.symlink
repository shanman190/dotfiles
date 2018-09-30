#!/usr/bin/env bash

DOTFILES="${HOME}/.dotfiles"

if [[ -d "${DOTFILES}"/bash/extras ]]; then
  for file in "${DOTFILES}"/bash/extras/*; do
    source "${file}"
  done
fi

# Put the bin/ directories first on the path
export PATH="${DOTFILES}/bin:${DOTFILES}/local/bin:${PATH}"

# enable color support
[[ -f ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

alias_files=($(find -L "${DOTFILES}" -name aliases.bash))
for file in ${alias_files}; do
  . "${file}"
done
unset alias_files

if [ "$msys" = "true" ]; then
  os_specific_alias_files=($(find -L "${DOTFILES}" -name alias.windows.bash))
else
  os_specific_alias_files=($(find -L "${DOTFILES}" -name aliases.linux.bash))
fi
for file in ${os_specific_alias_files}; do
  . "${file}"
done
unset os_specific_alias_files
