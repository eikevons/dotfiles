" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the Python syntax to start with
if version < 600
  so <sfile>:p:h/python.vim
else
  runtime! syntax/python.vim
  unlet b:current_syntax
endif

" Pyrex extentions
syn keyword pyrexStatement      cdef cpdef typedef ctypedef sizeof
syn keyword pyrexType		int long short float double char object void
syn keyword pyrexType		signed unsigned
syn keyword pyrexStructure	struct union enum
syn keyword pyrexPrecondit	include cimport
syn keyword pyrexAccess		public private property readonly extern
syn keyword pyrexMacro          DEF IF ELIF ELSE
" If someome wants Python's built-ins highlighted probably he
" also wants Pyrex's built-ins highlighted
if exists("python_highlight_builtins") || exists("pyrex_highlight_builtins")
    syn keyword pyrexBuiltin    NULL
endif

hi def link pyrexStatement  Statement
hi def link pyrexType       Type
hi def link pyrexStructure  Structure
hi def link pyrexPrecondit  PreCondit
hi def link pyrexAccess	    pyrexStatement
if exists("python_highlight_builtins") || exists("pyrex_highlight_builtins")
    hi def link pyrexBuiltin  Function
endif
hi def link pyrexForFrom    Statement
hi def link pyrexMacro      Macro

setlocal fdm=syntax

" Nested function and class definitions
syn region  cythonFoldDefinitionsNested
  \ start="^\z(\s\+\)\%(cp?def\)\>"
  \ end="\ze\%(\s*\n\)\+\%(\z1\s\)\@!."
  \ fold transparent

hi link cythonDefinition Statement

" TODO: This does not work with 0-level functions and classes because only one
" syntax object is allowd to start at each position and this interferes with
"
" syn keyword pythonStatement	class def nextgroup=pythonFunction skipwhite
"
" above.
"
" The following rule works but includes the preceding line in the fold.
" Extending the pattern to the following line does not work.

" Top-level function and class definitions
" NOTE: \h instead of a-zA-Z_ does not work in end="..."
syn region  cythonFoldDefinitionsTopLevel
  \ start="\n\%(cp\=def\)"
  \ end="\ze\%(\s*\n\)\+[a-zA-Z_#@]"
  \ fold transparent

let b:current_syntax = "cython"
