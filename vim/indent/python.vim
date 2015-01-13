" Vim indent file
" Language:             Python
" Maintainer:           David Moore <david@linuxsoftware.co.nz>
" Original Author:      David Bustos <bustos@caltech.edu>
" Last Change:          2010 Mar 3
"
" EIKE: Modified to use Google-style indents from
" http://stackoverflow.com/questions/5696837/google-python-style-script-not-working

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Some preliminary settings
setlocal nolisp         " Make sure lisp indenting doesn't supersede us
setlocal autoindent     " indentexpr isn't much help otherwise

setlocal indentexpr=GetGooglePythonIndent(v:lnum)
setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif,=except

" Only define the function once.
if exists("*GetGooglePythonIndent")
  finish
endif

" Come here when loading the script the first time.

let s:maxoff = 50       " maximum number of lines to look backwards for ()

function GetGooglePythonIndent(lnum)
  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  echo par_line par_col
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    else
      return indent(par_line) + &sw " FIXED HERE. FIXED BY ADDING THIS LINE
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)
endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

" vim:sw=2
