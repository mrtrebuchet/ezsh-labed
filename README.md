# ezsh
A simple script to setup an awesome shell environment.
Quickly install and setup zsh and oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh) with
* powerlevel10k theme (https://github.com/romkatv/powerlevel10k)
* Nerd-Fonts (https://github.com/ryanoasis/nerd-fonts)
* zsh-completions (https://github.com/zsh-users/zsh-completions)
* zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
* zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
* history-substring-search (https://github.com/zsh-users/zsh-history-substring-search)
* fzf (https://github.com/junegunn/fzf)
* k (https://github.com/supercrabtree/k)
* todotxt (https://github.com/todotxt/todo.txt-cli)

Sets following useful aliases and ohmyzsh plugins. **You can add more or overwrite these in your personal zsh config files under `~/.config/ezsh/zshrc/`** 
* l="ls -lah"         - just type "l" instead of "ls -lah"
* alias k="k -h"	  - show human readable filesizes, in kb, mb etc
* e="exit"
* myip - (wget -qO- https://wtfismyip.com/text)       - what's my ip: quickly find out external IP
* cheat - (https://github.com/chubin/cheat.sh)        - cheatsheets in the terminal!
* speedtest - (curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -) run speedtest on the fly
* dadjoke - (curl https://icanhazdadjoke.com)         - terminally sick jokes
* ipgeo - (curl "http://api.db-ip.com/v2/free/$1")    - finds geo location from IP
* [x="extract"](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract)         - extract any compressed files
* [z](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z)   - quickly jump to most visited directories
* [web-search](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search)    - search on the web from cli
* [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)                - easily prefix your commands with sudo by pressing `esc` twice
* [systemd](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd)          - many useful aliases for systemd

## Installation
Requirements:
* `git` to clone it.
* `python3` or `python` is required to run option '-c' which copies history from .bash_history

``` bash
git clone https://github.com/jotyGill/ezsh
cd ezsh
./install.sh -c        # only run with '-c' the first time, running multiple times will duplicate history entries
```
This will install the setup under `~/.config/ezsh/`
Change your terminal's fonts to your installed Nerd Font.

## Notes

* If the text/icons look broken, make sure your terminal is using one of the Nerd fonts.

* All oh-my-zsh plugins are installed under ~/.config/ezsh/oh-my-zsh/plugin, Other tools (fzf,marker,todo) are installed in ~/.config/ezsh/

### To Uninstall
To uninstall simply delete ~/.zshrc and ~/.config/ezsh/. The script creates a backup of your original .zshrc in the home folder with the filename indicating it's a backup. Rename it back to .zshrc
