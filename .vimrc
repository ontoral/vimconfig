" Take me to your leader...
" This defines a hotkey for creating mappings.
" Instead of using it like Copy (Ctrl+x), it is used sequentially, so
" a mapping <leader>ev is three consecutive keystrokes ,-e-v
let mapleader = ","

" Edit this file
" When inspiration occurs, it's nice to be able to quickly edit my .vimrc
" file.
"    ",ev"   quickly open .vimrc in a split
"    ",sv"   reload .vimrc, once it has been edited and saved
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Spacing and rulers
" Let's deal with tabs and spaces... I prefer indents of four spaces over
" using tab characters. This makes it happen.
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Syntax highlighting, colors, and fonts
set bg=dark
syntax on

" Window embellishments
" Handle things like rulers, line numbering, and the modeline below.
set modeline
set ls=2
set ruler
set number
set colorcolumn=78

" Editor behavior
" Tweak buffer, backspace, tab-completion, and screen update behaviors.
set hidden
set showmatch
set showmode
set backspace=indent,eol,start
set wildmode=longest,list,full
set wildmenu
set updatetime=100

" Movement between windows
" It's easy enough to hit Ctrl+w,h, but Ctrl+h is easier!
" Map the standard cursor movements h,j,k,l to window movements by holding
" down Ctrl... Ctrl+h,Ctrl+j,Ctrl+k,Ctrl+l.
" Put tab movements left and right on Ctrl+n and Ctrl+m.
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-N> gT
nnoremap <C-M> gt

" Control-keys while editing
" Insert from beginning of line
inoremap <C-A> <esc>I  
" Append at end of line
inoremap <C-E> <esc>A
" Delete current line and continue editing
inoremap <C-K> <esc>ddi
" Capitalize current word and continue editing
inoremap <C-U> <esc>bveUea

" Pathogen... a Package Manager
execute pathogen#infect()

" NERDTree... a file/directory browser inside vim
autocmd vimenter * NERDTree
let NERDTreeIgnore = ['\~$', '\.pyc[[file]]', '\.o$']
let NERDTreeWinSize = 20
let NERDTreeDirArrows = 0
nnoremap <leader>, :NERDTreeToggle<cr>

" TODO make these only active in .cpp, .h, and .hpp files
" C++ includes and snippets
" Typing these while inputting C++ will speed things up.
iabbrev #" #include "_"
iabbrev #a #include <algorithm>
iabbrev #d #include <deque>
iabbrev #f #include <fstream>
iabbrev #i #include <iostream>
iabbrev #g #include "getopt.h"
iabbrev #l #include <limits>
iabbrev #n #include <numeric>
iabbrev #p #include <priority_queue>
iabbrev #q #include <queue>
iabbrev #r #include <random>
iabbrev #s #include <string>
iabbrev #t #include <tuple>
iabbrev #u #include <utility>
iabbrev #m #include <unordered_map>
iabbrev #v #include <vector>
iabbrev istd using namespace std;
iabbrev imain int main(int /*argc*/, char */*argv*/[]) {<cr>return 0;<cr>}

" Using 'make' and automated building
" Add some mappings to simplify Makefile usage
"   ",k"   The basics, just follow with <enter> for 'make'. If a specific
"          target is needed, add it then <enter> for 'make debug', etc.
"   ",mt"  "Make This" suggests a target based on the current file... while
"          editing myTest.cpp, we'll try 'make myTest'.
"   ",mc"  Simply 'make clean'
" Add a custom build mapping
"   ",b"   Calls Build(), a function that does nothing but print a message
"          about how to override it. Redefine Build(), when it suits, to
"          add a quick mapping, with no trailing <enter> required.
nnoremap <leader>k :!make 
nnoremap <leader>mt :!make %:t:r
nnoremap <leader>mc :!make clean<cr>
function! Build()
  echom "Override default build with 'function! Build()'"
endfunction
nnoremap <leader>b :call Build()<cr>

" For git
autocmd Filetype gitcommit setlocal spell textwidth=72

" Executing shell commands
" You can already use :!<command> to send commands to the shell.
" These two "Functions I Found on the Internet" dump the results of the
" shell commands into a buffer, so the content can be yanked and pasted into
" something currently being edited. They both work almost identically, though
" their code look almost completely unrelated... go figure! Taking no credit
" for these, I found them, I copied them, they work... that's all I know!
"   "shell <command>" is the same as "Shell <command>", they both call
"      RunShellCommand, dumping output into a buffer after a confirm <enter>
"      with some meta info.
"   "Shell1 <command>" calls ExecuteInShell, dumping output into a larger
"      split buffer, with no meta info, and no confirm
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
"  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell1 call s:ExecuteInShell(<q-args>)
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
