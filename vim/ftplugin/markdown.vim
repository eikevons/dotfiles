setlocal tw=76
setlocal autoindent
setlocal sw=2

if executable("render-md")
  command Render :call system(printf('render-md %s', shellescape(expand('%'))))
  nmap <buffer> <leader>r :Render<CR>
endif
