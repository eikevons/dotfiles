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
    local dir="$(fzf --select-1 --exit-0 --no-sort --query "$1" < "$HOME/.cache/zsh-pwd-history")"
    builtin cd "$dir"
  }

  #TODO register as cd completer

  s () {
    # grep: The trailing slash after PWD is to exclude PWD from the matches
    # cut: Show only the sub-directory part of the path
    # fzf: Show menu for selection
    # NOTE: We use `wc` instead of ${#PWD} to get the number of _bytes_.
    #       ${#...} gives the number of characters. This breaks, e.g., if PWD
    #       contains umlaute.
    local pwd_len_bytes="$(pwd | wc -c)"
    local dir="$(grep --fixed-strings "$PWD/" "$HOME/.cache/zsh-pwd-history" \
      | cut -c $(( ${pwd_len_bytes} + 1))- \
      | fzf --select-1 --exit-0 --no-sort --query "$1" \
    )"

    builtin cd "$dir"
  }
}
