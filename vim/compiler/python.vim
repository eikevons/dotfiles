" Vim compiler file
" Compiler:		Python     
" Maintainer:   Christoph Herzog <ccf.herzog@gmx.net>
" Last Change:  2002 Nov 9

if exists("b:current_compiler")
  finish
endif
let b:current_compiler = "python"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=pychecker\ %
CompilerSet errorformat=
    \%A\ \ %m\ (%f\\\,\ line\ %l),
    \%C\ \ \ \ %.%#,
    \%-C%p^,
    \%Z%\\w%#,
    \%f\:%l\:\ %m,
    \%-G%.%#

"the last line: \%-G%.%# is meant to suppress some
"late error messages that I found could occur e.g.
"with wxPython and that prevent one from using :clast
"to go to the relevant file and line of the traceback.
" CompilerSet makeprg=python\ %
" CompilerSet errorformat=
"     \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
"     \%C\ \ \ \ %.%#,
"     \%+Z%.%#Error\:\ %.%#,
"     \%A\ \ File\ \"%f\"\\\,\ line\ %l,
"     \%+C\ \ %.%#,
"     \%-C%p^,
"     \%Z%m,
"     \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

"vim: ft=vim
