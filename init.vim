
set number
set undofile
set undodir

let mapleader = " " " map leader to Space

" for additional stuff in lua
lua require('config')
lua require('nvim-cmp_prefs')
" package manager stuff in external file -> shorter init.vim -> yay!
lua require("user.plugins")


""Settings specific for installed packages
"{{{
 "Map :GundoToggle to <F4>
  if has("python3") | let g:gundo_prefer_python3 = 1 | endif
  nnoremap <F4> :GundoToggle<CR>
  let g:python3_host_prog = '/usr/bin/python3'
" map leader+N to open NvimTreeOpen
  noremap <leader>N :NvimTreeOpen<CR>

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

"
"}}}

.
""An X11-aware Vim provides the two selection registers PRIMARY ("*) and CLIPBOARD ("+)
 "Most applications provide their current selection via PRIMARY "*
 "and use CLIPBOARD "+ for cut/copy/paste operations
 set clipboard=unnamedplus  "use "+ for yank/delete/change/put operations


"Set GUI and terminal appearance
set guifont=Source\ Code\ Pro:h14
let g:neovide_scale_factor = 1.0
"Blur
let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0

 if exists("g:neovide")
   autocmd VimEnter * :NvimTreeOpen<CR> "open NvimTree on startup
   colorscheme one "     GUI colorscheme
   set background=dark         "possible values for solarized: light/dark
   set guifont=Monospace\ 12    "to set interactively type 'set guifont=*' in gvim
 else
   colorscheme elflord          "terminal colorscheme
 endif

 "Bools
  set wrap           "wrap line at end of window
  set linebreak      "wrap whole words
  set number         "display line numbers
  set splitright     "open new vertical splits on the right
  set showcmd        "display incomplete commands (bottom right)
  set hidden         "don't show an error message when switching from a modified buffer
  set wildmenu       "displays auto-completed command list on pressing wildchar (i.e. tab)
 "set wildignorecase "case insensitive completion in wildmenu
  set visualbell     "flash the buffer when encountering an error (e.g. invalid movement)

 "Search (:h /, magic, pattern-overview)
  set ignorecase     "ignore case when using a search pattern
  set smartcase      "caps sensitive when upper-case in search pattern
  set incsearch      "Incremental search -> search as you type

 "Settings for tabulators and indentation (:h tabstop, autoindent)
  set tabstop=4      "number of spaces a "\t" in the text counts for
  set shiftwidth=4   "number of spaces used for each step of indent (>>,<<,etc.)
  set smarttab       "backspace removes up to <shiftwidth> spaces at start of line
  set expandtab      "expand tabs to spaces
  set autoindent     "copy indent from current line when starting a new line
  set smartindent    "smarter indentation in case of C-like source-code
  set breakindent    "on line wrap the "display-lines" are indented too

 "Show invisibles (e.g. tabs, EOL, etc.) (:h 'list') and provide a list of
 " displayed hidden characters and their accompanying symbols (:h 'listchars')
  set list
  set listchars =tab:→→
  set listchars+=nbsp:␣
  set listchars+=trail:•
  set listchars+=extends:⟩
  set listchars+=precedes:⟨
  "set listchars+=eol:↲

 "Define how automatic formatting is done (:h 'formatoptions', fo-table)
  set formatoptions=tcrqj

 "Text folding (:h folding, fold-methods, fold-commands)
  set foldmethod=marker   "Set foldmethod to marker (using foldmarker and commentstring)
  set foldcolumn=0        "Show folding column of width <set foldcolumn?> on the left

 "Spell checking (:h spell)
 "Enable spell checking in GUI-Mode
  if has("gui_running") | set spell | else | set nospell | endif
 "Set spell files and accepted languages (:h spell-quickstart)
  set spelllang=en_gb,de_at
  set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add

 "Autocompletion settings (:h ins-completion, 'completeopt')
 "Just show completion popup instead of directly inserting the first match
  set completeopt+=longest

 "Display as much as possible of the last line in a window (:h 'display')
  set display+=truncate

 "Increase maximum number of tabs
  set tabpagemax=100

 "Set number formats besides decimal, bin (0b), hex (0x), alpha [a-zA-Z]
  set nrformats=bin,hex,alpha

 "Allow sideways moving keys to move to the next/previous line
  set whichwrap=b,s,<,>,[,]  "traverse line breaks with arrow keys

 "Enable mouse usage (:h mouse)
  set mouse=a        "enable mouse selection in all modes as well as terminal
  set mousefocus     "focus follows mouse in split-view

 "Change cursor shape on mode switch:
  "{{{
  " 1 -> blinking block
  " 2 -> solid block
  " 3 -> blinking underscore
  " 4 -> solid underscore
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
  "}}}
