ZSH_DOT_DIR=$(dirname $(realpath ${(%):-%x}))/..
DOT_DIR=$ZSH_DOT_DIR/../

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH=$HOME/.oh-my-zsh

plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions history-substring-search)

# Key common aliases
source $ZSH_DOT_DIR/common/aliases.sh
source $ZSH_DOT_DIR/common/keybindings.sh

# Extras / advanced aliases
source $ZSH/oh-my-zsh.sh
source $ZSH_DOT_DIR/common/extras/p10k.zsh
source $ZSH_DOT_DIR/common/extras/extras.sh
source $ZSH_DOT_DIR/common/extras/aliases.sh