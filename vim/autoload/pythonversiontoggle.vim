" Simple function to toggle settings between python 2 and python 3.

function pythonversiontoggle#toggle()
  if exists("b:python_version")
    let current_version = b:python_version
  else
    let current_version = 2
  endif
  if current_version == 2
    echom "Switching to Python3 in " . expand('%:t')
    let b:python_version = 3
    let b:syntastic_python_pyflakes_exec = "python3"
    let b:syntastic_python_pylint_exec = "python3"
  else
    echom "Switching to Python2 in " . expand('%:t')
    let b:python_version = 2
    let b:syntastic_python_pyflakes_exec = "python"
    let b:syntastic_python_pylint_exec = "python"
  endif
endfun
