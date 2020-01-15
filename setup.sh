#!/usr/bin/env bash

git clone https://github.com/shanman190/dotfiles.git "${HOME}/.dotfiles/"

read -r -p "Do you have a local dotfiles repo to include? [no] " answer
if [[ -z ${answer} || "${answer}" == "yes" || "${answer}" == "y" ]]; then
	read -r -p "Clone url? " localrepo
	git clone ${localrepo} "${HOME}/.localdotfiles/"
fi

(
	cd "${HOME}/.dotfiles"
	./bootstrap.sh
)
