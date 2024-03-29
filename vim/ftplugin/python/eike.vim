" Turn on completion:
setlocal omnifunc=pythoncomplete#Complete
set completeopt+=preview

let python_highlight_all = 1
let python_slow_sync = 1

" 
" set python specific formatting options
setlocal textwidth=76
setlocal formatoptions=croq

setlocal relativenumber
setlocal numberwidth=3

if has("gui")
  if !exists("g:python_column_increased") && &columns < (80 + &numberwidth)
    let g:python_column_increased = 1
    exec "set columns+=".&numberwidth
  endif
endif

" see: http://www.sontek.net/post/Python-with-a-modular-IDE-(Vim).aspx
" setlocal tags+=$HOME/.vim/tags/python.tags

"
" pydiction inspired
"setlocal complete+=k$HOME/.vim/complete.data/python.dict
"setlocal tags+=$HOME/.vim/complete.data/python.ctags

" mini templates for methods and classes
" call IMAP("%cl", "class <+NAME+>:\<CR>def __init__(self<+ARGS+>):\<CR><+BODY+>", "python")
" call IMAP("%me", "def <+NAME+>(self<+ARGS+>):\<CR><+BODY+>", "python")
" call IMAP("%fu", "def <+NAME+>(<+ARGS+>):\<CR><+BODY+>", "python")

" call IMAP("%np", "import numpy as np", "python")

" remap the K (or 'help') key
" see ~/.vim/plugin/pydoc.vim
" Be smart about dots in names here: Temporarily include '.' in keyword
" characters for identifier search. This must be done before ShowPyDoc is
" called, because this function changes to the __doc__ buffer.
nnoremap <silent> <buffer> K :let oisk=&isk<CR>:set isk+=.<CR>:let mykw = expand("<cword>")<CR>:let &isk=oisk<CR>:call ShowPyDoc(mykw, 1)<CR>

" Set-up synstatic
" nnoremap <silent> <buffer> ]s :ll<CR>
nnoremap <silent> <buffer> ]s :lnext<CR>
nnoremap <silent> <buffer> [s :lprev<CR>

" Use Python3 by default
" syntastic
let g:syntastic_python_pyflakes_exec = '/usr/bin/pyflakes3'
let g:syntastic_python_checkers=["pyflakes"]

" jedi-vim
" 2016-06-17: This is not working because vim on debian is built with
" python2-support only (see https://bugs.debian.org/729924)
" let g:jedi#force_py_version = 3

" Enable black formatting
if executable("black")
  nmap <leader>b m`:%!black -q -<CR>``
endif
