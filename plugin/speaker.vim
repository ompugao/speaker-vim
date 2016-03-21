if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_speakervim
endif
if exists('g:loaded_speakervim')
  finish
endif
let g:loaded_speakervim = 1

let g:speakervim#say_commands = get(g:, 'g:speakervim#say_commands',
            \ {
            \ 'unix': {
            \   'en': {'cmd': 'espeak -g5 -k10 "{{text}}"', 'kill': 'pkill espeak'},
            \   'ja': {'cmd': 'jsay "{{text}}"',   'kill': 'pkill vlc'}
            \ },
            \ 'mac': {
            \   'ja': {'cmd': 'say -v Kyoko -r 512 "{{text}}"', 'kill': 'pkill say'},
            \   'en': {'cmd': 'say -v Alex -r 300 "{{text}}"', 'kill': 'pkill say'}
            \ }
            \ })

let g:speakervim#lang = 'en'

call operator#user#define('speaker', 'speaker#operator')

command! -nargs=1 -complete=customlist,speaker#list_languages SpeakerVimSetLang :call speaker#set_lang(<f-args>)
command! SpeakerVimKillProcess :call speaker#killall()
