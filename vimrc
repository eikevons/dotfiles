"""""""""""""""""""""""""""""""""
" editing behaviour {{{
set nocompatible
" TABs: always insert spaces instead of hard tabs
set softtabstop=4
set expandtab
set shiftwidth=4

" use indentation of 2. line of paragraphs
set formatoptions+=2
" don't add double space at end of sentences
set nojoinspaces

set sidescroll=1

" Add double-hash as comment starter.
set comments+=:##

" don't map Alt-... to menu short cuts
set winaltkeys=no

" Hide buffers instead of unloading (allows putting changed buffers in
" background)
set hidden

" searching 
set ignorecase
" Switch off case insensitive matching if pattern contains upper case
" characters.
set smartcase
set hlsearch

filetype plugin on
" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype plugin indent on
endif

" Save undo files for files in my home directory this should make backups
" unnecessary
au BufRead $HOME/* setlocal undofile
let g:undotree_DiffCommand = "diff -u"
set nobackup

" new builtin vim spell checking
set spelllang=de,en

" search recursively up to 3 directories deep with :find/:tabfind
set path+="./**3"

" exclude some files from file/directory completion
set wildignore+=*.o,*.pyc,*~

" 
set completeopt=menu,preview,longest

" }}}
"""""""""""""""""""""""""""""""""
" appearance {{{
set modeline
set showmatch   " Show matching brackets

" Make the preview window 4 lines high
set previewheight=4

" Setup statusline
set noruler
set laststatus=2
set statusline=%n\ %<%f\ %([%Y%H%M%R%W%{&paste?',PASTE':''}]%)\ %=%-10.(%l/%L,%v%)\ %P

set wildmenu    " Display menu when completing command line.

set lazyredraw
" Minimal number of screen lines to keep above and below the cursor
set scrolloff=3

if has("gui_running")
  " set guifont=Monospace\ 9
  " set guifont=Liberation\ Mono\ 8.5
  " set guifont=Terminus\ 10
  " set guifont=DejaVu\ Sans\ Mono\ 9
  set guifont=Inconsolata\ for\ Powerline\ 9
  set guioptions-=T
  set guioptions+=c
  set cursorline
endif

set listchars=eol:¶,tab:→\ ,trail:•

set fillchars=vert:│

" }}}
"""""""""""""""""""""""""""""""""
" folding {{{
set foldmethod=syntax
" set foldminlines=7
set foldopen=block,hor,insert,mark,quickfix,search,tag,undo
set foldnestmax=6
let g:sh_fold_enabled= 1
" }}}
"""""""""""""""""""""""""""""""""
" color and highlighting and syntax {{{
" colorscheme chela_light
" colorscheme desert
" colorscheme autumneike
" colorscheme buttercream
" set background=light

if $background == "light"
  set background=light
  colo SolarizedLight_eike
else
  set background=dark
  colo molokaieike
endif

hi Cursor guifg=White guibg=Red ctermfg=Green

" Set the cursor color in terminals. See
" <http://vim.wikia.com/wiki/Configuring_the_cursor>
if ! has("gui_running") && &term =~ "xterm\\|rxvt"
  let &t_SI = "\<Esc>]12;Green\x7"
  let &t_EI = "\<Esc>]12;Red\x7"
  silent !echo -ne "\033]12;Red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]12;Green\007"
  " autocmd VimLeave * silent !echo -ne "\033]112\007"
endif

syntax on

" TODO: Change background in terminal aswell.
function ToggleColorScheme()
  if g:colors_name == "SolarizedLight_eike"
    colo molokaieike
  else
    colo SolarizedLight_eike
  endif
endfunction

"""""""""""""""""""""""""""""""""
" Add `EIKE' to Todo syntax highlighting group for every file type.
augroup eiketodo
  autocmd FileType * exe "syntax keyword " . expand("<amatch>") . "Todo EIKE Eike"
augroup END


" }}}
"""""""""""""""""""""""""""""""""
" Plugin configurations {{{

"""""""""""""""""""""""""""""""""
" Settings for NERD_comments
" Set the standard comment to "# "
set commentstring=#\ %s
let NERDCommentWholeLinesInVMode=2
let NERDSpaceDelims=1
let NERDShutUp=1
" Don't use default NERD commenter key bindings
let NERDCreateDefaultMappings = 0
" See keybindings below...
" map <Leader>cc <plug>NERDCommenterComment
" map <Leader>cu <plug>NERDCommenterUncomment
" map <Leader>cy <plug>NERDCommenterYank
" map <Leader>c<space> <plug>NERDCommenterToggle

"""""""""""""""""""""""""""""""""
" for TeX filetype recognition.
" see: file:///usr/share/vim/vim70/filetype.vim line 1752
let g:tex_flavor = "latex"

