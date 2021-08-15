if exists('g:loaded_plink') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! PlinkCopy lua require'plink'.copy()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_plink = 1
