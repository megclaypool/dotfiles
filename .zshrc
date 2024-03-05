# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH Path #
############

export ZSH="$HOME/.oh-my-zsh"
export DOCKER_HOST="unix://${HOME}/.docker/run/docker.sock"

# PATH #
########

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Make sure the terminal can find python2
PATH=$(pyenv root)/shims:$PATH

# Make sure the terminal can find ruby apps
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"

# Make sure the terminal can find composer & cgr apps
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Let Terminus run on PHP 8.3 (2024-01-09)
export TERMINUS_ALLOW_UNSUPPORTED_NEWER_PHP=true


# NVM settings & variables: #
#############################
export NVM_DIR="$HOME/.nvm"
  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

NVM_HOMEBREW="/usr/local/opt/nvm/nvm.sh"
[ -s "$NVM_HOMEBREW" ] && \. "$NVM_HOMEBREW"

# Automate nvm switching if you cd to a directory in which there's a .nvmrc file
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# VS Code might want this NVM variable
[ -x "$(command -v npm)" ] && export NODE_PATH=$NODE_PATH:`npm root -g`




# To activate powerlevel10k, add the following line to .zshrc:
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

plugins=(zsh-nvm)



# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"




# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# this needs to be after the theme variable assignments
# however, it must be *before* your aliases
source $ZSH/oh-my-zsh.sh



# Aliases #
###########
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.


# Because it should already exist, and because I can
alias xyzzy="echo 'Nothing happens'"


lll() {
  if command -v eza >/dev/null
  then
      eza --icons --all --group-directories-first --long --git --header
  else
      # /bin/ls -AGl
      gls --almost-all --classify --color --group-directories-first -l
  fi
}

# alias ll=ls_was_taken
alias ll='eza --icons --all --group-directories-first'
# alias lc='colorls -A --tree --dark'
alias lt='eza --icons --all --group-directories-first --tree --level=4'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

cd() { builtin cd "$@" && ll; }

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation

alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels

alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

alias c='clear'                             # c:            Clear terminal display
alias which='which -a'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths

mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

alias brewup='brew update -v; brew upgrade -v; brew cleanup -v; brew doctor -v'

alias defbroff='defaultbrowser firefox'

alias defbroffd='defaultbrowser firefoxdeveloperedition'

alias windows='osascript /Users/noxlady/Library/Mobile\ Documents/com~apple~ScriptEditor2/Documents/Arrange\ app\ windows\ across\ desktops.scpt'

# alias ff='osascript /Users/noxlady/Library/Mobile\ Documents/com~apple~ScriptEditor2/Documents/Switch\ to\ Firefox\ Browser.scpt'
# alias oi='osascript /Users/noxlady/Library/Mobile\ Documents/com~apple~ScriptEditor2/Documents/Switch\ to\ Orion\ Browser.scpt'
alias oi='shortcuts run "Set Default Browser to FFD"'
# alias ffd='osascript /Users/noxlady/Library/Mobile\ Documents/com~apple~ScriptEditor2/Documents/Switch\ to\ Firefox\ Dev\ Browser.scpt'
alias ffd='shortcuts run "Set Default Browser to Orion"'

# tired of so much typing when I mess with my .bash_profile
alias editbp='code ~/.bash_profile'
alias sourcebp='source ~/.bash_profile'

# tired of so much typing when I mess with my .zshrc
alias editzp='code ~/.zshrc'
alias sourcezp='source ~/.zshrc'

#Let's make it easier to use behat...
alias behat="vendor/behat/behat/bin/behat"

# Following Bjinse's instructions on setting up Behat on Mac (https://stackoverflow.com/questions/47842262/connecting-behat-and-mink-with-selenium-and-chrome-or-safari-or-firefox-on-mac)
alias google-chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias cdriver='google-chrome --disable-gpu --remote-debugging-address=127.0.0.1 --remote-debugging-port=9222'
alias cdriverheadless='chrome --disable-gpu --headless --remote-debugging-address=127.0.0.1 --remote-debugging-port=9222'
# export PATH="/usr/local/share/npm/bin:$PATH"

# because how awesome is it to print a colorgrid???
function colorgrid()
{
    iter=16
    while [ $iter -lt 52 ]
    do
        second=$[$iter+36]
        third=$[$second+36]
        four=$[$third+36]
        five=$[$four+36]
        six=$[$five+36]
        seven=$[$six+36]
        if [ $seven -gt 250 ];then seven=$[$seven-251]; fi

        echo -en "\033[38;5;$(echo $iter)m█ "
        printf "%03d" $iter
        echo -en "   \033[38;5;$(echo $second)m█ "
        printf "%03d" $second
        echo -en "   \033[38;5;$(echo $third)m█ "
        printf "%03d" $third
        echo -en "   \033[38;5;$(echo $four)m█ "
        printf "%03d" $four
        echo -en "   \033[38;5;$(echo $five)m█ "
        printf "%03d" $five
        echo -en "   \033[38;5;$(echo $six)m█ "
        printf "%03d" $six
        echo -en "   \033[38;5;$(echo $seven)m█ "
        printf "%03d" $seven

        iter=$[$iter+1]
        printf '\r\n'
    done
}


# keep git log and other multipage output
# in the terminal after quitting
# Has an additional escape code so syntax coloring
# doesn't get messed up

export LESS="-Xr"



# To activate the autosuggestions, add the following at the end of your .zshrc:
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# To activate the syntax highlighting, add the following at the end of your .zshrc:
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
