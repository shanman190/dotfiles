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
function_files=($(find -L "${DOTFILES}" -name functions.bash))
for file in ${function_files}; do
  . "${file}"
done
unset function_files

if [ "$msys" = "true" ]; then
  os_specific_alias_files=($(find -L "${DOTFILES}" -name aliases.windows.bash))
  os_specific_function_files=($(find -L "${DOTFILES}" -name functions.windows.bash))
else
  os_specific_alias_files=($(find -L "${DOTFILES}" -name aliases.linux.bash))
  os_specific_function_files=($(find -L "${DOTFILES}" -name functions.linux.bash))
fi
for file in ${os_specific_alias_files}; do
  . "${file}"
done
for file in ${os_specific_function_files}; do
  . "${file}"
done
unset os_specific_alias_files
unset os_specific_function_files
