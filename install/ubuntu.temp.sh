# Ubuntu Setup

```sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git make python3
```

## Terminal

Dump a profile

```sh
dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
cat gnome-terminal-profiles.dconf
```

Load a profile

```sh
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
```

Profile contents (name `gnome-terminal-profiles.dconf`)

```sh
[:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
cursor-shape='ibeam'
scrollback-lines=100000
visible-name='Seun'
```

## Trackpad

```sh
sudo apt-get -y install gnome-tweaks
>> Keyboard & Mouse > Mouse > Acceleration Profile > Adaptive
```

## SSH

Generate

```sh
ssh-keygen -t ed25519 -C "adekunleseun001@gmail.com"
```

Add Agent

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

# Add to GitHub

```sh
cat ~/.ssh/id_ed25519.pub
> Paste into GitHub
```

=========================================

# Applications

```sh
sudo snap install docker
sudo snap install chromium
sudo snap install code --classic
sudo snap install slack
sudo snap install spotify
```

```sh
sudo addgroup --system docker
sudo gpasswd -a $USER docker
newgrp docker
sudo snap install --edge docker
```

```sh
sudo snap install node --classic
```

# Profile

```sh
sudo snap install chezmoi --classic
```

# ZSH


