" Bootstrap the plugin
fu! utilities#Bootstrap(...)
    " make sure to bootstrap the basePath as needed
    call utilities#BasePath()
    " now load up local vimrc files
    call utilities#LoadLocalVimrc()
    if len(a:000) > 0
        return
    " open up explore if no args are passed on startup
    elseif len(argv()) == 0
        Explore
    " check to make sure directory wasn't passed
    elseif isdirectory(argv()[0]) && len(a:000) == 0
        let g:basePath=argv()[0]
        Explore
    endif
endfunction

if !exists("*BeforeHook")
    function BeforeHook()
    endfunction
endif

if !exists("*AfterHook")
    function AfterHook()
    endfunction
endif

"""
""" Autocommand Event Mappings
"""
" link up autocommands as needed
" :help autocmd-events
" now lets actually call the global vimrc file at all times
autocmd VimEnter * call utilities#Bootstrap()

"check to see if argv was passed
"resolve argv to grab the base directory
"grab the current working directory
fu! utilities#BasePath()
  if exists("g:basePath")
    return
  endif
  let g:basePath=substitute(system("pwd"), "\n", "","")
endfunction

" local.vimrc override!
fu! utilities#LoadLocalVimrc()
  call utilities#BasePath() 
  let localPath = g:basePath ."/.local.vimrc"
  if filereadable(localPath)
    execute("so ". localPath)
  endif
endfunction

" run a command in a clean shell
fu! utilities#CleanShell(...)
  " execute a single command
  fu! ExecuteCommand(command)
    execute "! ". a:command
  endfunction
  " always clear the screen before executing anything
  let command="printf \"\033c\"" 
  " now loop through each of the commands and append them
  let c=1
  while c <= a:0
    let commandPiece=eval("a:". c)
    let command=command ." && ". commandPiece
    let c += 1
  endwhile
  " now execute our fully formed command
  call ExecuteCommand(command)
endfunction

fu! utilities#Zsh(...)
  let command = "source ~/.zshrc && "
  let c=1
  while c <= a:0
    let commandPiece=eval("a:". c)
    let command=command ." ". commandPiece
    let c += 1
  endwhile
  execute "! ". command
endfunction

fu! utilities#CleanZsh(...)
  let command="printf \"\033c\" && source ~/.zshrc &&" 
  let c=1
  while c <= a:0
    let commandPiece=eval("a:". c)
    let command=command ." ". commandPiece
    let c += 1
  endwhile
  execute "! ". command
endfunction

fu! utilities#ArgsToString(join, args)
  let command=""
  for i in a:args
    let command=command . a:join . i
  endfor
  return command
endfunction

fu! utilities#GetFileType(path)
  return &ft
endfunction

fu! utilities#Capitalize(input)
  return substitute(a:input, '.', '\u&', '') 
  "return join([toupper(a:input[0]), a:input[1:len(a:input)]], "")
endfunction




