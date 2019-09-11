" .vimrc
"-----------------Load Plugins------------------"
" https://github.com/tpope/vim-pathogen a vim package manager, that simply
"  categorizes plugins through the ~/.vim/bundle dir, instead of 
"  confusingly cluttered in the root dir
" see plugins in the bundle dir.
"  -puppet file sytax highlighting
execute pathogen#infect()


"-----------------User-Config------------------"
syntax on
filetype plugin indent on                   
set backspace=indent,eol,start 											"Make backslash behave
let mapleader = ','																	"Default leader is \
set laststatus=2
"for centos5 systems might need the following to correct delete and backspace key usage
"set term=builtin_xterm
" set tabs 2 spaces
" number of space characters inserted when tab key is pressed
"set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tabstop=2
set softtabstop=2		                        " spaces in tab when editing
" set use spaces instead of tabs
set expandtab			                          " tabs are spaces
" number of space characters inserted for indentation
set shiftwidth=2
set wrap
set linebreak
set nolist          		                    " list disables linebreak
set number			                            " show line numbers
set showcmd			                            " show command in bottom bar
set cursorline			                        " highlight current line
set foldenable				                      " enable folding
set foldmethod=indent			                  " fold based in indent level
set foldlevelstart=10			                  " open most folds by default
set foldnestmax=10			                    " 10 nested max
"set noeb vb t_vb=
set nocompatible              								"Want latest vim settings
set pastetoggle=<Leader>p
"Switch buffer even with unsaved changes
set hidden
set complete=.,w,b,u                                "Current buffer, open windows, loaded buffs, unloaded buffs
set autowriteall "Write file on buffer Switch
filetype indent on		                      " load filetype-specific indent files


"------------------Visuals-------------------"
" in vim, use :colorscheme   then tab key to see all available. Some good ones, solarized, antares, desert-256, c64, ibm,  many more. 
" uncomment your favourite colorscheme here. (note that the color comments are for a .vimrc file, but for e.g. php/javascript files the colors will be slightly different, so you just have to load them to test them)
"colorscheme default
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
"colorscheme solarized
colorscheme antares        " nice low contrast with aqua, purples, some brick reds, med greys, darker bg
" many many more, you will just have to type in :colorschemes then press the tab key to see them all. 

"set guifont=
set t_CO=256																	  "Force 256 colors terminal
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

"set macligatures                                " Pretty when available
"set guioptions-=e                               "We dont want gui tabs

set guioptions-=l                                "Remove scrollbars
set guioptions-=L                                "Remove splits scrollbars
set guioptions-=r
set guioptions-=R

set bg=light
"set bg=dark
"fake a custom left padding for each window
"hi LineNr ctermbg=$bg                            "Color behind numbers
"set foldcolumn=2
"hi foldcolumn ctermbg=bg
"hi vertsplit ctermfg=bg ctermbg=bg

set wildmenu			                          " visual autocompletet for command menu
set lazyredraw			                        " redraw only when we need to
set showmatch			                          " highlight matching paren

"---- vim lightline plugin --------------------"
"https://github.com/itchyny/lightline.vim
"wombat
"jellybeans
"one
"landscape
"solarized dark
let g:lightline = {
      \ 'colorscheme': 'landscape',
            \ }



"------------------Split Management-------------------"
set splitbelow															"Default split will be below
set splitright															"Default split will be right

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>



"------------------Searching-------------------"
set hls
set incsearch		" do incremental searching
set ic
set hlsearch			                          " highlight matches
"set linespace=15 																	"macvim only



"------------------Mappings-------------------"

" default leader key in vim is backslash
" Make it easy to edit the Vimrc file
nmap <Leader>ev :tabedit $MYVIMRC<cr>
" Make it easy to edit the Plugins file
nmap <Leader>ep :e ~/.vim/plugins.vim<cr>
" Edit snippets file
nmap <Leader>es :e ~/.vim/snippets/
" Add simple highlight removal
nmap <Leader><space> :nohlsearch<cr>
" Make NERDTree easier to toggle
nmap <Leader>1 :NERDTreeToggle<cr>
" Switch between files easier
nmap <Leader>6 <c-^>
" Search tags (functions)
nmap <c-e> :CtrlPBufTag<cr>
" Show most recently used files (alt p)
nmap <Leader>sp :CtrlPMRUFiles<cr>
" Search a tag
nmap <Leader>f :tag<space>
" Lists buffers and types :b for you in advance
nnoremap gb :ls<cr>:b<space>
nmap <Leader>cl iconsole.log()
" bl edits
nnoremap <space> za			                    " space open/closes folds
nnoremap <leader><space> :nohlsearch<CR>    " turn off search highlight
nnoremap <leader>s :mksession<CR>	          " automatically close with a session instead.  Then reopen vim with vim -S to leverage this
nnoremap <leader>a :Ag	" open ag.vim silver searcher, commmand line tool, searches source code in a project, this adds to vim without leaving (here mapped to ,a)



