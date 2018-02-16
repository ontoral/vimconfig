" Take me to your leader...
let mapleader = ","

" Edit this file
nnoremap <leader>ev :split ~/.gvimrc<cr>
nnoremap <leader>sv :source ~/.gvimrc<cr>

" Window properties and fonts
set lines=40
set columns=132
set guifont=M+\ 1m\ Regular:h18
set colorcolumn=78
colorscheme slate

" Spacing and rulers
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Syntax, colors, and fonts
set bg=dark
syntax on

" Window embellishments
set modeline
set ls=2
set ruler
set number
set colorcolumn=78

" Editor behavior
set hidden
set showmatch
set showmode
set backspace=indent,eol,start
set wildmode=longest,list,full
set wildmenu

" Movement
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-N> gT
map <C-M> gt

" Pathogen
execute pathogen#infect()

" NERDTree
autocmd vimenter * NERDTree
let NERDTreeIgnore = ['\~$', '\.pyc[[file]]', '\.o$']
let NERDTreeWinSize = 20
let NERDTreeDirArrows = 0

" C++ includes
iabbrev #a #include <algorithm>
iabbrev #d #include <deque>
iabbrev #i #include <iostream>
iabbrev #l #include <limits>
iabbrev #n #include <numeric>
iabbrev #q #include <queue>
iabbrev #r #include <random>
iabbrev #u #include <utility>
iabbrev #m #include <unordered_map>
iabbrev #v #include <vector>
iabbrev iuns using namespace std;
iabbrev imain int main(int /*argc*/, char */*argv*/[]) {<cr>    return 0;<cr>}

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
ca shell Shell

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction
