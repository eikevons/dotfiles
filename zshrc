## vim:foldmethod=marker
## Useful links {{{
## http://www.acm.uiuc.edu/workshops/zsh/cd.html
## }}}
## History settings {{{
##
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
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

    autoload -- ${fpath[1]}/[-a-zA-Z]*[^~](:t)
fi

# if [[ -f "${HOME}/src/z/z.sh" ]]; then
  # source "${HOME}/src/z/z.sh" 
  # add_z_directory () {
    # _z --add "$PWD"
  # }
  # chpwd_functions=( $chpwd_functions add_z_directory )
# fi

# Log the runtime of long-running processes and send a notification.
# See <https://github.com/marzocchi/zsh-notify/blob/master/notify.plugin.zsh>
# function log_long_running_preexec() {
  # last_command="$1"
  # if [[ -n $last_command ]]; then 
    # start_time=$EPOCHSECONDS
  # else
    # start_time=0
  # fi
# }

# function log_long_running_precmd() {
  # if (( start_time )) && (( EPOCHSECONDS - start_time > 300 )); then
    # local message
    # message="'$last_command' took $(( EPOCHSECONDS - start_time )) secs"
    # print "$(strftime "%F %T" $start_time)  $message" >> ${HOME}/log_long_running
    # if (( $+commands[notify-send] )); then
      # notify-send $lastcommand $message &
    # fi
  # fi
# }

# zmodload zsh/datetime
# add-zsh-hook preexec log_long_running_preexec
# add-zsh-hook precmd log_long_running_precmd


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

# See https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html#code
# turn off ZLE bracketed paste in dumb term otherwise turn on ZLE
# bracketed-paste-magic
if [[ $TERM == dumb ]]; then
    unset zle_bracketed_paste
else
    autoload -Uz bracketed-paste-magic
    zle -N bracketed-paste bracketed-paste-magic
fi

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
bindkey "^T" transpose-words
[[ -z "$terminfo[kdch1]" ]] || bindkey "$terminfo[kdch1]" delete-char
bindkey "^_" undo

[[ -z "$terminfo[khome]" ]] || bindkey -M viins "$terminfo[khome]" beginning-of-line
bindkey "^A" beginning-of-line

[[ -z "$terminfo[kend]" ]] || bindkey -M viins "$terminfo[kend]" end-of-line
bindkey "^E" end-of-line

[[ -z "$terminfo[kpp]" ]] || bindkey "$terminfo[kpp]" history-beginning-search-backward
[[ -z "$terminfo[knp]" ]] || bindkey "$terminfo[knp]" history-beginning-search-forward

bindkey "^R" history-incremental-search-backward
bindkey "\e." insert-last-word
whence changecolors &>/dev/null && bindkey -s "[24~" "changecolors"  # use the same change-color key binding as in vim

bindkey "^X^H" _complete_help
bindkey -s "^X^F" "\"./\"OD"

# vicmd
bindkey -M vicmd "K" run-help
autoload run-help-svn
autoload run-help-git

# edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^E" edit-command-line
bindkey -M viins "^E" edit-command-line

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

zstyle ':completion:*' completer _complete _approximate

# Make completion case-insensitive in case of no matches
# See man zshcompsys +1747
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# http://zshwiki.org/home/examples/compsys/general
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh-completion

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

# prefere ~/.ssh/id_* files for identity files
zstyle ':completion::complete:ssh-add:argument-rest:' file-patterns \
  '~/.ssh/id_^*.pub:identity-files' \
  '*:all-files'

compdef '_files -g "*.{pdf,ps,dvi}"' evince

compdef _gnu_generic k3b
compdef _gpg gpg2

