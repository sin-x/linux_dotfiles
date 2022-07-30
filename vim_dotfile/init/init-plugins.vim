"---------------------------------------------
" 默认情况下的分组，可以在前面覆盖
"---------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group  = ['basic', 'tags', 'enhanced', 'filetypes', 'textobj']
	let g:bundle_group += ['airline', 'nerdtree', 'ale', 'echodoc']
	let g:bundle_group += ['leaderf']
	let g:bundle_group += ['fzf']
	let g:bundle_group += ['coc']
endif

"---------------------------------------------
" 计算当前 vim-init 的子路径
"---------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path)
	return substitute(path, '\\', '/', g)
endfunction



"---------------------------------------------
" 在 ~/.vim/plugged 下安装插件
"---------------------------------------------
call plug#begin(get(g:, 'plug_home', '~/.vim/plugged'))

"---------------------------------------------
" 默认插件
"---------------------------------------------

	" 全文快速移动，<leader><leader>f{char} 即可触发
	Plug 'easymotion/vim-easymotion'

	" 文件浏览器，代替 netrw
	Plug 'justinmk/vim-dirvish'

	" Plug 'ervandew/supertab'

    Plug 'Yggdroot/indentLine'
    Plug 'preservim/nerdtree'
    Plug 'nachumk/systemverilog.vim'

"---------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"---------------------------------------------
if index(g:bundle_group, 'tags') >= 0
	" 设置 tags: 当前文件所在目录往上向根目录搜索直到碰到 .tags 文件
	" 或者 Vim 当前目录包括 .tags 文件
	set tags=./tags;,.tags

	" 提供 ctags/gtags 后台数据库自动更新功能
	Plug 'ludovicchabant/vim-gutentags'

	" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
	" 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
	Plug 'skywind3000/gutentags_plus'

	" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
	let g:gutentags_project_root = ['.root']
	let g:gutentags_ctags_tagfile = '.tags'

	" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
	let g:gutentags_cache_dir = expand('~/.cache/tags')

	" 默认禁用自动生成
	let g:gutentags_modules = [] 

	" 如果有 ctags 可执行就允许动态生成 ctags 文件
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif

	" 如果有 gtags 可执行就允许动态生成 gtags 数据库
	" if executable('gtags') && executable('gtags-cscope')
	" 	let g:gutentags_modules += ['gtags_cscope']
	" endif

	" 设置 ctags 的参数
	let g:gutentags_ctags_extra_args = []
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--systemverilog-kinds=+px']

	" 使用 universal-ctags 的话需要下面这行，请反注释
	let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁止 gutentags 自动链接 gtags 数据库
	let g:gutentags_auto_add_gtags_cscope = 0
endif

if  index(g:bundle_group, 'leaderf') >= 0
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
		" ============== Leaderf ===============
		" don't show the help in normal mode
		let g:Lf_HideHelp = 1
		let g:Lf_UseCache = 0
		let g:Lf_UseVersionControlTool = 0
		let g:Lf_IgnoreCurrentBufferName = 1
		" popup mode
		let g:Lf_WindowPosition = 'popup'
		let g:Lf_PreviewInPopup = 1
		let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
		let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
		let g:Lf_WorkingDirectoryMode = 'Ac'
		let g:Lf_ShowDevIcons = 0
		let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		
		let g:Lf_ShortcutF = "<leader>ff"
		noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
		noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
		noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
		noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
		noremap <leader>fr :<C-U><C-R>=printf("Leaderf rg %s", "")<CR><CR>
		
		noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
		noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>

		noremap <F2> :<C-U><C-R>=printf("Leaderf! rg -e '\\b%s\\b'", expand("<cword>"))<CR><CR>
		" search visually selected text literally
		xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
		noremap go :<C-U>Leaderf! rg --recall<CR>
		
		" should use `Leaderf gtags --update` first
		let g:Lf_GtagsAutoGenerate = 1
		let g:Lf_Gtagslabel = 'native-pygments'
		" noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
		noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
		noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
		noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
		noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
		
		let g:Lf_CtagsFuncOpts = {
			\'systemverilog' : '--systemverilog-kinds=f',
			\}
	else
		" 不支持 python ，使用 CtrlP 代替
		Plug 'ctrlpvim/ctrlp.vim'

		" 显示函数列表的扩展插件
		Plug 'tacahiroy/ctrlp-funky'

		" 忽略默认键位
		let g:ctrlp_map = ''

		" 模糊匹配忽略
		let g:ctrlp_custom_ignore = {
		  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
		  \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
		  \ 'link': 'some_bad_symbolic_links',
		  \ }

		" 项目标志
		let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		let g:ctrlp_working_path = 0

		" CTRL+p 打开文件模糊匹配
		noremap <c-p> :CtrlP<cr>

		" CTRL+n 打开最近访问过的文件的匹配
		noremap <c-n> :CtrlPMRUFiles<cr>

		" ALT+p 显示当前文件的函数列表
		noremap <m-p> :CtrlPFunky<cr>

		" ALT+n 匹配 buffer
		noremap <m-n> :CtrlPBuffer<cr>
	endif
