"""""""""""""""""""""""""""""""""
" editing behaviour {{{
set nocompatible
" TABs: always insert spaces instead of hard tabs
set softtabstop=4
set expandtab
set shiftwidth=4
set smarttab

" No bell on <esc>
set belloff+=esc

" use indentation of 2. line of paragraphs + continue with comments on newline and o
set formatoptions+=2co

set autoindent
set backspace=indent,eol,start

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
set incsearch
" Switch off case insensitive matching if pattern contains upper case
" characters.
set smartcase
set hlsearch
" default to replace all occurences
set gdefault

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
set wildignore+=*.o,*.pyc,*~,node_modules

" Completion
set completeopt=menu,preview,longest
set complete-=i

" Disable modelines
set nomodeline


" Configure diff
" Inspired by https://www.reddit.com/r/vim/comments/om1uyj/best_diff_config_for_vim_in_2021/
set diffopt=filler,iwhite,vertical,internal,indent-heuristic,algorithm:histogram


" }}}
"""""""""""""""""""""""""""""""""
" appearance {{{
set showmatch   " Show matching brackets

" Make the preview window 4 lines high
set previewheight=4

" Setup statusline
set ruler
set laststatus=2
set statusline=%n\ %<%f\ %([%Y%H%M%R%W%{&paste?',PASTE':''}]%)\ %=%-10.(%l/%L,%v%)\ %P

set display+=lastline

set wildmenu    " Display menu when completing command line.
set wildmode=list:longest

set lazyredraw
" Minimal number of screen lines to keep above and below the cursor
set scrolloff=3

if has("gui_running")
  " set guifont=Monospace\ 9
  " set guifont=Liberation\ Mono\ 8.5
  " set guifont=DejaVu\ Sans\ Mono\ 9
  " set guifont=Inconsolata\ for\ Powerline\ 9
  " set guifont=Terminus\ 8
  " set guifont=Fantasque\ Sans\ Mono\ 12
  set guifont=Iosevka\ Light\ 12
  set guioptions-=T
  set guioptions-=m
  set guioptions+=c
  set cursorline
endif

set listchars=eol:$,tab:>\ ,trail:+,nbsp:~

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

if has("gui_running")
  set background=dark
  colo molokaieike
else
  if $background == "light"
    set background=light
    colo SolarizedLight_eike
  else
    set background=dark
    colo molokaieike
  endif
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
" Airline
" let g:airline_detect_paste=1
if !exists('g:airline_symbols')
  " See airline-customization help tag
  let g:airline_symbols = {}
  " Make symbols smaller
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.paste = '+P'
  " let g:airline_symbols.branch = 'B'
  let g:airline_symbols.whitespace = 'WS'
  let g:airline_symbols.dirty='⚡'
endif
let g:airline#extensions#branch#displayed_head_limit = 15
" Turn off counting of words
let g:airline#extensions#wordcount#enabled = 0

"   let g:airline_left_sep = '\'
"   let g:airline_right_sep = '/'
"   let g:airline_symbols.linenr = '␤'
" endif

"""""""""""""""""""""""""""""""""
" yankstack 1/3
" turn default mappings off
let g:yankstack_map_keys = 0


"""""""""""""""""""""""""""""""""
" Syntastic
" Syntax checkers are configured in ftplugin/*
let g:syntastic_check_on_open=1
let g:syntastic_always_populate_loc_list=1

"""""""""""""""""""""""""""""""""
" indentLine
" Disable by default. Use <F10> to toggle &list->indentLine->nothing
let g:indentLine_enabled = 0

"""""""""""""""""""""""""""""""""
" vim-go
" Disable go-fmt on save
let g:go_fmt_autosave = 0

"""""""""""""""""""""""""""""""""
" ack
" Use rg as search if possible
if executable("rg")
  "let g:ack_default_options = " -s -H --nopager --nocolor --nogroup --column"
  let g:ackprg = "rg --no-messages --with-filename --color=never --column --no-heading"
endif

"""""""""""""""""""""""""""""""""
" editorconfig
" Follow recommendations from README
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"""""""""""""""""""""""""""""""""
" Copilot
" Disable for all filetypes by default
let g:copilot_filetypes = {
      \ "*": v:false,
      \ }

"""""""""""""""""""""""""""""""""
" Switch-on pathogen to allow managing git-/svn-checkout scripts/plugins.
call pathogen#infect()

