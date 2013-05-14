" Taken from <http://www.haskell.org/haskellwiki/Vim>
" Tab specific option
setlocal tabstop=8                   "A tab is 8 spaces
setlocal expandtab                   "Always uses spaces instead of tabs
setlocal softtabstop=4               "Insert 4 spaces when tab is pressed
setlocal shiftwidth=4                "An indent is 4 spaces
setlocal smarttab                    "Indent instead of tab at start of line
setlocal shiftround                  "Round spaces to nearest shiftwidth multiple
setlocal nojoinspaces                "Don't convert spaces to tabs

setlocal iskeyword=@,48-57,_,'
setlocal keywordprg=hoogle\ -i

setlocal include=^import\\s*\\(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal suffixesadd=hs,lhs,hsc,hsx

" Install indent function from tools.vim
setlocal indentexpr=haskell#tools#indentexpr(v:lnum)
setlocal indentkeys=!^F,o,O

setlocal foldmethod=syntax
setlocal foldtext=haskell#tools#foldtext()

setlocal comments=s1:{-,mb:-,ex:-},:--
setlocal commentstring=--%s
setlocal formatoptions+=croql1
setlocal formatoptions-=t
silent! setlocal formatoptions+=j
setlocal textwidth=75
