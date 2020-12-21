if executable('mutt-address-search')
  function! ExpandCurMailAdress()
    " References:
    " - https://stackoverflow.com/questions/24299155/capture-the-output-of-an-interactive-script-in-vim
    " - https://stackoverflow.com/questions/28401945/load-line-from-unopened-file-into-variable-in-vimscript
    let w = expand("<cword>")
    let tf = tempname()
    " Use tail +2 to strip the first line.
    " Use cut -f 1 to select only the email address from the khard output.
    exe "!mutt-address-search " .  w . " | tail +2 | cut -f 1 > " . tf
    try
      " Get first line as string
      let wexp = get(readfile(tf, '', 1), 0)
    finally
      call delete(tf)
    endtry

    if wexp != '0'
      exe "normal ciw" . wexp
    endif
  endfunction

  nmap <C-t> :call ExpandCurMailAdress()<CR>
  imap <C-t> <Esc>:call ExpandCurMailAdress()<CR>A
endif

setlocal spell
setlocal linebreak  " Break lines at proper word delimiters.
