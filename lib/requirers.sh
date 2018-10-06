#!/usr/bin/env bash

function requires_git() {
  running "git --version"
  git --version
  if [[ $? != 0 ]]; then
    error "git not found"
    exit 1
  fi
}

function requires_choco() {
  running "choco --version"
  choco --version
  if [[ $? != 0 ]]; then
    error "choco not found"
    exit 1
  fi
}