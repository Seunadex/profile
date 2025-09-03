#!/bin/bash

set -e

YELLOw='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

main (){
  install_git
  install_docker
  install_profile
}

install_git() {
  installing "Git"
  sudo apt-get install git
}

install_docker(){
  installing "Docker"
  out=$(curl -sSL https://get.docker.com | sh)
}

install_profile() {
  installing "Profile"
  git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick

#   printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc
#   touch ~/.bashrc

  homeshick clone -f -b git@github.com:seunadex/profile.git
  homeshick pull profile
  homeshick link profile

  touch ~/.zprofile
  touch ~/.zshrc

  if grep -q ".con/.zprofile" "$HOME/.zprofile"; then
    log ".zprofile already sources .con/.zprofile"
  else
    log "Sourcing .con/.zprofile in .zprofile"
    echo 'source "$HOME/.con/.zprofile"\n' | cat - "$HOME/.zprofile" > temp && mv temp "$HOME/.zprofile"
  fi

  if grep -q ".con/.zshrc" "$HOME/.zshrc"; then
    log ".zshrc already sources .con/.zshrc"
  else
    log "Sourcing .con/.zshrc in .zshrc"
    echo 'source "$HOME/.con/.zshrc"\n' | cat - "$HOME/.zshrc" > temp && mv temp "$HOME/.zshrc"
  fi
}

installing() {
  printf "${YELLOw}[PROFILE]${NC} $1\n"
}
log() {
  printf "${BLUE}[PROFILE]${NC} $1\n"
}

main
