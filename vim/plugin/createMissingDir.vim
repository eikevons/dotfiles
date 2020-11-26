" Create missing directories when writing files.
"
" Taken from https://vi.stackexchange.com/a/697
function! CreateDirectoryAskConfirmation(path, dir)
    silent doautocmd BufWritePre

    " Directory exists, :write and return
    if isdirectory(a:dir)
        execute 'write ' . a:path
        silent doautocmd BufWritePost
        return
    endif

    " Ask for confirmation to create this directory
    echohl Question
    echo "Create directory `" . a:dir . "' [y/N]?"
    echohl None

    let response = nr2char(getchar())
    " mkdir() and :write if we want to make a directory
    if response ==? "y"
        call mkdir(a:dir, "p")
        execute 'write ' . a:path
        silent doautocmd BufWritePost
    endif
endfunction

autocmd BufWriteCmd * call CreateDirectoryAskConfirmation(expand("<amatch>:p"), expand("<amatch>:p:h"))

