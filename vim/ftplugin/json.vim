setlocal shiftwidth=2
if executable('jq')
  setlocal formatprg=jq\ .
elseif executable('python')
  setlocal formatprg=python\ -mjson.tool
endif
