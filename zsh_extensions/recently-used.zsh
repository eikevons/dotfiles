# This is based on /usr/share/doc/fzf/examples/key-bindings.zsh
which fzf &>/dev/null && [[ -e ~/.local/share/recently-used.xbel ]] && {

  __recently_used() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    # Use solution form sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b"'
    # https://askubuntu.com/a/295312
    < ~/.local/share/recently-used.xbel \
      sed -n -e 's#<bookmark href="file://\(/[^"]*\)" .*$#\1#p' \
      | sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b" \
      | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-}" fzf \
      | while read item; do echo -n "${(q)item} "; done
    local ret=$?
    echo
    return $ret
  }

  fzf-recently-used-widget() {
    LBUFFER="${LBUFFER}$(__recently_used)"
    local ret=$?
    zle reset-prompt
    return $ret
  }
  zle     -N            fzf-recently-used-widget
  bindkey -M vicmd '^B' fzf-recently-used-widget
  bindkey -M viins '^B' fzf-recently-used-widget
}
