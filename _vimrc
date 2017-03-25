execute pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible

if v:progname =~? "evim"
  finish
endif


" allow backspacing over everything in insert mode

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
"Options
""""""""""""""""""""""""""""""""""""""""""""""""""
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nocompatible
set ignorecase
set smartcase
set visualbell
set relativenumber
set encoding=utf-8
set hidden "allow hidden buffers
set ttyfast
set mouse=a
set backspace=indent,eol,start
set tabstop=2 softtabstop=2 noexpandtab shiftwidth=2 smarttab
set wrap
set nopaste
set laststatus=2
set matchpairs+=<:> "use % to jump between pairs

""""""""""""""""""""""""""""""""""""""""""""""""""
"Plugin options
""""""""""""""""""""""""""""""""""""""""""""""""""
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" " better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"CtrlP Settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

"airline
let g:airline_powerline_fonts=1
		if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
"javascript syntax
let g:used_javascript_libs = 'underscore,backbone,jquery,angularjs'

"syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"omnisharp
"let g:OmniSharp_server_type = 'roslyn'
set splitbelow
"let g:syntastic_cs_checkers = ['code_checker']
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,InsertLeave,TextChanged *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
		autocmd FileType cs set noshowmatch
		autocmd FileType cs let g:SuperTabDefaultCompletionType = 'context'
		autocmd FileType cs let g:SuperTabContextDefaultCompletionType = "<C-n>"
		autocmd FileType cs let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
		autocmd FileType cs let g:SuperTabClosePreviewOnPopupClose = 1

augroup END
" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader>ca :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader>ca :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F3> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet=1
""""""""""""""""""""""""""""""""""""""""""""""""""
"Global Customizations
""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"

""""""""""""""""""""""""""""""""""""""""""""""""""
"Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't use Ex mode, use Q for formatting
map Q gq
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
map <leader>y "+y
map <leader>p "+p
vmap <leader>y "+y
vmap <leader>p "+p
inoremap {<CR> {<CR>}<Esc>ko
nmap <C-h> %
vmap <C-h> %
nnoremap ,, :noh<cr>
nnoremap j gj
nnoremap k gk
nnoremap Y y$
"move line mappings
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
"strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader>m Vatzf
"sort css... not sure if I want this
"edit vimrc on fly
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>o o<esc>k
nnoremap <leader>O O<esc>j
nnoremap <leader>; mn$a;<esc>`n
nnoremap <leader>, mn$a,<esc>`n
nnoremap <leader>a :Ack
nnoremap <leader>r ciw<c-r>0<esc>
nnoremap <leader>"r ci"<c-r>0<esc>
nnoremap gp `[v`]
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>q :Bdelete<CR>
nnoremap <Leader>l :bnext<CR>
nnoremap <Leader>h :bprev<CR>
"pull current word into LHS of substitution
nmap <leader>s :%s/\<<c-r>=expand("<cword>")<cr>\>/
"pull visual selection into LHS of substitution
vmap <leader>S :<C-U>%s/\<<c-r>*\>/
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
nnoremap <F2> :call NumberToggle()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""
"Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
	"autosave on losing focus
	au FocusLost * :wa

  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  autocmd FileType html setlocal shiftwidth=4 tabstop=4 expandtab softtabstop=0
  autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 expandtab softtabstop=0
  autocmd FileType aspnet setlocal shiftwidth=4 tabstop=4 expandtab softtabstop=0
  
  augroup END

	augroup myvimrc
			au!
			au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
	augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

""""""""""""""""""""""""""""""""""""""""""""""""""
"Other Stuff
""""""""""""""""""""""""""""""""""""""""""""""""""

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
	" Prevent that the langmap option applies to characters that result from a
	" mapping.  If unset (default), this may break plugins (but it's backward
	" compatible).
	set langnoremap
endif

:runtime macros/matchit.vim

function! NumberToggle()
	if(&relativenumber == 1)
		set number
	else
		set relativenumber
	endif
endfunc


colorscheme desertEx
