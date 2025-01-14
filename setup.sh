#! /bin/bash

# List of applications to get and install
coreapps=("autoconf" "cmake" "curl" "fuse" "git" "make" "nano" "python3" "tmux" "vim" "wget" "zsh")


# Function to install packages on Debian-based systems
install_debian() {
  for app in "${coreapps[@]}"; do
    if ! dpkg -l | grep -q "^ii\s*${app} "; then
      echo "${app} is not installed. Installing..."
      sudo apt-get update && sudo apt-get install -y "${app}"
    else
      echo "${app} is already installed."
    fi
  done
  echo "Core applications installed"
}

# Function to install packages on Arch-based systems
install_arch() {
  for app in "${coreapps[@]}"; do
    if ! pacman -Q ${app} &> /dev/null; then
      echo "${app} is not installed. Installing..."
      sudo pacman -Syu --noconfirm "${app}"
    else
      echo "${app} is already installed."
    fi
  done
  echo "Core applications installed"
}

# Install and configure shell
install_shell() {
  echo "Installing nerd fonts"
  wget -q --show-progress -N https://github.com/0xType/0xProto/blob/main/fonts/0xProto-Regular.ttf -P ~/.local/share/fonts/
  wget -q --show-progress -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.local/share/fonts/
  wget -q --show-progress -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.local/share/fonts/
  wget -q --show-progress -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.local/share/fonts/
  wget -q --show-progress -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.local/share/fonts/
  echo "installing OhMyZsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Installing zplug"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  echo "Installing PowerLevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d");
  cp -n ./example.zshrc ~/.zshrc
}

#
# -------------------
# Start of Script
# -------------------
#
# Check OS type, then run install function
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    debian|ubuntu)
      echo "Detected Debian-based system."
      install_debian
      install_shell
      ;;
    arch)
      echo "Detected Arch-based system."
      install_arch
      install_shell
      ;;
    *)
      echo "Unsupported Linux distribution: $ID"
      exit 1
      ;;
  esac
else
  echo "No configuration for installed OS."
  exit 1
fi