"""""""""""""""""""""""""""""""""
" yankstack 2/3
" Make sure yankstack is setup before surround plugin to allow surround
" overwrite yankstack key bindings.
" See https://github.com/maxbrunsfeld/vim-yankstack/issues/9 .
call yankstack#setup()

let g:markdown_folding = 1

"""""""""""""""""""""""""""""""""
" UTL

if executable("xdg-open")
  let g:utl_cfg_hdl_scm_http_system = "!xdg-open '%u'"
endif


"""""""""""""""""""""""""""""""""
" R syntax
let r_syntax_folding = 1

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
nnoremap \ ,
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
noremap gL :bn<CR>

" Add newlines below current line. Useful for Python scripting.
noremap <S-CR> o<Esc>k

" Fix number of consecutive emtpy lines.
function FixEmptyLines(n_lines)
  if getline('.') !~ "^ *$"
    return
  endif

  " Jump to the first empty line in the block
  call search('\(^ *$\)\@!', 'b')
  normal j

  execute 's/\(\s*\n\)\+/' . repeat('\r', a:n_lines) . '/e'

  " Work around end-of-file bug
  if line('.') == line('$')
    normal "_dd
  endif
endfunction

" Collapse multiple consecutive blank lines into 2.
map <leader><space> :<C-U>call FixEmptyLines(v:count > 0 ? v:count : 2)<CR>
map <leader><S-space> :call FixEmptyLines(0)<CR>

" A keyboard-friendly replacement for Escape
ino jj <Esc>
cno jj <Esc>

" easier movement between buffers
" map <C-j>   <C-W>j
map <C-k>   <C-W>k
map <C-h>   <C-W>h
map <C-l>   <C-W>l

" Quick-jump to buffers
set wildcharm=<C-Z>
nnoremap <C-B> :CtrlPBuffer<CR>

noremap <Left>  <C-W>h
noremap <Down>  <C-W>j
noremap <Up>    <C-W>k
noremap <Right> <C-W>l

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
nnoremap <C-F9> :set hlsearch!<CR>
inoremap <C-F9> <Esc>:set hlsearch!<CR>a

" toggle displaying special characters and indentation marks
function ToggleList()
  if &list
    set nolist
    :IndentLinesEnable
  elseif exists("b:indentLine_enabled") && b:indentLine_enabled
    set nolist
    :IndentLinesDisable
  else
    set list
  endif
endfunction

nnoremap <F10> :call ToggleList()<CR>
inoremap <F10> <Esc>:call ToggleList()<CR>a

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

" 

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

" NOTE (2016-11-22): This should be obsoleted by surround.vim .
" " wrap visual-selected text in parentheses
" vnoremap <leader>)  <ESC>`>a)<ESC>`<i(<ESC>
" vnoremap <leader>}  <ESC>`>a}<ESC>`<i{<ESC>
" vnoremap <leader>{  <ESC>`<i{<ESC>`>la}<ESC>
" vnoremap <leader>"  <ESC>`>a"<ESC>`<i"<ESC>
" vnoremap <leader>'  <ESC>`>a'<ESC>`<i'<ESC>
" vnoremap <leader>`  <ESC>`>a`<ESC>`<i`<ESC>
" vnoremap <leader>]  <ESC>`>a]<ESC>`<i[<ESC>

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

if has("gui_running") " mapping to Meta-... only works in gVim
  """""""""""""""""""""""""""""""""
  " yankstack 3/3
  nmap <M-p> <Plug>yankstack_substitute_older_paste
  nmap <M-n> <Plug>yankstack_substitute_newer_paste

  """""""""""""""""""""""""""""""""
  " vim-fontsize
  nmap <silent> <Leader>f= <Plug>FontsizeInc
  nmap <silent> <Leader>f+ <Plug>FontsizeInc
  nmap <silent> <Leader>f- <Plug>FontsizeDec
  nmap <silent> <Leader>f0 <Plug>FontsizeDefault

endif

" }}}

" vim: foldmethod=marker
