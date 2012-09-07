"
" map Ctrl-t to lbdb query to act as mutt itself
"
imap <C-t> <Esc>:call LbdbExpandCurLine()<CR>A
vmap <C-t> :call LbdbExpandVisual()<CR>

setlocal spell
setlocal linebreak  " Break lines at proper word delimiters.
