""""""""""""""""""""
" Folding
"
" Fold only comment blocks.
" NOTE: Currently, this is not working!
setlocal foldmethod=syntax
syn region javascriptFoldComment start=/\/\*/ end=/\*\// transparent fold keepend
" setlocal foldlevelstart=1
" syn region foldBraces start=/{/ end=/}/ transparent fold keepend
