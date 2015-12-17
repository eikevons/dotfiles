""""""""""""""""""""
" Folding
"
" Fold only comment blocks.
setlocal foldmethod=syntax
syn region javascriptFoldComment start=/\/\*/ end=/\*\// transparent fold keepend
" syn region foldBraces start=/{/ end=/}/ transparent fold keepend
