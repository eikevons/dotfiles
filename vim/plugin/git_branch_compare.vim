" See https://github.com/tpope/vim-fugitive/issues/132#issuecomment-290644034
" ----------------------------------------------------------------------------
" DiffRev
" ----------------------------------------------------------------------------
"
if exists('g:loaded_git_diff_rev') || &cp
  finish
endif
let g:loaded_git_diff_rev = 1

let s:git_status_dictionary = {
            \ "A": "Added",
            \ "B": "Broken",
            \ "C": "Copied",
            \ "D": "Deleted",
            \ "M": "Modified",
            \ "R": "Renamed",
            \ "T": "Changed",
            \ "U": "Unmerged",
            \ "X": "Unknown"
            \ }
function! s:get_diff_files(rev)
  let list = map(split(system(
              \ 'git diff --name-status '.a:rev), '\n'),
              \ '{"filename":matchstr(v:val, "\\S.*$", 2),"text":s:git_status_dictionary[matchstr(v:val, "^\\w")]}'
              \ )
  call setqflist(list)
  copen

  if exists('g:loaded_fugitive') 
    exe 'nnoremap <buffer> <silent> D <CR>:Gdiff ' . a:rev . '<CR>'
  endif
endfunction

command! -nargs=1 DiffRev call s:get_diff_files(<q-args>)
