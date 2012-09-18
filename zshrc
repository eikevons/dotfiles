## vim:foldmethod=marker
## Useful links {{{
## http://www.acm.uiuc.edu/workshops/zsh/cd.html
## }}}
## History settings {{{
##
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
## }}}
## Shell functions to change/extend environments {{{
##

autoload -U add-zsh-hook

typeset -U fpath
if [[ -d "${HOME}/.zshfunctions" ]]; then
    fpath=("${HOME}/.zshfunctions" $fpath)

    autoload ${fpath[1]}/[a-zA-Z]*[^~](:t)
fi

if [[ -f "${HOME}/src/fasd/fasd" ]]; then
  source "${HOME}/src/fasd/fasd" 
  eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
fi

# if [[ -f "${HOME}/src/z/z.sh" ]]; then
  # source "${HOME}/src/z/z.sh" 
  # add_z_directory () {
    # _z --add "$PWD"
  # }
  # chpwd_functions=( $chpwd_functions add_z_directory )
# fi
## }}}
## Shell behaviour. {{{
##
setopt nobgnice \
    nohup \
    nocheckjobs \
    extendedglob \
    autopushd \
    pushdminus \
    pushdignoredups \
    nobeep \
    autocd

# Re-enable options that are disabled in .zshenv .
setopt hashcmds \
    hashdirs \
    hashlistall

export DIRSTACKSIZE=20

cdpath=( . ~ )

typeset -U path

# Alt-BS soll nur teile von pfaden/dateinamen löschen
# default WORDCHARS="*?_-.[]~=/&;!#$%^(){}<>"
export WORDCHARS="*?_[]~=&;!#$%^(){}<>"

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

## }}}
## Key bindings. {{{
##

bindkey -v

# viins
bindkey "^U" backward-kill-line
bindkey "^K" kill-line
bindkey "^O" kill-whole-line
[[ -z "$terminfo[kdch1]" ]] || bindkey "$terminfo[kdch1]" delete-char

[[ -z "$terminfo[khome]" ]] || bindkey -M viins "$terminfo[khome]" beginning-of-line
bindkey "^A" beginning-of-line

[[ -z "$terminfo[kend]" ]] || bindkey -M viins "$terminfo[kend]" end-of-line
bindkey "^E" end-of-line

[[ -z "$terminfo[kpp]" ]] || bindkey "$terminfo[kpp]" history-beginning-search-backward
[[ -z "$terminfo[knp]" ]] || bindkey "$terminfo[knp]" history-beginning-search-forward

bindkey "^R" history-incremental-search-backward
bindkey "\e." insert-last-word
whence changecolors &>/dev/null && bindkey -s "[24~" "changecolors"  # use the same change-color key binding as in vim

# fasd
whence fasd &> /dev/null && bindkey "^F" fasd-complete-f 

bindkey "^X^H" _complete_help
bindkey -s "^X^F" "\"./\"OD"

# vicmd
bindkey -M vicmd "K" run-help
autoload run-help-svn
autoload run-help-git

# reverse order during incremental search 
bindkey -M isearch '^P' history-incremental-search-forward

