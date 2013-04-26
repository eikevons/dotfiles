if !exists("g:haskell_tools_loaded")
" Haskell functions copied from <https://github.com/dag/vim2hs/blob/master/autoload/vim2hs/haskell/editing.vim>
  " function! vim2hs#haskell#editing#indentexpr(lnum) " {{{
  function! haskell#tools#indentexpr(lnum) " {{{
    let l:line = getline(a:lnum - 1)

    if l:line =~# '^\s*$'
      return 0
    endif

    let l:indent = indent(a:lnum - 1)

    if l:line =~# '^data\>.*=.\+'
      let l:indent = match(l:line, '=')

    elseif l:line =~# '^data\>[^=]\+\|^class\>\|^instance\>'
      let l:indent = &shiftwidth * 2

    elseif l:line =~# '^newtype\>.*=.\+'
      let l:indent = match(l:line, '=') + 2

    elseif l:line =~# '^\k\+.*=\s*\%(do\)\?$'
      let l:indent = &shiftwidth * 2

    elseif l:line =~# '\[[^\]]*$'
      let l:indent = match(l:line, '\[')

    elseif l:line =~# '{[^}]*$'
      let l:indent = match(l:line, '{')

    elseif l:line =~# '([^)]*$'
      let l:indent = match(l:line, '(')

    elseif l:line =~# '\<case\>.*\<of$'
      let l:indent = match(l:line, '\<case\>') + &shiftwidth

    elseif l:line =~# '\<case\>.*\<of\>'
      let l:indent = match(l:line, '\<of\>') + 3

    elseif l:line =~# '\<if\>.*\<then\>.*\%(\<else\>\)\@!'
      let l:indent = match(l:line, '\<then\>')

    elseif l:line =~# '\<if\>'
      let l:indent = match(l:line, '\<if\>') + &shiftwidth

    elseif l:line =~# '\<\%(do\|let\|where\|in\|then\|else\)$'
      let l:indent = indent(a:lnum - 1) + &shiftwidth

    elseif l:line =~# '\<do\>'
      let l:indent = match(l:line, '\<do\>') + 3

    elseif l:line =~# '\<let\>.*\s=$'
      let l:indent = match(l:line, '\<let\>') + 4 + &shiftwidth

    elseif l:line =~# '\<let\>'
      let l:indent = match(l:line, '\<let\>') + 4

    elseif l:line =~# '\<where\>'
      let l:indent = match(l:line, '\<where\>') + 6

    elseif l:line =~# '\s=$'
      let l:indent = indent(a:lnum - 1) + &shiftwidth

    endif

    if synIDattr(synIDtrans(synID(a:lnum - 1, l:indent, 1)), 'name')
      \ =~# '\%(Comment\|String\)$'
      return indent(a:lnum - 1)
    endif

    return l:indent
  endfunction " }}}


  " function! vim2hs#haskell#editing#foldtext() " {{{
  function! haskell#tools#foldtext() " {{{
    let l:line = getline(v:foldstart)
    let l:keyword = matchstr(l:line, '\k\+')
    if count(['type', 'newtype', 'data'], l:keyword)
      return substitute(l:line, '\s*=.*', '', '') . ' '
    elseif count(['class', 'instance'], l:keyword)
      return substitute(l:line, '\s*\<where\>.*', '', '') . ' '
    endif
    return l:keyword . ' = '
  endfunction " }}}

  let g:haskell_tools_loaded = 1

endif
