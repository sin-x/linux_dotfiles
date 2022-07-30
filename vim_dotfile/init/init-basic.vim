set nocompatible
filetype off
if has('gui_running')
	set background=dark
	colors desert
else
	colors desert
endif

syntax on
filetype plugin indent on

set ff=unix
set nu
set ts=4 sw=4 tw=78 noet
set hlsearch
set showmatch
set showcmd
set nobackup
set noswapfile
set noundofile
set cursorline
set laststatus=2
set autochdir
"set noerrorbells
"set novisualbell
set colorcolumn=80
hi ColorColumn guifg=#11f0c3 guibg=#ff0000
set foldmethod=indent
set foldlevel=99
set guifont=Monospace\ 12
set wildmenu

let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/path/to/share/gtags/gtags.conf'

"Turn on syntax highlighting
syntax on
"Enable filetype detection
filetype plugin indent on

" 设置 tags：当前文件所在目录往上向根目录搜索直到碰到 .tags 文件
" 或者 Vim 当前目录包含 .tags 文件
set tags=./.tags;,.tags

noremap <F1> : NERDTreeToggle <cr>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

xnoremap <C-h> <Left>
xnoremap <C-j> <Down>
xnoremap <C-k> <Up>
xnoremap <C-l> <Right>