"""""""""""""""""""""""""""""""""
" Settings for Python
let python_highlight_all = 1
let python_slow_sync = 1
" load template, replace filename and go to EOF
" autocmd BufNewFile *.py if expand("<afile>:p") !~ ".*/professor/.*" | 0r ~/.templates/sceleton_big.py | exe '%s/filename.py/\=expand("<afile>:t")/' | silent $  | endif
" autocmd BufNewFile */professor/*.py 0r ~/.templates/sceleton_small.py | exe '%s/filename.py/\=expand("<afile>:t")/' | silent $

"""""""""""""""""""""""""""""""""
" Setup SuperTab
" let g:SuperTabDefaultCompletionType = "context"
" Insert `literal' tab with Shift-Tab
" let g:SuperTabMappingTabLiteral = "<S-Tab>"
" However, this interferes with the default mapping to go backwards in the
" list of completions. So reset this here to Alt-Tab, i.e. something that
" never will be passed to vim.
" let g:SuperTabMappingBackward = "<M-Tab>"

"""""""""""""""""""""""""""""""""
" Setup XPTemplate

" Set SParg to empty string, to remove <space> in templates.
let g:xptemplate_vars = "SParg="

" SuperTab+XPTemplate cooperation (See XPTemplate FAQ).
" let g:SuperTabMappingForward = '<Plug>supertabKey'
" let g:xptemplate_fallback = '<Plug>supertabKey'
" let g:xptemplate_key = '<Tab>'

"""""""""""""""""""""""""""""""""
" Powerline
let g:Powerline_symbols = "fancy"
let g:Powerline_stl_path_style = "short"

"""""""""""""""""""""""""""""""""
" yankstack
" turn default mappings off
let g:yankstack_map_keys = 0

"""""""""""""""""""""""""""""""""
" Syntastic
let g:syntastic_python_checkers=['pyflakes']
let g:syntastic_check_on_open=1
let g:syntastic_always_populate_loc_list=1


"""""""""""""""""""""""""""""""""
" Switch-on pathogen to allow managing git-/svn-checkout scripts/plugins.
call pathogen#infect()

" }}}
"""""""""""""""""""""""""""""""""
" Light session management. {{{

fun SaveSession ()
  if v:this_session != ""
    exec "mksession! " . v:this_session
    echo "Saved session to " . v:this_session
  endif
endfun

au VimLeave * call SaveSession()

" Remember last position in files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" }}}
"""""""""""""""""""""""""""""""""
" Autocommands {{{

" 
" collapse spaces in quote indentations
"
augroup mail_eike
  au!
  au FileType mail silent %s/^\(>\) \([|>:}#]\)/\1\2/e
  au FileType mail normal gg
augroup END

" enable swig filetype
augroup filetypedetect
  au BufNewFile,BufRead *.i set filetype=swig
  au BufNewFile,BufRead *.swg set filetype=swig
augroup END

" set the file type for zsh function files
au BufRead ~/.zshfunctions/* set ft=zsh

" }}}
"""""""""""""""""""""""""""""""""
" Key mappings. {{{
" (add mappings to normal/visual => nor... 
"  or insert => inor... )
"
let mapleader = ","
let maplocalleader = ","

" See: http://stackoverflow.com/questions/563616/vimctags-tips-and-tricks
" Open tag under cursor in new split (show selection if ambiguous)
map <M-]> :stjump<CR>
map <C-M-]> :tab split<CR>:exec(":tjump " . expand("<cword>"))<CR>
"  show a list of matching tags in preview
nmap <C-\> :exec(":ptag " . expand("<cword>"))<CR>

" remap F1
imap <F1> <Esc>
map <F1> :bp<CR>
noremap gH :bp<CR>
map <F2> :bn<CR>
noremap gL :bp<CR>

" Add newlines below current line. Useful for Python scripting.
noremap <S-CR> o<Esc>k

" A keyboard-friendly replacement for Escape
ino jj <Esc>
cno jj <Esc>

