# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/drew/.zshrc'
export PATH=$PATH:~/.local/bin
autoload -Uz compinit
compinit
# End of lines added by compinstall
. /usr/lib/python3.5/site-packages//powerline/bindings/zsh/powerline.zsh

#ZSH customization
plugins=(archlinux git colored-man-pages common-aliases npm node lein redis-cli web-search wd zsh-completions)

source /home/drew/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/drew/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/drew/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
