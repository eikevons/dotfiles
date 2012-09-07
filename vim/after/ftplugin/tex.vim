" short cuts for arrows
" call IMAP("<-", "\\leftarrow", "tex")
call IMAP("<=", "\\Leftarrow", "tex")
" call IMAP("->", "\\rightarrow", "tex")
call IMAP("=>", "\\Rightarrow", "tex")

" switch bigcap and bar
call IMAP("`-", "\\bar{<++>}<++>", "tex")
call IMAP("`_", "\\bigcap", "tex")
" isn't working: call IMAP("`.", "\\cdot", "tex") 
call IMAP("`'", "\\cdot", "tex")

call IMAP("MRM", "\\mathrm{\<++>}\<++>", "tex")
call IMAP("MBF", "\\mathbf{\<++>}\<++>", "tex")
call IMAP("MIT", "\\mathit{\<++>}\<++>", "tex")
call IMAP("MCA", "\\mathcal{\<++>}\<++>", "tex")

call IMAP("`w", "\\omega", "tex")
call IMAP("`T", "\\perp", "tex")

let g:Tex_Env_equation="%\<CR>\\begin{equation}\\label{eq:<+label+>}\<CR><++>\<CR>\\end{equation}\<CR>%\<CR><++>"
" pimp display math: use equation* instead
let g:Tex_Env_displaymath="%\<CR>\\begin{equation*}\<CR><++>\<CR>\\end{equation*}\<CR>%\<CR><++>"

let g:Tex_Env_figure="%\<CR>\\begin{figure}\<CR>\\centering\<CR>\\includegraphics[width=<+width+>]{<+graphics file+>}\<CR>\\caption{<+caption text+>}\<CR>\\label{fig:<+label+>}\<CR>\\end{figure}\<CR>%\<CR><++>"

" for beamer class
call IMAP("BFR", "\\begin{frame}{<+title+>}\<CR><++>\<CR>\\end{frame}", "tex")
call IMAP("BBK", "\\begin{block}{<+title+>}\<CR><++>\<CR>\\end{block}", "tex")

" also fold at xparagraphs
let Tex_FoldedSections="part,chapter,section,%%fakesection,subsection,subsubsection,paragraph,xparagraph"

let Tex_FoldedEnvironments="verbatim,comment,frame,eq,gather,align,figure,table,thebibliography,keywords,abstract,titlepage"

let g:tex_isk="48-57,a-z,A-Z,192-255,:,-"

" help compiling *-body.tex files
" au BufWrite */*-body.tex set makeprg=make
if ! exists("*<sid>Set_Makeprg")
    function s:Set_Makeprg()
        echo expand("%:p:h")
        if filereadable(expand("%:p:h") . "/Makefile")
            setlocal makeprg=make
        " elseif expand("%") ~= ".*-body.tex"
            " setlocal makeprg=make
        endif
    endfunction
endif

au BufWrite *.tex silent call s:Set_Makeprg()