" Don't use default NERD commenter key bindings
map <leader>cc <plug>NERDCommenterComment
map <leader>cu <plug>NERDCommenterUncomment
map <leader>cy <plug>NERDCommenterYank
map <leader>c<space> <plug>NERDCommenterToggle

" easier movement between buffers
" map <C-j>   <C-W>j
map <C-k>   <C-W>k
map <C-h>   <C-W>h
map <C-l>   <C-W>l

" re-create syntax coloring
nmap <leader>sy :syntax sync fromstart<cr>
" open a scratch buffer
nmap <leader>sb :Sscratch<CR>

" clear search buffer
nmap <silent> <leader>/ :let @/=""<CR>

" insert current path
" absolute dir
inoremap <leader>/d <C-R>=expand("%:p:h")<CR>
" relative dir
inoremap <leader>/r <C-R>=expand("%:h")<CR>

map z1 :set foldlevel=1<CR>

" Command line key mappings
" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>
" see: http://amix.dk/vim/vimrc.html
cnoremap $c <C-\>eAppendCurrentFileDir()<cr>

func! AppendCurrentFileDir()
  " see |c_CTRL-\_e|
  let cmd = getcmdline()
  if cmd[strlen(cmd)-1] != " "
    let cmd = cmd . " "
  endif
  let cmd = cmd . fnameescape(expand("%:h")) . "/"
  call setcmdpos(strlen(cmd)+1)
  return cmd
  " return a:cmd . " " . expand("%:p:h:") . "/"
endfunc

" Taglist
nnoremap <F3> :Tlist<CR>
inoremap <F3> <Esc>:Tlist<CR>a

" toggle line wrapping
nnoremap <F9> :set wrap!<CR>
inoremap <F9> <Esc>:set wrap!<CR>a

" toggle hlsearch
nnoremap <S-F9> :set hlsearch!<CR>
inoremap <S-F9> <Esc>:set hlsearch!<CR>a

" toggle displaying special characters
nnoremap <F10> :set list!<CR>
inoremap <F10> <Esc>:set list!<CR>a

" toggle line numbering
function ToggleNumber()
  if &number
    set nonumber
    set relativenumber
  elseif &relativenumber
    set nonumber
    set norelativenumber
  else
    set number
    set norelativenumber
  endif
endfunction

nnoremap <F11> :call ToggleNumber()<CR>
inoremap <F11> <Esc>:call ToggleNumber()<CR>a

" toggle dark and light colorscheme
nnoremap <F12> :call ToggleColorScheme()<CR>
inoremap <F12> <Esc>:call ToggleColorScheme()<CR>a

" get dictionary definition for some file types (latex, text, mail):
au FileType {tex,text,mail} nnoremap <M-d> :exec("!dict <cword>")<CR>

" map moving between tabs the same as in firefox
nnoremap gh :tabprevious<CR>
nnoremap gl :tabnext<CR>

" when displaying wrapped lines, make j/k do change visual lines
" and gj/gk physical lines
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" nnoremap Q gqap{}$k
nnoremap Q gqip
nnoremap <localleader>h- yypv$r-o<Esc>
inoremap <localleader>h- <Esc>yypv$r-o
nnoremap <localleader>h= yypv$r=o<Esc>
inoremap <localleader>h= <Esc>yypv$r=o
nnoremap <localleader>h~ yypv$r~o<Esc>
inoremap <localleader>h~ <Esc>yypv$r~o

" wrap visual-selected text in parentheses
vnoremap <leader>)  <ESC>`>a)<ESC>`<i(<ESC>
vnoremap <leader>}  <ESC>`>a}<ESC>`<i{<ESC>
vnoremap <leader>{  <ESC>`<i{<ESC>`>la}<ESC>
vnoremap <leader>"  <ESC>`>a"<ESC>`<i"<ESC>
vnoremap <leader>'  <ESC>`>a'<ESC>`<i'<ESC>
vnoremap <leader>`  <ESC>`>a`<ESC>`<i`<ESC>
vnoremap <leader>]  <ESC>`>a]<ESC>`<i[<ESC>

" See: http://vim.wikia.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"""""""""""""""""""""""""""""""""
" yankstack
if has("gui") " mapping to Meta-... only works in gVim
  nmap <M-p> <Plug>yankstack_substitute_older_paste
  nmap <M-n> <Plug>yankstack_substitute_newer_paste
endif

" }}}

" vim: foldmethod=marker
