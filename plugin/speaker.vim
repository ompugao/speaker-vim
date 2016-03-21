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
            \   'ja': {'cmd': 'jsay "{{text}}"',   'kill': 'pkill cvlc'}
            \ },
            \ })

let g:speakervim#lang = 'en'

call operator#user#define('speaker', 'speaker#operator')

