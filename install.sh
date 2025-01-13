#!/bin/bash

# Flags to determine if the arguments were passed
cp_hist_flag=false
noninteractive_flag=false

# Loop through all arguments
for arg in "$@"; do
    case $arg in
        --cp-hist|-c) cp_hist_flag=true ;;
        --non-interactive|-n) noninteractive_flag=true ;;
    esac
done

# Function to install a plugin
install_plugin() {
    local plugin_dir="$1"
    local repo_url="$2"

    if [ -d "$plugin_dir" ]; then
        cd "$plugin_dir" && git pull
    else
        git clone --depth=1 "$repo_url" "$plugin_dir"
    fi
}

# Check and install required packages
command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null || {
    echo -e "Installing zsh, git, and wget\n"
    packages=( "sudo apt install -y zsh git wget autoconf" "sudo pacman -S zsh git wget" "sudo dnf install -y zsh git wget" "sudo yum install -y zsh git wget" "sudo brew install git zsh wget" "pkg install zsh git wget" )
    for package in "${packages[@]}"; do
        $package && break
    done || { echo -e "Please install the following packages first, then try again: zsh git wget\n" && exit 1; }
}

# Backup existing .zshrc
[ -f ~/.zshrc ] && mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d") && echo -e "Backed up the current .zshrc to .zshrc-backup-date\n"

# Notify if previous setup found
[ -d ~/.quickzsh ] && echo -e "\nPREVIOUS SETUP FOUND AT '~/.quickzsh'. PLEASE MANUALLY MOVE ANY FILES YOU'D LIKE TO '~/.config/ezsh'\n"

# Install oh-my-zsh
install_plugin ~/.oh-my-zsh https://github.com/ohmyzsh/ohmyzsh.git

# Copy configuration files:
cp -f .zshrc ~/
cp -f zshrc.zsh ~/.zshrc
:
# Move zcompdump files
[ -f ~/.zcompdump ] && mv ~/.zcompdump* ~/.cache/zsh/

# Install plugins
plugins=(
    ["~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
    ["~/.oh-my-zsh/custom/plugins/zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["~/.oh-my-zsh/custom/plugins/zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
    ["~/.oh-my-zsh/custom/themes/powerlevel10k"]="https://github.com/romkatv/powerlevel10k"
    ["~/.oh-my-zsh/custom/plugins/k"]="https://github.com/supercrabtree/k"
    ["~/.oh-my-zsh/custom/plugins/fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
)

for plugin_dir in "${!plugins[@]}"; do
    install_plugin "$plugin_dir" "${plugins[$plugin_dir]}"
done

# Install fonts
echo -e "Installing Nerd Fonts version of Roboto Mono and 0xProto\n"
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFont-Regular.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/0xType/0xProto/blob/main/fonts/0xProto-Regular.ttf -P ~/.fonts/
fc-cache -fv ~/.fonts

# Install todo.txt-cli
if [ ! -L ~/.todo/bin/todo.sh ]; then
    echo -e "Installing todo.sh in ~/.todo\n"
    mkdir -p ~/.todo/bin ~/.todo
    wget -q --show-progress "https://github.com/todotxt/todo.txt-cli/releases/download/v2.12.0/todo.txt_cli-2.12.0.tar.gz" -P ~/.todo/
    tar xvf ~/.todo/todo.txt_cli-2.12.0.tar.gz -C ~/.todo --strip 1 && rm ~/.todo/todo.txt_cli-2.12.0.tar.gz
    ln -s -f ~/.todo/todo.sh ~/.todo/bin/todo.sh
    ln -s -f ~/.todo/todo.cfg ~/.todo.cfg
else
    echo -e "todo.sh is already installed in ~/.todo/bin/\n"
fi

# Copy bash history to zsh history if flag is set
if [ "$cp_hist_flag" = true ]; then
    echo -e "\nCopying bash_history to zsh_history\n"
    python_script_url="https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py"
    if command -v python &>/dev/null || command -v python3 &>/dev/null; then
        wget -q --show-progress "$python_script_url"
        cat ~/.bash_history | python bash-to-zsh-hist.py >> ~/.zsh_history || cat ~/.bash_history | python3 bash-to-zsh-hist.py >> ~/.zsh_history
    else
        echo -e "Python is not installed, can't copy bash_history to zsh_history\n"
    fi
else
    echo -e "\nNot copying bash_history to zsh_history, as --cp-hist or -c is not supplied\n"
fi

# Change default shell to zsh and finish installation
if [ "$noninteractive_flag" = true ]; then
    echo -e "Installation complete, exit terminal and enter a new zsh session\n"
    echo -e "Make sure to change zsh to default shell by running: chsh -s $(which zsh)"
    echo -e "In a new zsh session manually run: build-fzf-tab-module"
else
    echo -e "\nSudo access is needed to change default shell\n"
    chsh -s $(which zsh) && /bin/zsh -i -c 'omz update' && {
        echo -e "Installation complete, exit terminal and enter a new zsh session"
        echo -e "In a new zsh session manually run: build-fzf-tab-module"
    } || echo -e "Something went wrong"
fi

exit