# fix positioning of cursor in up-/down-history
[[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" up-line-or-history
[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history

if [[ $TERM != linux ]]; then
  # The terminal cursor color is set in ~/.Xresources
  function zle-line-init zle-keymap-select () {
    if [[ $KEYMAP == "vicmd" ]]; then
      echo -ne "\033]12;Red\007"
    else
      echo -ne "\033]12;Green\007"
    fi
    # zle reset-prompt
  }
  zle -N zle-keymap-select
  zle -N zle-line-init 

  # Reset the cursor color before executing any command.
  function preexec () {
    echo -ne "\033]12;Green\007"
  }
fi

# See Email on zsh-users@zsh.org
#  "Automatically run ls on blank line for faster navigation"
#  (29 Mar 2012 15:55:05 -0500)
# auto-ls () {
  # if [[ $#BUFFER -eq 0 ]]; then
    # # BUFFER="ls -B --color=auto"
    # echo ""
    # ls -B --color=auto
    # # This is necessary, because the last line is overwritten by the prompt
    # echo ""
    # zle redisplay
  # else
  # # fi
    # zle .$WIDGET
  # fi
# }
# zle -N accept-line auto-ls

## }}}
## Completion {{{
##
## http://zsh.sourceforge.net/Guide/zshguide06.html
zstyle :compinstall filename "$HOME/.zshrc"

setopt completeinword

autoload -Uz compinit
compinit

# See <http://www.linux-mag.com/id/1106>
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# Use menu selection (selection with arrow keys in menu list) for completions
# with more than 15 entries.
# See Zsh Guide chapter 6.2.3
zstyle ':completion:*' menu select=6

if whence fasd &>/dev/null ; then
  # See fasd +194 (complete fasd output)
  zstyle ':completion:*' completer _complete _fasd_zsh_word_complete_trigger _approximate
else
  # See man zshcompsys +2490 (complete approximate items if nothing else is
  # found)
  zstyle ':completion:*' completer _complete _approximate
fi

# Make completion case-insensitive in case of no matches
# See man zshcompsys +1747
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# http://zshwiki.org/home/examples/compsys/general
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*' special-dirs true

# don't complete on backup executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# only complete named directories in tilde completion
# (use group-order instead of tag-order to allow user directories as well but
#  have named directories completed first)
zstyle ':completion:*:-tilde-:*' tag-order named-directories

# only complete *.vim files for vim sessions
zstyle ':completion:*:complete:vim:option-S-1:*' file-patterns \
    '*.vim:session-files:session\ files' \
    '*(-/):directories:directories'
zstyle ':completion:*:complete:gvim:option-S-1:*' file-patterns \
    '*.vim:session-files:session\ files' \
    '*(-/):directories:directories'

compdef '_files -g "*.{pdf,ps,dvi}"' evince

compdef _gnu_generic k3b
compdef _gpg gpg2

compdef wget npwget
compdef wget robget

# complete all my process names
zstyle ':completion:*:processes-names' command \
    'ps c -u ${USER} -o command | uniq'

fignore=(.o .toc .lot .lof .blg .bbl .bak .BAK .sav .old .trace)

## }}}
## Set my prefered editor. {{{
##
if [[ -n "$DISPLAY" ]] ;then
    export VISUAL="gvim -f"
    # export BROWSER="midori"
    export EDITOR="gvim -f"
    export FCEDIT="vim"
else
    # export BROWSER="links"
    export VISUAL="vim"
    export EDITOR="vim"
    export FCEDIT="vim"
fi
## }}}
## Email warnings. {{{
##
mailpath=(
~/Mail/alps/new/"?Neue Nachricht in alps/"
~/Mail/inbox/new/"?Neue Nachricht in inbox/"
~/Mail/freunde/new/"?Neue Nachricht in freunde/"
~/Mail/eichelle/new/"?Neue Nachricht in eichelle/"
~/Mail/local/new/"?Neue Nachricht in local/"
~/Mail/physik/new/"?Neue Nachricht in physik/"
~/Mail/dresden/new/"?Neue Nachricht in dresden/"
~/Mail/professor/new/"?Neue Nachricht in professor/"
~/Mail/zsh/new/"?Neue Nachricht in zsh/"
)

export MAILPATH
export MAILCHECK=30
setopt mailwarning
## }}}
## Aliases, named directories and behaviour of external programmes {{{
##

# Clear named directory hash first.
hash -d -r
[[ -d /usr/share/doc ]] && hash -d pdoc=/usr/share/doc
[[ -d ${HOME}/projects/professor ]] && hash -d prof=${HOME}/projects/professor
[[ -d ${HOME}/projects/alps ]] && hash -d alps=${HOME}/projects/alps
[[ -d ${HOME}/externfs/desy.afs ]] && hash -d desy=${HOME}/externfs/desy.afs

ALIASES="$HOME/.alias"
DIRCOLORS="$HOME/.dircolors.darkbg"

if [[ -f $ALIASES ]];then
    source $ALIASES
fi

# enable color support of ls
if [[ -f  $DIRCOLORS ]]; then
    eval `dircolors $DIRCOLORS`
else
    eval `dircolors -b`
fi

# Use colorized file names for completion.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# enable grep coloured matches and use default (see info page)
export GREP_OPTIONS="--color=auto"
# export GREP_COLOR="7"

if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(/usr/bin/lesspipe)"
fi

(( $+commands[pager] )) && PAGER="pager" || PAGER="less"
# which pager &>/dev/null && PAGER="pager" || PAGER="less"
export PAGER
## }}}
## Prompt, xterm title, and color settings. {{{
##
setopt prompt_subst
export background="dark"

# Enable RCS status in prompt.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' disable-patterns \
  "$HOME/externfs/smb(|/*)" \
  "$HOME/externfs/sshfs(|/*)"

add-zsh-hook precmd vcs_info

function update_color_settings () {
  local col_normal col_time col_path col_host col_retcode

  # if [[ -z $SSH_CONNECTION ]]; then
  if [[ $HOST == matzbach || $HOST == marlov ]]; then
    if [[ ${background} == "dark" ]]; then
      col_normal="%F{grey}%b%k"
      col_time="%B%F{red}"
      col_host="${col_normal}"
      col_path="%B%F{green}"
      col_retcode="%B%F{grey}%K{red}"
    else
      col_normal="%F{black}%b%k"
      col_time="%F{red}"
      col_host="%B%F{black}"
      col_path="%B%F{white}%K{green}"
      col_retcode="%B%F{white}%K{red}"
    fi
    zstyle ':vcs_info:*' unstagedstr "%B%F{red}"
    zstyle ':vcs_info:*' stagedstr "%B%F{yellow}"
    # zstyle ':vcs_info:svn:*' formats "%u%F{yellow}%b"
    zstyle ':vcs_info:*' formats "%%b%k%f[%F{yellow}%c%u%b%%b%k%f]"
    zstyle ':vcs_info:*' actionformats "%%b%k%f[%F{yellow}%u%b%%b%%k%f|%F{yellow}%a%%b%f%k]"
  else
    if [[ ${background} == "dark" ]]; then
      col_normal="%{[00;37m%}"
      col_time="%{[01;31m%}"
      col_host="%{[01;45;33m%}"
      col_path="%{[01;32m%}"
      col_retcode="%{[00;37;41m%}"
    else
      col_normal="%{[00;30m%}"
      col_time="%{[31m%}"
      col_host="%{[01;35;40m%}"
      col_path="%{[01;37;42m%}"
      col_retcode="%{[00;32;41m%}"
    fi
  fi

  PROMPT="%(?//${col_retcode}%?)${col_normal}[%!]${col_time}%T ${col_host}%n@%m${col_normal}:${col_path}%~\${vcs_info_msg_0_}${col_normal}
%# "
  # RPROMPT='${vcs_info_msg_0_}'
}
update_color_settings

# Install trap function to work around double-printed prompt on window-resize.
# NOTE: This is not necessary with zsh version 4.3.15
# trap 'tput cuu1' WINCH

case $TERM in
  xterm*|rxvt*)
    update_term_title () {
      print -Pn "\e]0;%n-%~\a"
    }
    add-zsh-hook chpwd update_term_title
    update_term_title
    ;;
esac
## }}}

[[ -e $HOME/.zshrc.private ]] && source $HOME/.zshrc.private
