# Speechmatics dotfiles

This repo provides a minimal working set of dotfiles for new starters at Speechmatics, it is not intended to be exhaustive. Suggestions for useful additions are welcome.

Notable omissions include any vim/nvim setup - speak to Ed / Sam if you want to learn more about that.

## Installation

### Step 1
Clone this repo
```bash
git@gitlab1.speechmatics.io:aml/sm-dotfiles.git ~/git/dotfiles
```
you probably will also want to have push this repo to your personal github

### Step 2
Install dependencies (e.g. oh-my-zsh and related plugins),you can specify options to install specific programs: tmux, zsh
```bash
# Install dependencies + tmux & zsh
./install.sh --tmux --zsh
# Install just the dependencies
./install.sh
```

### Step 3
Deploy (e.g. source aliases for .zshrc, apply oh-my-zsh settings etc..)
```bash
./deploy.sh  # Remote linux machine
./deploy.sh --local   # Local mac machine
```

### Step 4
This repo comes with a preconfigured powerlevel10k theme in [`~/zsh/common/extras/p10k.zsh`](./zsh/common/extras/p10k.zsh) but you can reconfigure this by running which will launch an interactive window.
```
p10k configure
```
When you get to the last two options below
```
Powerlevel10k config file already exists.
Overwrite ~/git/sm-dotfiles/zsh/common/extras/p10k.zsh
# Press y for YES

changes to ~/.zshrc
# Press no for NO 
```

You then will want to paste the following command into the created p10k.zsh file so that when you are in a singualarity 

```
------> Add 'singualarity' to the POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS < --------
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    direnv                  # direnv status (https://direnv.net/)
    asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    singularity             # ADD THIS LINE HERE <-------

....

  # Example of a user-defined prompt segment. Function prompt_example will be called on every
  # prompt if `example` prompt segment is added to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
  # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS. It displays an icon and orange text greeting the user.
  #
  # Type `p10k help segment` for documentation and a more sophisticated example.
  function prompt_example() {
    p10k segment -f 208 -i '⭐' -t 'hello, %n'
  }

------> # Add this function beneath the prompt example < --------
  function prompt_singularity() {
    if [ ! -z "$SINGULARITY_CONTAINER" ]; then
      name=$(echo ${SINGULARITY_CONTAINER} | awk -F/ '{print $(NF-0)}')
      p10k segment -f 031 -i '💫' -t "${name}"
    fi
  
```