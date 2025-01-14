export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZPLUG_HOME=$HOME/.zplug

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE='nerdfont-complete'

#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time)
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh context dir vcs)
#POWERLEVEL9K_PROMPT_ON_NEWLINE=false

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# ---------------
# QoL Stuff
#---------------

# Set vim as the default editor
export EDITOR='nvim'

# Aliases for convenience
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias vi='nvim'
alias svi='sudo nvim'

# Shell history
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history

# ---------------
# Plugins
#---------------

source $ZSH/oh-my-zsh.sh
source $ZPLUG_HOME/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme defer:1
zplug "zsh-users/zsh-completions", as:plugin, defer:2
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2

zplug load
# Install plugins if there are plugins that have not been installed

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

