" 
" Python code folding copied from AutoFoldEIKE.vim
"
"filetype on
" moved to .vimrc
" set foldcolumn=0
" set foldminlines=4
" set foldopen=block,hor,insert,mark,quickfix,search,tag,undo
setlocal foldmethod=expr
setlocal foldexpr=PyFold(v:lnum)
setlocal foldtext=PyFoldText()

function! PyFold(lnum)
    let line = getline(a:lnum)
    let ind  = indent(a:lnum)

    " Ignore blank lines
    if line =~ '^\s*$'
      return "="
    endif

    " Ignore triple quoted strings
    if line =~ "(\"\"\"|''')"
      return "="
    endif

    " Ignore continuation lines
    if line =~ '\\$'
      return '='
    endif

    " TODO: Allow region folds
    " if line =~ '^\s# {{{'
        " return 'a1'
    " endif
    " if line =~ '^\s# }}}'
        " return 's1'
    " endif
    
    " Ignore comment lines
    if line =~ '^\s*#'
      return '='
    endif

    " Classes and functions get their own folds
    if line =~ '^\s*\(class\|def\)\s'
      return ">" . (ind / &sw + 1)
      " return 'a1'
    endif

    let nnum = nextnonblank(a:lnum + 1)
    " work around comments at the end of class/def statements
    " isn't working well! -> TODO
    while getline(nnum) =~ '^\s*#'
      let nnum = nextnonblank(nnum + 1)
    endwhile
    let nind = indent(nnum)

    if nind < ind

      " Work around multiline class/function headers
      if line =~ '):'
        return "="
      endif 

      " " The previous definiton of a class or function.
      " let pdefnum = prevnonblank(a:lnum - 1)
      " while pdefnum > 0 && getline(pdefnum) !~ '^\s\(class\|def\)\s'
          " let pdefnum = prevnonblank(pdefnum - 1)
      " endwhile
      " if pdefnum > 0
          " let ndefnum = nnum

          " while getline(ndefnum) !~ '^\s\(class\|def\)\s'
              " let ndefnum = nextnonblank(ndefnum + 1)
          " endwhile

          " if ndefnum > 0
              " let pdefind = indent(pdefnum)
              " let ndefind = indent(ndefnum)

              " if pdefind > ndefind
                  " return 's1'
              " endif
          " endif
      " endif

      let pnum = prevnonblank(a:lnum - 1)
      let pind = indent(pnum)

      while pind > nind
        let pnum = prevnonblank(pnum - 1)
        let pind = indent(pnum)
      endwhile

      let pline = getline(pnum)

      if pline =~ '^\s*\(class\|def\)\s'
        return "<" . (pind / &sw + 1)
        " return 's1'
      endif
    endif

    return "="
endfunction

function! PyFoldText()
  let l:lcnt = v:foldend - v:foldstart + 1
  let l:line = getline(v:foldstart)
  " Clean up line.
  if l:line =~ '^\s*\/\*[*]*\s*$'
    let l:line = getline(v:foldstart + 1)
  endif

  let l:line = substitute(l:line, '^\"\s*\|\s*\&\S*\*\s*$', '', 'g')
  let l:line = substitute(l:line, '^def\s', 'Function: ', 'g')
  let l:line = substitute(l:line, '^class\s', 'Class: ', 'g')

  " get a doc string if we have one
  let l:cnum = v:foldstart
  while  getline(l:cnum) !~ ":$" && l:cnum < v:foldend
      let l:cnum = l:cnum + 1
  endwhile

  let l:doc = getline(l:cnum + 1)
  " ord(') = 39
  " ord(") = 34
  if l:doc =~ '^\s*["' . "']"
      let l:doc = substitute(l:doc, '^\s*["' . "']*", '', 'g')
      let l:doc = substitute(l:doc, '["' . "']*\s*$", '', 'g')
  else
      let l:doc = "no doc"
  endif

  let l:line = l:line . " " . l:doc

  " let l:line = substitute(l:line, '^\s*\|/\*\|\*\|\*/\|\s*[{{{]\s*\d*\|\s*$', '', 'g')
  " Set line width.
  let l:width = &columns -  (13 + &fdc)
  if strlen(l:line) > l:width
    let l:line = strpart(l:line,0,l:width - 2) . "..."
  else
    while strlen(l:line) <= l:width
        let l:line = l:line . " "
    endwhile
  endif
  " Set tail (line count, etc.).
  if     l:lcnt <= 9   | let l:tail = "[lines:   " . l:lcnt . "]"
  elseif l:lcnt <= 99  | let l:tail = "[lines:  ". l:lcnt . "]"
  elseif l:lcnt <= 999 | let l:tail = "[lines: ". l:lcnt . "]"
  else                 | let l:tail = "[lines:". l:lcnt . "]"| endif
  " Set return line
  return l:line . l:tail . "<"
endfunction
