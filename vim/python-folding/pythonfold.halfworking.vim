" vim:sts=2:sw=2
" 
" Python code folding copied from AutoFoldEIKE.vim
"
" set foldopen=block,hor,insert,mark,quickfix,search,tag,undo
setlocal foldmethod=expr
setlocal foldexpr=PyFold(v:lnum)
setlocal foldtext=PyFoldText()

" pattern for class/function definitions
let s:defpat = '^\s*\(class\|def\)\s'

function! PyFold(lnum)
  let line = getline(a:lnum)

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
  
  " Zero-indent comments are never folded.
  if line =~ '^#'
    return '0'
  endif
  " Comment lines are ignored.
  if line =~ '^\s*#'
    return '='
  endif

  " Classes and functions open a new fold.
  if line =~ s:defpat
    return 'a1'
  endif

  " Work around multiline class/function headers
  if line =~ '):'
    return '='
  endif 

  " Folds are ended if a class or function ends.
  " A definition ends if the indentation of the next non-blank line is
  " less-or-equal than the previous definition with an indentation that is
  " less than the current line. This is, however, only true if we don't deal
  " with continued lines like
  " somefunction(foo,
  "              bar)
  let ind  = indent(a:lnum)
  let nnum = nextnonblank(a:lnum + 1)
  let nind = indent(nnum)

  if nind >= ind
    return '='
  endif

  " Find the previous line with less-or-equal indent than next indent.
  let pnum = a:lnum
  let pind = indent(pnum)
  while pind > nind
    let pnum = prevnonblank(pnum - 1)
    let pind = indent(pnum)
    if pnum == 0
      return '='
    endif
  endwhile
  " If this prev. line is a definition, it is ended by the current line.
  if getline(pnum) =~ s:defpat
    return "<" . (pind / &sw + 1)
  endif

  " Find the previous definition line with indentation less than the
  " current indentation.
  let pdefnum = a:lnum
  let pdefind = indent(pdefnum)
  while getline(pdefnum) !~ s:defpat || pdefind >= ind
    let pdefnum = prevnonblank(pdefnum - 1)
    let pdefind = indent(pdefnum)

    if pdefnum == 0
      return '='
    endif
  endwhile
  " The current indentation block ends if the indent of the next block is
  " equal or less than the indentation of the previous definition.

  if nind < pdefind
    " return 's1'
    return "<" . (pind / &sw + 1)
  endif

  return '='
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
