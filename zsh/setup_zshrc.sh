if [ $LOC = 'remote' ]; then
    echo "source $DOT_DIR/zsh/$LOC/zshrc.sh" > $HOME/.zshrc
else
    echo "source $DOT_DIR/zsh/common/zshrc.sh" > $HOME/.zshrc
fi

# Relaunch zsh
zsh
