#!/usr/bin/env bash
ln -s ~/.vim/.vimrc ~/.vimrc
pushd ~/.vim
git submodule update --init ~/.vim/bundle/nerdtree
git submodule update --init ~/.vim/bundle/vim-fugitive
popd
