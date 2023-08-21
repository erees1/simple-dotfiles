# -------------------------------------------------------------------
# personal
# -------------------------------------------------------------------

alias cdg="cd ~/git"
alias zrc="cd $DOT_DIR/zsh"
alias dot="cd $DOT_DIR"
alias jp="jupyter lab"

# -------------------------------------------------------------------
# general
# -------------------------------------------------------------------

alias cl="clear"

# file and directories
alias rmd='rm -rf'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# find/read files
alias h='head'
alias t='tail'
alias rl="readlink -f"
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# storage
alias du='du -kh' # file space
alias df='df -kTh' # disk space
alias usage='du -sh * 2>/dev/null | sort -rh'
alias dus='du -sckx * | sort -nr'

# make file
alias m='make'
alias mc="make check"
alias ms='make shell'
alias mf="make format"
alias mtest="make test"
alias mft="make functest"
alias mut="make unittest"
#-------------------------------------------------------------
# cd
#-------------------------------------------------------------

alias c='cd'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias /='cd /'

alias d='dirs -v'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

#-------------------------------------------------------------
# git
#-------------------------------------------------------------

alias g="git"
alias gcl="git clone"
alias ga="git add"
alias gaa="git add ."
alias gau="git add -u"
alias gc="git commit -m"
alias gp="git push"
alias gpf="git push -f"

alias gg='git gui'
alias glog='git log --oneline --all --graph --decorate'

alias gf="git fetch"
alias gl="git pull"

alias grb="git rebase"
alias grbm="git rebase master"
alias grbc="git rebase --continue"
alias grbs="git rebase --skip"
alias grba="git rebase --abort"

alias gd="git diff"
alias gdt="git difftool"
alias gs="git status"

alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git checkout master"

alias grhead="git reset HEAD^"
alias grhard="git fetch origin && git reset --hard"

alias gst="git stash"
alias gstp="git stash pop"
alias gsta="git stash apply"
alias gstd="git stash drop"
alias gstc="git stash clear"

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

#-------------------------------------------------------------
# tmux
#-------------------------------------------------------------

alias ta="tmux attach"
alias taa="tmux attach -t"
alias tad="tmux attach -d -t"
alias td="tmux detach"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"
alias tkill="tmux kill-server"
alias tdel="tmux kill-session -t"

#-------------------------------------------------------------
# ls
#-------------------------------------------------------------

alias l="ls -CF --color=auto"
alias ll="ls -l --group-directories-first"
alias la='ls -Al'         # show hidden files
alias lx='ls -lXB'        # sort by extension
alias lk='ls -lSr'        # sort by size, biggest last
alias lc='ls -ltcr'       # sort by and show change time, most recent last
alias lu='ls -ltur'       # sort by and show access time, most recent last
alias lt='ls -ltr'        # sort by date, most recent last
alias lm='ls -al |more'   # pipe through 'more'
alias lr='ls -lR'         # recursive ls
alias tree='tree -Csu'    # nice alternative to 'recursive ls'

# -------------------------------------------------------------------
# Tensorboard
# -------------------------------------------------------------------

tblink () {
    [ -z $SINGULARITY_CONTAINER ] && echo "must be run inside SIF" && return
    # Creates simlinks from specified folders to ~/tb/x where x is an incrmenting number
    # and luanches tensorboard
    # example: `tblink ./lm/20210824 ./lm/20210824_ablation ./lm/20210825_updated_data`
    if [ "$#" -eq 0 ]; then
        logdir=$(pwd)
    else
        # setup tensorboard directory
        tbdir="$HOME/tb"
        if [ -d "$tbdir" ]; then
            last="$(printf '%s\n' $tbdir/* | sed 's/.*\///' | sort -g -r | head -n 1)"
            new=$((last+1))
            echo "last folder $last, new folder $new"
            logdir="$tbdir/$new"
        else
            logdir="$tbdir/0"
        fi
        # softlink into tensorboard directory
        _linkdirs "$logdir" "$@"
    fi
    tensorboard \
      --host=$HOST_IP_ADDR \
      --reload_multifile true \
      --logdir="$logdir" \
      --reload_interval 8 \
      --extra_data_server_flags=--no-checksum \
      --max_reload_threads 4 \
      --window_title $PWD
}
_linkdirs() {
    logdir="$1"
    mkdir -p $logdir
    for linkdir in "${@:2}"; do
        linkdir=$(readlink -f $linkdir)
        if [ ! -d $linkdir ]; then
            echo "linkdir $linkdir does not exist"
            return
        fi
        echo "symlinked $linkdir into $logdir"
        ln -s $linkdir $logdir
    done
}
tbadd() {
    # Add experiment folder to existing tensorboard directory (see tblink)
    # example: `tbadd 25 ./lm/20210825` will symlink ./lm/20210824 to ~/tb/25
    if [ "$#" -gt 1 ]; then
        tbdir="$HOME/tb"
        logdir=$tbdir/$1
        _linkdirs $logdir "${@:2}"
    else
        echo "tbadd <tb number> <exp dirs>"
    fi
}
