" ==============================
"
" init.vim - initialize config
" Last Modified: 2022/07/07
"
" ==============================

" 防止重复加载
if get(s:, 'loaded', 0) != 0
	finish
else
	let s:loaded = 1
endif
" 
" " 取得本文件所在的目录
" let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" 
" " 将 vim-init 目录加入 runtimepath
" exec 'set rtp+='.s:home
" 
" " 将 ~/.vim 目录加入 runtimepath (有时候 vim 不会自动帮你加入)
" set rtp+=~/.vim
" 
" " 插件加载
" source init-plugins.vim

let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set rtp+='.s:home

" let s:init_home = s:home += '/init/'

" for file in split(glob(join([s:home, '/init/']), '*.vim'), '\n')
" 	exec 'so' file
" 	echo file
" endfor
" exec 'so' resolve(expand(join([s:home, 'init/init_plugins.vim'], '/') ))
" so '~/Project/dotfiles/vim_dotfile/init/init_plugins.vim'
source ~/Project/dotfiles/vim_dotfile/init/init-plugins.vim

