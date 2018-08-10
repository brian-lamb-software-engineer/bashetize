" .vimrc
syntax on

"for centos5 systems might need the following to correct delete and backspace key usage
"set term=builtin_xterm

" https://github.com/tpope/vim-pathogen a vim package manager
execute pathogen#infect()
filetype plugin indent on                   " for pathogen

" in vim, use :colorscheme   then tab key to see all available. Some good ones, solarized, antares, desert-256, c64, ibm,  many more. 
" uncomment your favourite colorscheme here. (note that the color comments are for a .vimrc file, but for e.g. php/javascript files the colors will be slightly different, so you just have to load them to test them)
"colorscheme badwolf	       " awesome colorscheme for most developer, has some reds in it
"colorscheme C64		        " c64 colors (blues)
"colorscheme basic		      " dark bg with blues
"colorscheme ibmedit		    " old ibm color, bright blue
"colorscheme 1989		        " plum colors
"colorscheme lizard256      " low contrast olive greens
"colorscheme Chasing_Logic  " low contrast, aquamarine line highlighting, some brick reds
"colorscheme Dev_Delight    " highlights comment lines nice grey, aqua and magenta texts, dark bg
"colorscheme PaperColor     " when badwolf is enabled with this one, it has a nice contrast, darker bg, lime and aqua text, with some blues
"colorscheme alduin         " low contrast, khaki colors
colorscheme antares        " nice low contrast with aqua, purples, some brick reds, med greys, darker bg
" many many more, you will just have to type in :colorschemes then press the tab key to see them all. 

set tabstop=2
set softtabstop=4		                        " spaces in tab when editing
set expandtab			                          " tabs are spaces
set wrap
set linebreak
set nolist          		                    " list disables linebreak

set number			                            " show line numbers
set showcmd			                            " show command in bottom bar
set cursorline			                        " highlight current line

filetype indent on		                      " load filetype-specific indent files
set wildmenu			                          " visual autocompletet for command menu
set lazyredraw			                        " redraw only when we need to
set showmatch			                          " highlight matching paren

set incsearch			                          " set as chars are typed
set hlsearch			                          " highlight matches

nnoremap <leader><space> :nohlsearch<CR>    " turn off search highlight

set foldenable				                      " enable folding
set foldlevelstart=10			                  " open most folds by default
set foldnestmax=10			                    " 10 nested max

nnoremap <space> za			                    " space open/closes folds
set foldmethod=indent			                  " fold based in indent level

nnoremap <leader>s :mksession<CR>	          " automatically close with a session instead.  Then reopen vim with vim -S to leverage this

nnoremap <leader>a :Ag	" open ag.vim silver searcher, commmand line tool, searches source code in a project, this adds to vim without leaving (here mapped to ,a)

"set noeb vb t_vb=
"set shiftwidth=4

