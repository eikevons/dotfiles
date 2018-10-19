nmap K :help <C-R><C-W><CR>
setlocal shiftwidth=2
setlocal softtabstop=2

" https://vi.stackexchange.com/a/3187
command! -buffer -bar -range=% Execbuf execute <line1> . ',' . <line2> . 'y|@"'
