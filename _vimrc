set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup
set history=250
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch	" do incremental searching

set number
set hlsearch

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

func Scratch()
"    :set nomodifiable
"    :set nomodified
    :set buftype=nofile
    :set bufhidden=hide
    :setlocal noswapfile
    :map <buffer><silent> <F1> <esc><esc>
    :map <buffer><silent> <F3> <esc><esc>
    :map <buffer><silent> <esc><esc> :set nomodified<cr>:bwipeout!<cr>
endfunc

func ViMan()
    let c=expand('<cword>')
    :call system("man 3 ".c." | col -b > /tmp/viman") 
    :call system("[ -s /tmp/viman ] || man ".c." | col -b > /tmp/viman") 
    :new
    :read  /tmp/viman
    :set ft=man
    :call Scratch()
endfunc
"map <M-right> :tabnext<cr>
"map <M-left> :tabprevious<cr>
"map <C-t> :tabnew<cr>
map <silent><F1> :call ViMan()<cr>

func ViTag()
    let c=expand('%')
    :call system("grep ".c." tags > /tmp/vitag") 
    :rightbelow 40vnew
    :read /tmp/vitag
    :call Scratch()
endfunc
map <silent><F3> :call ViTag()<cr>

map <F2> :w<cr>
map <F9> :!gmake<cr>
map <C-g> :call findfunc<cr>
map <F5> @a
map <F10> :NERDTreeClose<cr>:wq<cr>
imap <silent><F1> <esc><F1>
imap <F2> <esc><F2>
imap <F9> <esc><F9>
imap <C-g> <esc><C-g>
" map <F1> :!man <cword><cr>
"man TAILQ_FOREACH | col -b | vim -c 'set ft=man' -c 'set nomod' -

"source ~/.vim/vimrc
"colorscheme vibrantink
"colorscheme desert
colorscheme cfox


autocmd BufReadPost * loadview
autocmd BufWritePost * mkview
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

nmap <silent> <Leader>] :tabnext<cr>
nmap <silent> <Leader>[ :tabprevious<cr>
nmap <silent> <Leader>= :tabnew<cr>
nmap <silent> <Leader>p :NERDTreeToggle<cr>
set textwidth=100
set cc=80

" по ctrl-f12 билдим тэги (ctags) для текущей директории
map <silent> <F8> :!echo "building ctags database for current dir (`pwd`)"; exctags -r .<CR>
set nocp
filetype plugin on 


set nocompatible
filetype off 

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
filetype plugin indent on
Bundle 'elzr/vim-json'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Bundle 'kien/ctrlp.vim.git'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-erlang/vim-erlang-tags'
Bundle 'vim-erlang/vim-erlang-omnicomplete'
"Bundle 'vim-erlang/vim-erlang-runtime'
Bundle 'vim-erlang/vim-erlang-compiler'
Plugin 'alvan/vim-closetag'
Plugin 'othree/html5.vim'
Bundle 'airblade/vim-gitgutter'

"set lcs=tab:>-,eol:<,trail:-,nbsp:%
set lcs=tab:·\ ,eol:¶,nbsp:%
set list

set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set pastetoggle=<F4>

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the statusline to green when entering Vim
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15


function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction
if has('statusline')
  set statusline=%#Question#                   " set highlighting
  set statusline+=%-2.2n\                      " buffer number
  set statusline+=%#WarningMsg#                " set highlighting
  set statusline+=%f\                          " file name
  set statusline+=%#Question#                  " set highlighting
  set statusline+=%h%m%r%w\                    " flags
  set statusline+=%{strlen(&ft)?&ft:'none'},   " file type
  set statusline+=%{(&fenc==\"\"?&enc:&fenc)}, " encoding
  set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
  set statusline+=%{&fileformat},              " file format
  set statusline+=%{&spelllang},               " language of spelling checker
  set statusline+=%{SyntaxItem()}              " syntax highlight group under cursor
  set statusline+=%#StatusLineNC#                  " set highlighting
  set statusline+=%=                           " ident to the right
  set statusline+=0x%-8B\                      " character code under cursor
  set statusline+=%-7.(%l,%c%V%)\ %<%P         " cursor position/offset
endif

set laststatus=2

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
highlight notice term=bold,underline
match notice /io\:format/


