function! FoldNestedIndent(lnum)
  if getline(a:lnum) =~ '^\s*$'
    if indent(nextnonblank(a:lnum + 1)) < 1
      " Empty lines are never folded if they are followed by a non-indented line 
      return '0'
    else
      return '='
    endif
  endif

  let l:ithis = indent(a:lnum)
  let l:inext = indent(nextnonblank(a:lnum + 1))

  if l:inext < l:ithis
    " End fold on
    "     ...
    "     this
    "   next
    return '<' . (l:ithis / &sw)
  elseif l:inext > l:ithis
    " Start a new fold on
    "   ...
    "   this
    "     next
    return '>' . (l:inext / &sw)
  endif

  return l:ithis / &sw
endfunction
