" runtime! syntax/rst.vim
"
if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "rst-fold"


" TODO: Add folding
" syn region foldBlock
  " \ start=+::\_s*\n\ze\z(\s\+\)+
  " \ skip=+^$+
  " \ end=+^\z1\@!+
  " \ fold transparent keepend extend

syn region foldBlock2
 \ start=+  [^ ]+
 \ end=+^$+
 \ fold

setl foldmethod=syntax
