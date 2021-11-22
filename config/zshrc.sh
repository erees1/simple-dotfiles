CONFIG_DIR=$(dirname $(realpath ${(%):-%x}))
DOT_DIR=$CONFIG_DIR/../

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH=$HOME/.oh-my-zsh

plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions history-substring-search)

# Key common aliases
source $CONFIG_DIR/aliases.sh

# Extras / advanced aliases
source $ZSH/oh-my-zsh.sh
source $CONFIG_DIR/p10k.zsh
source $CONFIG_DIR/extras.sh
