#!/bin/sh

set -e

YELLOW='\033[1;33m'
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
  install_git
  install_code
  install_iterm2
  install_rectangle
  install vim
  install_cask docker

  section "CLI Tools"
  install bat
  install eza
  install fzf
  install gh
  install httpie
  install jq
  install mise
  install node
  install ripgrep
  install tldr
  install tree
  install_claude_code

  section "Applications"
  install_cask appcleaner
  install_cask balenaetcher
  install_cask dashlane
  install_cask discord
  install_cask google-chrome
  install_cask imageoptim
  install_cask licecap
  install_cask obsidian
  install_cask proxyman
  install_cask raycast
  # install_cask signal
  install_cask slack
  install_cask soundsource
  # install_cask spotify
  install_cask tableplus
  install_cask warp
  install_cask wireshark
  install_cask zoom

  section "Clean Up"
  brew doctor
  zsh -c "autoload -U compaudit && compaudit | xargs chmod g-w,o-w"

  section "Finished!"
}

install_package_managers() {
  if hash brew 2>/dev/null; then
    return
  fi

  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

configure_os() {
  defaults write com.apple.screencapture "location" -string "~/Downloads" && killall SystemUIServer
  defaults write com.apple.screencapture "show-thumbnail" -bool "false"
  defaults write com.apple.dock "mru-spaces" -bool "false"
  defaults write com.apple.dock "show-recents" -bool "false" && killall Dock
  defaults write com.google.Chrome "AppleEnableSwipeNavigateWithScrolls" -bool "false"
}

configure_ssh() {
  if [ -f ~/.ssh/id_ed25519 ]; then
    log "SSH key already exists, skipping"
    return
  fi
  log "Generating a new SSH key"
  mkdir -p ~/.ssh
  touch ~/.ssh/config
  printf "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519\n" > ~/.ssh/config
  printf "Host github.com\n  Hostname ssh.github.com\n  Port 443\n" >> ~/.ssh/config
  ssh-keygen -t ed25519 -C "adekunleseun001@gmail.com" -f ~/.ssh/id_ed25519
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  pbcopy < ~/.ssh/id_ed25519.pub
  log "Public SSH key copied to clipboard"
}

configure_shell() {
  install zsh

  rm -rf ~/.oh-my-zsh
  touch ~/.zshrc

  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) 2>/dev/null"

  cd ~/.oh-my-zsh
  git reset --hard HEAD

  sudo chsh -s "$(brew --prefix)/bin/zsh"

  mv ~/.zshrc ~/.zshrc.oh-my-zsh-defaults
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
}

configure_profile() {
  log "Removing profile"
  rm -rf ~/.homesick/repos/profile

  install homeshick

  homeshick clone -f -b seunadex/profile
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

install_git() {
  install git
  git config --global user.name "Seun Adekunle"
  git config --global user.email "adekunleseun001@gmail.com"
}

install_code() {
  install_cask visual-studio-code
  mkdir -p ~/Library/Application\ Support/Code/User/
  if [ -f ~/.homesick/repos/profile/configs/code/settings.json ]; then
    yes | cp -rf ~/.homesick/repos/profile/configs/code/settings.json ~/Library/Application\ Support/Code/User/settings.json
  else
    log "VS Code settings config not found, skipping"
  fi
}

install_rectangle() {
  install_cask rectangle
  mkdir -p ~/Library/Application\ Support/Rectangle/
  if [ -f ~/.homesick/repos/profile/configs/rectangle/Shortcuts.json ]; then
    yes | cp -rf ~/.homesick/repos/profile/configs/rectangle/Shortcuts.json ~/Library/Application\ Support/Rectangle/Shortcuts.json
  else
    log "Rectangle shortcuts config not found, skipping"
  fi
}

install_iterm2() {
  install_cask iterm2
  if [ -f ~/.homesick/repos/profile/configs/iterm2/com.googlecode.iterm2.plist ]; then
    yes | cp -rf ~/.homesick/repos/profile/configs/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
  else
    log "iTerm2 config not found, skipping"
  fi
}

install_claude_code() {
  if npm list -g @anthropic-ai/claude-code --depth=0 2>/dev/null | grep -q claude-code; then
    log "claude-code already installed, skipping"
    return
  fi
  npm install -g @anthropic-ai/claude-code
}

install() {
  if brew list --formula $1 2>/dev/null | grep -q $1; then
    log "$1 already installed, skipping"
    return
  fi
  brew install $1
}

install_cask() {
  if brew list --cask $1 2>/dev/null | grep -q $1; then
    log "$1 already installed, skipping"
    return
  fi
  brew install --cask $1
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

main
