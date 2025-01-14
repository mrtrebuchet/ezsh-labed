#! /bin/bash

# List of applications to get and install
coreapps=("autoconf" "cmake" "curl" "fuse" "git" "make" "nano" "python3" "tmux" "vim" "wget" "zsh")
debapps=("build-essential" "ninja-build" "gettext")
archapps=("base-devel" "ninja")



# Function to install packages on Debian-based systems
install_debian() {
  local apps=("${coreapps[@]}" "${debapps[@]}")
  sudo apt-get update 
  for app in "${apps[@]}"; do
    if ! dpkg -l | grep -q "^ii\s*${app} "; then
      echo "${app} is not installed. Installing..."
      sudo apt-get install -y "${app}"
    else
      echo "${app} is already installed."
    fi
  done
  echo "Core applications installed"
}

# Function to install packages on Arch-based systems
install_arch() {
  local apps=("${coreapps[@]}" "${archapps[@]}")
  for app in "${apps[@]}"; do
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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "Installing zplug"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  echo "Installing PowerLevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d");
  cp -n ~/zsh-setup/example.zshrc ~/.zshrc
}

install_neovim() {
  echo "Installing Neovim"
  git clone https://github.com/neovim/neovim.git
  cd ./neovim
  rm -r build/  # clear the CMake cache
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  export PATH="$HOME/neovim/bin:$PATH"
  echo "Installing labed kickstart.vim"
  git clone https://github.com/mrtrebuchet/labed-neovim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
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
      install_neovim
      exec zsh
      ;;
    arch|endeavourOS)
      echo "Detected Arch-based system."
      install_arch
      install_shell
      install_neovim
      exec zsh
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