"  let &t_SI = "\<Esc>[5 q" "SI = INSERT mode
"  let &t_SR = "\<Esc>[4 q" "SR = REPLACE mode
"  let &t_EI = "\<Esc>[1 q" "EI = NORMAL mode (ELSE)

""Key-maps and key-remaps (:h key-mapping, map-overview) edit vimrc
 "by hitting "<leader>e", "<leader>v" (vsplit) or "<leader>t" (tab)
  nnoremap <leader>e :edit    $MYVIMRC<CR>
  nnoremap <leader>v :vsplit  $MYVIMRC<CR>
  nnoremap <leader>t :tabedit $MYVIMRC<CR>

 "switch cwd to the directory of the open buffer (:h filename-modifiers)
  nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

 "copy whole content to clipboard
  nnoremap <leader>y :%y+

 "copy to end of line with "Y"
  nnoremap Y y$

 "if in visual mode re-select after using ">" or "<" for visual indentation
  vnoremap < <gv
  vnoremap > >gv

 "automatically close parenthesis, quotes, etc. (:h i_CTRL-G_U)
 "(single quotes interfere with words like e.g. don't)
 "inoremap <expr> '   "''\<c-g>U\<left>"
  inoremap <expr> " "\"\"\<c-g>U\<left>"
  inoremap <expr> (   "()\<c-g>U\<left>"
  inoremap <expr> [   "[]\<c-g>U\<left>"
  inoremap <expr> {   "{}\<c-g>U\<left>"

 "toggle code folding with "<space>" in normal mode
  nnoremap <space> zA

 "use |/_ to set the current window width/height widest/highest possible
  nnoremap \| <C-w>\|
  nnoremap _  <C-w>_

 "evaluate expression with expression register
  nnoremap Q 0yt=f=a<C-r>=<C-r>0<CR><Esc>

 "remove Blank Lines Command
  command! -range=% RBL :<line1>,<line2>g/^\s*$/d

 "faster buffer switching with  <C-p>, <C-n> and gb (bufferlist)
  nnoremap gb               :ls<CR>:b<Space>
  nnoremap <C-p>            :bp<CR>
  nnoremap <C-n>            :bn<CR>
  nnoremap <leader>bp       :bp<CR>
  nnoremap <leader>bn       :bn<CR>
  nnoremap <leader>#        :b#<CR>
 "annoyingly hitting <leader> stalls input
  "inoremap <leader>bp <Esc>:bp<CR>
  "inoremap <leader>bn <Esc>:bn<CR>

 "use "<C>" as modifier to work on displayed lines instead of numbered lines
 "<C-^> and <C-$> are not really possible to type therefore, g^ and g$ have to be used
 "{{{
  nnoremap <C-Up>    gk
  nnoremap <C-k>     gk
  nnoremap <C-Down>  gj
  nnoremap <C-j>     gj
  nnoremap <C-Home>  g^
  nnoremap <C-End>   g$
  inoremap <C-Up>    <Esc>gka
  inoremap <C-Down>  <Esc>gja
  inoremap <C-Home>  <Esc>g^i
  inoremap <C-End>   <Esc>g$a
 "}}}

 "move between split-windows by hitting alt+{h,j,k,l}
 "{{{
   noremap <M-h>       <C-w>h
   noremap <M-j>       <C-w>j
   noremap <M-k>       <C-w>k
   noremap <M-l>       <C-w>l
  inoremap <M-h>       <Esc><C-w>ha
  inoremap <M-j>       <Esc><C-w>ja
  inoremap <M-k>       <Esc><C-w>ka
  inoremap <M-l>       <Esc><C-w>la
 "}}}


""Settings for special circumstances (e.g. specified file-types or file-names)
 if has("autocmd")
 "enable filetype detection
   filetype on
   filetype plugin on
   set omnifunc=syntaxcomplete#Complete

 "automatically source your vimrc when saving files "named vimrc"
   autocmd bufwritepost init.vim source $MYVIMRC

 "change work-dir to current file's parent directory (:h filename-modifiers)
   autocmd VimEnter * cd %:p:h
   autocmd GuiEnter * cd %:p:h

"special tab behaviour for Filetypes (get Filetype by ":set filetype?")
 "Makefile
    autocmd FileType make setlocal ts=4 sw=4 sts=4 commentstring=#%s noexpandtab
 "LaTeX
  "local settings for tabstop and word wrapping
    autocmd FileType tex  setlocal ts=2 sw=2 sts=2 commentstring=%%s
  "add latex command key-word list
""   autocmd FileType tex execute 'setlocal dict+=~/.vim/words/'.&filetype.'.txt'
   "call function to start autocompletion from dictionary file after hitting '\'
    function! OpenCompletion()
     "if popup menu invisible AND prvious char '\'
      if !pumvisible() && (v:char == '\')
       "push  before ("i") the typeahead buffer
       "must be before to not break vim makros!
        call feedkeys("\<C-x>\<C-k>", "i")
      endif
    endfunction
    autocmd Filetype tex :autocmd InsertCharPre <buffer> call OpenCompletion()
 endif


" setup settings for zathura latex backwards search
let g:vimtex_view_method = 'zathura'
let g:latex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'latexmk'
