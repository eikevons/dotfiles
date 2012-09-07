set foldnestmax=3

syntax region myFold start="{" end="}" transparent fold
" syntax region myFold2 start="/\*" end="\*/" transparent fold
syntax sync fromstart
set foldmethod=syntax
