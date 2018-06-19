" .vimrc
syntax on

" in vim, use :colorscheme   then tab key to see all available. Some good ones, solarized, antares, desert-256, c64, ibm,  many more. 
colorscheme badwolf		" awesome colorscheme

set tabstop=2
set softtabstop=4		" spaces in tab when editing
set expandtab			" tabs are spaces
set wrap
set linebreak
set nolist          		" list disables linebreak

set number			" show line numbers
set showcmd			" show command in bottom bar
set cursorline			" highlight current line

filetype indent on		" load filetype-specific indent files
set wildmenu			" visual autocompletet for command menu
set lazyredraw			" redraw only when we need to
set showmatch			" highlight matching paren

set incsearch			" set as chars are typed
set hlsearch			" highlight matches

"turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

set foldenable				" enable folding
set foldlevelstart=10			" open most folds by default
set foldnestmax=10			" 10 nested max

nnoremap <space> za			" space open/closes folds
set foldmethod=indent			"fold based in indent level

nnoremap <leader>s :mksession<CR>	"automatically close with a session instead.  Then reopen vim with vim -S to leverage this

nnoremap <leader>a :Ag	" open ag.vim   "silver searcher, commmand line tool, searches source code in a project, this adds to vim without leaving (here mapped to ,a)

"set noeb vb t_vb=
"set shiftwidth=4