endif

if index(g:bundle_group, 'coc') >= 0
	Plug 'honza/vim-snippets'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
	highlight CocErrorFloat   guifg=#11f0c3
	highlight CocWarningFloat guifg=#11f0c3
	" unicode characters in the file autoload/float.vim
	set encoding=utf-8
	
	" TextEdit might fail if hidden is not set.
	set hidden
	
	" Some servers have issues with backup files, see #649.
	set nobackup
	set nowritebackup
	
	" Give more space for displaying messages.
	set cmdheight=2
	
	" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
	" delays and poor user experience.
	set updatetime=300
	
	" Don't pass messages to |ins-completion-menu|.
	set shortmess+=c
	
	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved.
	if has("nvim-0.5.0") || has("patch-8.1.1564")
	  " Recently vim can merge signcolumn and number column into one
	  set signcolumn=number
	else
	  set signcolumn=yes
	endif
	
	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	" inoremap <silent><expr> <TAB>
	"       \ pumvisible() ? "\<C-n>" :
	"       \ CheckBackspace() ? "\<TAB>" :
	"       \ coc#refresh()
	" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	" 
	" function! CheckBackspace() abort
	"   let col = col('.') - 1
	"   return !col || getline('.')[col - 1]  =~# '\s'
	" endfunction
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()
	
	" Use <c-space> to trigger completion.
	if has('nvim')
	  inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif
	
	" Make <CR> auto-select the first completion item and notify coc.nvim to
	" format on enter, <cr> could be remapped by other vim plugin
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
	                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
	
	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)
	
	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	
	" Use K to show documentation in preview window.
	nnoremap <silent> K :call ShowDocumentation()<CR>
	
	function! ShowDocumentation()
	  if CocAction('hasProvider', 'hover')
	    call CocActionAsync('doHover')
	  else
	    call feedkeys('K', 'in')
	  endif
	endfunction
	
	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')
	
	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)
	
	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)
	
	augroup mygroup
	  autocmd!
	  " Setup formatexpr specified filetype(s).
	  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	  " Update signature help on jump placeholder.
	  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end
	
	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)
	
	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)
	
	" Run the Code Lens action on the current line.
	nmap <leader>cl  <Plug>(coc-codelens-action)
	
	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)
	
	" Remap <C-f> and <C-b> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
	  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif
	
	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of language server.
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)
	
	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocActionAsync('format')
	
	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)
	
	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
	
	" Add (Neo)Vim's native statusline support.
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline.
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
	
	" Mappings for CoCList
	" Show all diagnostics.
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols.
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
	
	command! SvBuildIndex call CocRequest("svlangserver", 'workspace/executeCommand', {'command': 'systemverilog.build_index'})
	command! -range SvReportHierarchy call CocRequest("svlangserver", 'workspace/executeCommand', {'command': 'systemverilog.report_hierarchy', 'arguments': [input('Module/interface: ', <range> == 0 ? "" : expand("<cword>"))]})
	
	" Use <C-l> for trigger snippet expand.
	" imap <C-l> <Plug>(coc-snippets-expand)
	
	" Use <C-j> for select text for visual placeholder of snippet.
	vmap <C-j> <Plug>(coc-snippets-select)
	
	" Use <C-j> for jump to next placeholder, it's default of coc.nvim
	let g:coc_snippet_next = '<c-j>'

	let g:coc_snippet_next = '<tab>'
	
	" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
	let g:coc_snippet_prev = '<c-k>'
	
	" Use <C-j> for both expand and jump (make expand higher priority.)
	imap <C-j> <Plug>(coc-snippets-expand-jump)
	
	" Use <leader>x for convert visual selected code to snippet
	xmap <leader>x  <Plug>(coc-convert-snippet)
	
	inoremap <silent><expr> <TAB>
	      \ pumvisible() ? coc#_select_confirm() :
	      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	      \ <SID>check_back_space() ? "\<TAB>" :
	      \ coc#refresh()
	
	function! s:check_back_space() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	let g:coc_snippet_next = '<tab>'

endif

if index(g:bundle_group, 'fzf') >= 0
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
endif
	
call plug#end()
