# bash prompt settings
PROMPT_DIRTRIM=4
export PS1="\[\e[32m\]\u\[\e[m\]:\[\e[33m\]\w\[\e[m\]\\$ "

export LC_ALL=en_IN.UTF-8
export LANGL=en_IN.UTF-8

shopt =s checkwinsize
shopt -s direxpand

# aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep -d skip'
alias edit='/path/to/gvim \!$ /dev/null'
alias du_hidden='du -sh .[^.]*'
# alias tmux='TERM=screen-256color-bce /path/to/tmux'
alias tmux='tmux -u'
alias nvim='CC=c99 nvim'
alias vi='nvim'

alias dev_tmux="TERM=screen-256color-bce /u/tslin/.config/tmux/_tmux_custom.sh dev_tmux"
# export LD_LIBRARY_PATH=/path/to/local/bin:$LD_LIBRARY_PATH
