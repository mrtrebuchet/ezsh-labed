#! /bin/bash

# List of applications to get and install
applications=("autoconf" "cmake" "cowsay" "curl" "fuse" "git" "make" "nano" "python3" "tmux" "vim" "wget" "zsh")

# Function to install packages on Debian-based systems
install_debian() {
  for app in "${applications[@]}"; do
    if ! dpkg -l | grep -q "^ii\s*${app} "; then
      echo "${app} is not installed. Installing..."
      sudo apt-get update && sudo apt-get install -y "${app}"
    else
      echo "${app} is already installed."
    fi
  done
}

# Function to install packages on Arch-based systems
install_arch() {
  for app in "${applications[@]}"; do
    if ! pacman -Q ${app} &> /dev/null; then
      echo "${app} is not installed. Installing..."
      sudo pacman -Syu --noconfirm "${app}"
    else
      echo "${app} is already installed."
    fi
  done
}
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
      ;;
    arch)
      echo "Detected Arch-based system."
      install_arch
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



echo cowsay "script done"
