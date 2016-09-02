# speaker-vim
the plugin to speak the text you visual-selected

# usage
- configuration sample
~~~
map <space>s <Plug>(operator-speaker)
map <space>k :SpeakerVimKillProcess<CR>
augroup speaker-autocmds
  autocmd!
  autocmd BufRead * call speaker#say(expand(@%))
augroup END
~~~
