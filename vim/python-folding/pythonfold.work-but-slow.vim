" vim:sts=2:sw=2
" 
" Python code folding copied from AutoFoldEIKE.vim
"
setlocal foldmethod=expr
setlocal foldexpr=PyFold(v:lnum)
setlocal foldtext=PyFoldText()

" pattern for class/function definitions
let s:defpat = '^\s*\(class\|def\)\s'
let s:commpat = '^\s*#'

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
  if line =~ '^\s*#.*{{{'
    return 'a1'
  endif
  if line =~ '^\s*#.*}}}'
    return 's1'
  endif
  
  " Zero-indent comments are never folded.
  if line =~ '^#'
    return '0'
  endif
  " Comment lines are ignored.
  if line =~ s:commpat
    return '='
  endif

  " Classes and functions get their own folds
  if line =~ s:defpat
    return 'a1'
    " return ">" . (ind / &sw + 1)
  endif

  let ind = indent(a:lnum)
  if ind == 0
    return '0'
  endif

  " Find the next non-comment line.
  let nnum = nextnonblank(a:lnum + 1)
  while nnum > 0 && getline(nnum) =~ s:commpat
    let nnum = nextnonblank(nnum + 1)
  endwhile

  let nind = indent(nnum)

  " Nothing changes if next non-comment line has greater-equal indent.
  if nind >= ind
    return '='
  endif

  let defdepth = PyDefDepth(a:lnum)
  let ndefdepth = PyDefDepth(nnum)
  
  if defdepth != ndefdepth
    return 's' . (defdepth - ndefdepth)
  endif

  return '='
endfunction

" Return the depth of definitions. This is the number of class/def statements
" that are above in lines *directly* less indented than this one.
function! PyDefDepth(lnum)
  let ind = indent(a:lnum)
  let lnum = a:lnum
  let depth = 0
  while ind > 0 && lnum > 0
    " temporary variables
    let tnum = prevnonblank(lnum-1)
    let tind = indent(tnum)
    if tind < ind
      let ind = tind
      if getline(tnum) =~ s:defpat
        let depth += 1
      endif
    endif
    let lnum = tnum
  endwhile
  return depth
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
