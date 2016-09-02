let s:V = vital#of('speaker_vim')
let s:Prelude = s:V.import('Prelude')
let s:Process = s:V.import('Process')

let s:say_command = {}
if s:Prelude.is_unix()
  let s:say_command = g:speakervim#say_commands['unix']
elseif s:Prelude.is_mac()
  let s:say_command = g:speakervim#say_commands['mac']
elseif s:Prelude.is_windows()
  let s:say_command = g:speakervim#say_commands['win']
endif

function! speaker#set_lang(...) abort
  if a:0 > 0
    let lang = a:1
  else
    let list_langs = keys(s:say_command)
    let lang = list_langs[str2nr(inputlist(list_langs))]
  endif
  let g:speakervim#lang = lang
endfunction

function! speaker#list_languages(A,L,P) abort
  return keys(s:say_command)
endfunction

function! speaker#killall() abort
  call s:killall_say()
endfunction

function! s:killall_say()
  for lang in keys(s:say_command)
    call s:kill_say(lang)
  endfor
endfunction

function! s:kill_say(lang)
  call s:Process.system(s:say_command[a:lang]['kill'])
endfunction

function! s:say(text,...)
  if a:0 > 0
    let lang = a:1
  else
    let lang = g:speakervim#lang
  end
  let escaped_text = substitute(s:say_command[lang]['cmd'], "{{text}}", substitute(a:text, '"', '\\\\"', "g"), "g")
  call s:Process.system(escaped_text, {'background': 1})
endfunction

function! speaker#say(text) abort
  echomsg a:text
  call s:kill_say(g:speakervim#lang)
  call s:say(a:text, g:speakervim#lang)
  return
endfunction

function! speaker#operator(motion_wise) abort
  "let visual_command = s:visual_command_from_wise_name(a:motion_wise)
  "let is_visual = s:is_visual(mode())
  " Raw cword without \<\>
  "let text = (is_visual ? s:get_selected_text() : s:Prelude.escape_pattern(expand('<cword>')))
  let text = s:get_visual_selection()
  echomsg text
  call s:kill_say(g:speakervim#lang)
  call s:say(text, g:speakervim#lang)
  return
endfunction

function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

"function! s:visual_command_from_wise_name(wise_name)
"  if a:wise_name ==# 'char'
"    return 'v'
"  elseif a:wise_name ==# 'line'
"    return 'V'
"  elseif a:wise_name ==# 'block'
"    return "\<C-v>"
"  else
"    echoerr 'E1: Invalid wise name:' string(a:wise_name)
"    return 'v'  " fallback
"  endif
"endfunction
