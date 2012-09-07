setlocal tw=72
" break only at characters in 'breakat' 
setlocal linebreak

" do not spell check comments
let g:tex_comment_nospell=1

setlocal spell
syn spell toplevel

" only indent a bit
setlocal sw=2
setlocal sts=2

" don't break key words at ":"
" useful for labels
setlocal iskeyword+=:

let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_MultipleCompileFormats="dvi,pdf"

" key mappings with IMAP are in ~/.vim/after/ftplugin/tex.vim to overwrite
" latex-suite's default mappings
