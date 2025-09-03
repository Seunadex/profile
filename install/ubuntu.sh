#!/bin/bash

set -e

YELLOw='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

main (){
  sudo echo ""

  section "Package Managers"
  install_package_managers

  section "Operating System & Shell"
  configure_os
  configure_ssh
  configure_shell
  configure_profile

  section "System Tools and Runtimes"
  install_apt vim make python
  install_git
  install_docker
  install_snap node --classic

  section "Applications"
  install_snap code --classic
  install_snap chromium
  install_snap slack
  install_snap spotify
}

configure_os() {
  sudo apt-get update
  sudo apt-get upgrade
}

configure_ssh() {
  log "Generating a new SSH key"
  touch ~/.ssh/config
  echo "Host github.com\n  Host github.com\n  Hostname ssh.github.com\n  Port 443" >> ~/.ssh/config
  ssh-keygen -t ed25519 -C "adekunleseun001@gmail.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  xclip -sel clip ~/.ssh/id_ed25519.pub
  log "Public SSH key copied to clipboard"
}

configure_shell() {
  install_apt zsh

  rm -rf ~/.oh-my-zsh

  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) 2>/dev/null"

  cd ~/.oh-my-zsh
  git reset --hard HEAD

  sudo chsh -s "$(which zsh)"

  mv ~/.zshrc ~/.zshrc.oh-my-zsh-defaults
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
}

configure_profile() {
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply seunadex
}

configure_git() {
  install_apt git
  git config --global user.name "Seun Adekunle"
  git config --global user.email "adekunleseun001@gmail.com"
}

configure_docker() {
  sudo addgroup --system docker || echo "docker group already added"
  sudo gpasswd -a $USER docker || echo "docker password already set"
  newgrp docker || echo "docker group already added"
  install_snap --edge docker
}

section() {
  echo
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  printf "${YELLOW}[PROFILE]${NC} $1\n"
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo
}

log() {
  printf "${BLUE}[PROFILE]${NC} $1\n"
}

install_apt() {
  sudo apt-get uninstall $@ || echo "$@ uninstalled"
  sudo apt-get install $@
}

install_snap() {
  sudo snap uninstall $@ || echo "$@ uninstalled"
  sudo snap install $@
}

main
