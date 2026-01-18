set nu
syntax on
colo ron

set showmatch " show matching brackets
set ruler " always show location of file

set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set autoindent

set backspace=indent,eol,start

set hlsearch
set laststatus=2

au BufReadPost *.wfc set syntax=tcl
au BufReadPost *.pjx set syntax=python

" Find and remove trailing whitespace
:match Search /\s\+$/   " highlight trailing whitespace
" F5 Removes trailing whitespace
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Now to remove trailing whitespace when saving source files
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
"autocmd FileType c,cpp,java,php,python,yaml autocmd BufWritePre <buffer> %s/\s\+$//e
