" Edit this file
" When inspiration occurs, it's nice to be able to quickly edit my .gvimrc
" file.
"    ",egv"   quickly open .gvimrc in a split
"    ",sgv"   reload .gvimrc, once it has been edited and saved
nnoremap <leader>egv :split $MYGVIMRC<cr>
nnoremap <leader>sgv :source $MYGVIMRC<cr>

" Window properties and fonts
set lines=40
set columns=132
set guifont=M+\ 1m\ Regular:h18
set colorcolumn=78
colorscheme slate