compdef $_comps[wget] npwget
compdef $_comps[wget] robget
if (( $#_comps[tmux] )) && whence tm &>/dev/null; then
  compdef $_comps[tmux] tm
fi

# Enable aws-cli completion if installed
# See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html#cli-command-completion-completer
# Load bash completions (for aws cli completion)
if (( $#commands[aws_completer] )); then
  autoload bashcompinit && bashcompinit
  complete -C "${commands[aws_completer]}" aws
fi

# complete all my process names
zstyle ':completion:*:processes-names' command \
    'ps c -u ${USER} -o command | uniq'

fignore=(.o .toc .lot .lof .bak .BAK .sav .old .trace)

[[ -f $HOME/.zsh_extensions/git-flow-completion/git-flow-completion.zsh ]] \
  && source $HOME/.zsh_extensions/git-flow-completion/git-flow-completion.zsh

## }}}
## Set my prefered editor. {{{
##
if [[ -n "$DISPLAY" ]] ;then
    export VISUAL="vim"
    # export BROWSER="midori"
    export EDITOR="vim"
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
## }}}
## Aliases, named directories and behaviour of external programmes {{{
##

# Clear named directory hash first.
hash -d -r
[[ -d /usr/share/doc ]] && hash -d pdoc=/usr/share/doc
[[ -d ${HOME}/projects/professor ]] && hash -d prof=${HOME}/projects/professor
[[ -d ${HOME}/projects/alps ]] && hash -d alps=${HOME}/projects/alps
[[ -d ${HOME}/externfs/desy.afs ]] && hash -d desy=${HOME}/externfs/desy.afs
[[ -d /dev/shm ]] && hash -d volatile=/dev/shm

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


# if [[ -f "${HOME}/src/fasd/fasd" ]]; then
#   source "${HOME}/src/fasd/fasd" 
#   eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-wcomp zsh-ccomp-install zsh-wcomp-install)"
#   bindkey "^F" fasd-complete-f 
# fi

[[ -f "${HOME}/.zsh_extensions/pwd-history.zsh" ]] && source "${HOME}/.zsh_extensions/pwd-history.zsh" 

# Enable key-bindings: ^R, ^T, Meta-c
if [[ -e /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  export FZF_DEFAULT_OPTS="--reverse"
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
# Fuzzy-completion triggered by **<Tab>
if [[ -e /usr/share/doc/fzf/examples/completion.zsh ]]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# Use colorized file names for completion.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

(( $+commands[pager] )) && PAGER="pager" || PAGER="less"
# which pager &>/dev/null && PAGER="pager" || PAGER="less"
export PAGER
## }}}
## Prompt, xterm title, and color settings. {{{
##
setopt prompt_subst
export background="dark"

if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" && -z "$SSH_CONNECTION" ]]; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git hg svn
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' disable-patterns \
    "$HOME/externfs/smb(|/*)" \
    "$HOME/externfs/sshfs(|/*)"

  add-zsh-hook precmd vcs_info

  whence git &> /dev/null && {
    # Taken from /usr/share/doc/zsh/examples/Misc/vcs_info-examples.gz
    ## git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
    # Make sure you have added misc to your 'formats':  %m
    zstyle ':vcs_info:git*+set-message:*' hooks git-st
    function +vi-git-st() {
      local ahead behind
      local -a gitstatus

      # for git prior to 1.7
      # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
      ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
      (( $ahead )) && gitstatus+=( "+${ahead}" )

      # for git prior to 1.7
      # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
      behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
      (( $behind )) && gitstatus+=( "-${behind}" )

      (( $#gitstatus )) && hook_com[misc]+="${(j:/:)gitstatus}"
    }
  }
fi

function update_color_settings () {
  local col_normal col_time col_path col_host col_retcode ps1_context

  if [[ -n "$VIRTUAL_ENV" ]]; then
    ps1_context="($(basename $VIRTUAL_ENV))"
  fi

  if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" && -z "$SSH_CONNECTION" ]]; then
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
    zstyle ':vcs_info:svn:*' formats "%u%F{yellow}%b"
    zstyle ':vcs_info:git:*' unstagedstr "%B%F{red}+"
    zstyle ':vcs_info:git:*' stagedstr "%B%F{magenta}+"
    zstyle ':vcs_info:git:*' formats "%%b%k%f[%F{yellow}%c%u%b%%b%k%f%m]"
    zstyle ':vcs_info:git:*' actionformats "%%b%k%f[%F{yellow}%c%u%b%%b%%k%f|%F{yellow}%a%%b%f%k]"

    PROMPT="%(?//${col_retcode}%?)${col_normal}[%!]${col_time}%T ${col_path}%~\${vcs_info_msg_0_}${col_normal}\${ps1_context}
%# "

  else
    if [[ ${background} == "dark" ]]; then
      col_normal="%{[00;37m%}"
      col_time="%{[01;31m%}"
      col_host="%{[01;43;31m%}"
      col_path="%{[01;32m%}"
      col_retcode="%{[01;37;41m%}"
    else
      col_normal="%{[00;30m%}"
      col_time="%{[31m%}"
      col_host="%{[01;35;40m%}"
      col_path="%{[01;37;42m%}"
      col_retcode="%{[00;32;41m%}"
    fi

    PROMPT="%(?//${col_retcode}%?)${col_normal}[%!]${col_time}%T ${col_host}%n@%m${col_normal}:${col_path}%~\${vcs_info_msg_0_}${col_normal}\${ps1_context}
%# "
  fi

  # RPROMPT='${vcs_info_msg_0_}'
}
update_color_settings

# Install trap function to work around double-printed prompt on window-resize.
# NOTE: This is not necessary with zsh version 4.3.15
# trap 'tput cuu1' WINCH

case $TERM in
  xterm*|rxvt*)
    _update_term_title () {
      print -Pn "\e]0;%n-%~\a"
    }
    add-zsh-hook chpwd _update_term_title
    _update_term_title
    ;;
  screen)
    _set_dir_title () {
      print -Pn "\ek%n-%~\e\\"
    }
    _set_command_title () {
      if [[ -n "$1" ]]; then
        print -Pn "\ek${1[1,20]}\e\\"
      fi

    }
    add-zsh-hook precmd _set_dir_title
    add-zsh-hook preexec _set_command_title
    ;;
esac
## }}}

[[ -e $HOME/.zshrc.private ]] && source $HOME/.zshrc.private
