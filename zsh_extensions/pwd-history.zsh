which fzf &>/dev/null && {
  zmodload zsh/mapfile

  _add-pwd-history () {
    # ignore home
    [[ "$PWD" == "$HOME" ]] && return

    local history_path="$HOME/.cache/zsh-pwd-history"
    local -a entries=( ${(@f)mapfile[$history_path]} )
    local index=${entries[(ie)$PWD]}

    if (( ${#entries} < index )); then
      # new entry
      entries=( "$PWD" "${entries[@]}" )
    else
      # existing entry
      entries=( "$PWD" ${entries[1,$((index-1))]} ${entries[$((index+1)),-1]} )
    fi
    (( ${#entries} > 1000 )) && entries=( ${entries[1,1000]} )

    print -l "${entries[@]}" > "$history_path"
  }

  add-zsh-hook chpwd _add-pwd-history

  z () {
    local dir="$(fzf --select-1 --exit-0 --no-sort < "$HOME/.cache/zsh-pwd-history")"
    builtin cd "$dir"
  }
   #TODO register as cd completer
}