"------------------Restore Last Position-------------------"

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END



"------------------Plugin Settings-------------------"
"/
"/ NERDTree
"/
let g:NERDTreeHijackNetrw=0

"/
"/ CtrlP
"/

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  "set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast
	let g:ctrlp_user_command = 'ag %s -l --nocolor
      \ --ignore node_modules 
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --skip-vcs-ignores
      \ -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif

let g:ctrlp_match_window = 'top,order:tbb,min:1,max:30,results:30'
"let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_working_path_mode = 'raw'

"/
"/ Ag
"/
let g:ag_working_path_mode="r"
let g:ag_prg="ag 
      \ --ignore node_modules 
      \ --ignore 2016_03_25
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore storage
      \ --skip-vcs-ignores
      \ -p .agignore
      \ --vimgrep"

"/
"/ Greplace.vim
"/
set grepprg=ag                                        "Use Ag for search
let g:grep_cmd_opts = '--line-numbers --noheading'

"/
"/ arnaud-lb/vim-php-namespace
"/

function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction

autocmd FileType php inoremap <Leader>n <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>n :call PhpInsertUse()<CR>

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction

autocmd FileType php inoremap <Leader>nf <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>nf :call PhpExpandClass()<CR>

" Sort exiting use statements
autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>
" Sort PHP use statements
"http://stackoverflow.com/questions/11531073/how-do-you-sort-a-range-of-lines-by-length
vmap <Leader>su ! awk '{ print length(), $0 \| "sort -n \| cut -d\\  -f2-" }'<cr>

"/
"/ vim-php-cs-fixer.vim
"/
" make the path work
let g:php_cs_fixer_path = "~/.composer/vendor/bin/php-cs-fixer"
" Set level to psr2. 
let g:php_cs_fixer_level = "psr2"
" disable PSR-0.
let g:php_cs_fixer_fixers_list = "-psr0"
" don't add ley mappings.
let g:php_cs_fixer_enable_default_mapping = 0
"nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
nnoremap <silent><leader>pf :call PhpCsFixerFixFile()<CR>
"nmap <leader>pf :!php-cs-fixer fix "%" --level=psr2
let g:php_cs_fixer_level = "psr2"              " which level ?
let g:php_cs_fixer_config = "default"             " configuration
"let g:php_cs_fixer_config_file = '.php_cs'       " configuration file
let g:php_cs_fixer_php_path = "php"               " Path to PHP
" If you want to define specific fixers:
"let g:php_cs_fixer_fixers_list = "linefeed,short_tag,indentation"
let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.

"/
"/ PHP Documentor for VIM (pdv)
"/
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <Leader>d :call pdv#DocumentWithSnip()<CR>

"/
"/ Ultisnips
"/
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"/
"/ Vim blade
"/
autocmd BufNewFile,BufRead *.blade.php set ft=html | set ft=phtml | set ft=blade " Fix blade auto-indent

"/
"/ Taglist
"/
let Tlist_Use_Right_Window=1
let Tlist_Inc_Winwidth=0



"------------------Auto-Commands-------------------"
nmap <Leader>lr :e app/Http/routes.php<cr>
nmap <Leader>lm :!php artisan make:
nmap <Leader><Leader>c :CtrlP<cr>app/Http/Controllers/
nmap <Leader><Leader>m :CtrlP<cr>app/
nmap <Leader><Leader>v :CtrlP<cr>resources/views/
nmap <Leader>rc :e web/js/rcrit.js<cr>
nmap <Leader>ra :e web/js/rafter.js<cr>
nmap <Leader>pl :! php -l %<cr>
let @d="Adebug();hi''il"



