#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./deploy.sh [OPTION]
    Creates ~/.zshrc and ~/.tmux.conf with location
    specific config

    OPTIONS:
        --remote (DEFAULT)      deploy remote config, all aliases are sourced
        --local                 deploy local config, only common aliases are sourced
END
)

export DOT_DIR=$(dirname $(realpath $0))

LOC="remote"
while (( "$#" )); do
    case "$1" in
        -h|--help)
            echo "$USAGE" && exit 1 ;;
        --remote)
            LOC="remote" && shift ;;
        --local)
            LOC="local" && shift ;;
        --) # end argument parsing
            shift && break ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2 && exit 1 ;;
    esac
done

# Set any variables
if [ $LOC == "local" ] || [ $LOC == "remote" ] ; then

    echo "deploying on $LOC machine..."

    # Tmux setup
    echo "source $DOT_DIR/tmux/tmux.conf" > $HOME/.tmux.conf

    # zshrc setup
    source "$DOT_DIR/zsh/setup_zshrc.sh"

else
    echo "Error: Unsupported flags provided"
    echo $USAGE
    exit 1
fi