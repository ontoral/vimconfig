#!/usr/bin/env bash
ln -s ~/.vim/.vimrc ~/.vimrc
cd ~/.vim
git submodule update --init ~/.vim/bundle/nerdtree
git submodule update --init ~/.vim/bundle/vim-fugitive