"------------------Auto-Commands-------------------"
"Automatically source the Vimrc file on save.
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END
"Automatically create directory on save
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
" for vim-instant-markdown node plugin
" npm -g install instant-markdown-d
" Fix markdown for plugin
"augroup autofixmd
"autocmd!
"	autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
"augroup END
let g:instant_markdown_autostart = 0
" let g:instant_markdown_slow = 1
"	then you have to :InstantMarkdownPreview
" json syntax
"augroup autojsonsyntax
"	autocmd!
"	autocmd BufNewFile,BufRead *.json set ft=javascript
"augroup END
"source $VIMRUNTIME/vimrc_example.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" /Applications/MacVim.app/Contents/Resources/vim/runtime/vimrc_example.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
"set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
" commented 10/20/16
"if has('mouse')
"  set mouse=a
"endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  "filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"End snip from example vimrc file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" no tilde files
"set nobackup
"set nowritebackup
" set backup file folder
set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.
set undodir=~/.vim/tmp,.
"set undodir=./.backup,.,/tmp
"set backupdir=./.backup,.,/tmp
"set directory=.,./.backup,/tmp
" project specific .vimrc 
set exrc
" disable unsafe project specific .vimrc
set secure
" vim-airline - airline theme
"g:airline_theme='simple'
"g:airline_theme='simple'



" 
"------------------Notes-and-Tips-------------------"
" - Help Documentation
" - ctrlp https://github.com/kien/ctrlp.vim/blob/master/doc/ctrlp.txt
" - vim :help key-notation  Show how to map special keys
"
" - Tags
" - Press ',f' or ':tag <tagname>' to search for tag
" - Press ':tn' ':tp' next/prev ':ts' ts[elect] to list tags
"
" - Deleting/Changing
" - press 'di(' to delete inside parens
" - press 'di"' to delete inside quotes (works for singlequotes)
" - press 'ci"' to delete inside quotes, and go to insert mode
" - press 'vi[' to select inside brackets!
" - press 'va[' to select inside brackets And brackets themselves!
"
" - Jumping around
" - Press 'zz' to instantly center the line where the cursor is located
" - press '<ctrl-]>' with cursor on function to go to the function definition!
" - press '<ctrl-^>' go to previous edit location...
" - press '<ctrl-w>o' to make current buffer full screen
" - press '<ctrl-o>' to go to last edit point '<ctrl-i>' is the opposite,forward
"
" - Marks
" - press 'm' then any capitol letter to create mark
" - press '`' then that letter, to return to the mark
" - can return with singlequote too, but not exact column position
" - can lowercase letter too, but only in same buffer (good for delete or copy)
"
" - Buffers
" - type gb in command mode, it lists my open buffers and types :b , ready for me to start typing a buffer nam"
" - type ':b <filename-part>' with tab-key providing auto-completion (awesome !!)
" - type 'bufdo bd!' close every buffer
" - type 'sbuffer #' to open in a different buffer
" - type ':split abc' or ':vsplit abc' open in a split
" - ctrl-w_ - maximize current window pane
" - ctrl-w= - make all equal size" pane
"
" - Sessions
" - Save Session with ':mksession! ~/today.ses'
" - Load Session with 'vim -S ~/today.ses'
"
" - Searching
"   :grep -R 'John Doe' .  THEN ':copen' shows quickfix windwo
"   :Ag <search term>  THEN ':copen' shows quickfix windwo sweet
"   :Gsearch <cr> <search term> <cr> -- shows all matches. THEN
"     Select visual, then type ':s/string/string' <cr> THEN  ':Greplace' To
"     finalize, y/n/a , THEN type ':wa' to write all files
"   
"
" - Folds
"	- Press 'za' to open all folds
"	- Press 'cc' to open all folds
"
" - Change surroundings
" - cs'" to change singlequote to double quote on same line
" - cs"' to change doublequote single quote
" - ds( to delete nearby parens
" - dst  in HTML to delete surrounding tag
" - cst  in HTML to change surrounding tag - lets you type new tag
" - wrap in a tag, Select visually, 'S' then type new tag

" - Use statements
" - ,n - add usestatement for class we are hovering over, at the top of the file
" - ,nf - fully namespace
" - ,nf - 
"
" - Type ',be' to open buf exlorer
" - Type ',bt' to toggle buf exploere in the current windwo
" - Type ',bs' ',bv' to open up in a split
"
" - Command mode, show command history q: or q/
" - type '"qp' spit out something from register
" - :reg to see register items
" - Create own macro: let @a=""
