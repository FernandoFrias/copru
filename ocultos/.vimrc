set nu
set tabstop=4
set shiftwidth=4
set ruler
set nowrap
set hlsearch
set backspace=indent,eol,start
set cursorcolumn
set cursorline
set incsearch
set ttyfast
set ffs=unix
set scrolloff=0
set encoding=UTF-8
set t_Co=256

syn on
filetype on
filetype plugin on
colorscheme ron

let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#branch#use_vcscommand = 1
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_y = ''
"let g:airline_section_error = ''
let g:airline_section_warning = ''
"let g:airline_section_z = '%l/%v %p%% %L'
"let g:airline_section_z = '∈%v,Ш%l(%L)%p%%'
"let g:airline_section_z = '▶%v,▲%l‹%L›%p%%'
"let g:airline_section_z = '▶%v▲%l%L%p%%'
"let g:airline_section_z = '▶%v▲%l╱%L╱%p%%'
"let g:airline_section_z = '╱%v╱%l╱%L╱%p%%'
"let g:airline_section_z = '╱%v╱%L╱%p%%'
let g:airline_section_z = '%#__accent_bold#%v%#__restore__#╱%L╱%#__accent_bold#%p%%%#__restore__#'
"let g:airline_section_z = '╲%v╲%l╲%L╲%p%%'
"let g:airline_section_z = '│%v│%l│%L│%p%%│'
"let g:airline_section_z = '│%v│%L│%p%%│'
"let g:airline_section_z = '┃%v┃%l┃%L┃%p%%'
"let g:airline_theme='alduin'
"let g:airline_theme='angr'
"let g:airline_theme='atomic'
"let g:airline_theme='aurora'
"let g:airline_theme='ayu_dark' <-
"let g:airline_theme='ayu_light'
"let g:airline_theme='ayu_mirage'
"let g:airline_theme='badcat'
"let g:airline_theme='badwolf'
"let g:airline_theme='base16'
"let g:airline_theme='base16_3024'
"let g:airline_theme='base16_adwaita'
"let g:airline_theme='base16_apathy'
"let g:airline_theme='base16_ashes'
"let g:airline_theme='base16_atelierdune'
"let g:airline_theme='base16_atelierforest'
"let g:airline_theme='base16_atelierheath'
"let g:airline_theme='base16_atelierlakeside'
"let g:airline_theme='base16_atelierseaside'
"let g:airline_theme='base16_bespin'
"let g:airline_theme='base16_brewer'
"let g:airline_theme='base16_bright'
"let g:airline_theme='base16_chalk'
"let g:airline_theme='base16_classic'
"let g:airline_theme='base16_codeschool'
"let g:airline_theme='base16_colors'
"let g:airline_theme='base16_default'
"let g:airline_theme='base16_eighties'
"let g:airline_theme='base16_embers'
"let g:airline_theme='base16_flat'
"let g:airline_theme='base16_google'
"let g:airline_theme='base16_google'
"let g:airline_theme='base16_grayscale'
"let g:airline_theme='base16_greenscreen'
"let g:airline_theme='base16_harmonic16'
"let g:airline_theme='base16_hopscotch'
"let g:airline_theme='base16_isotope'
"let g:airline_theme='base16_londontube'
"let g:airline_theme='base16_marrakesh'
"let g:airline_theme='base16_mocha'
"let g:airline_theme='base16_monokai'
"let g:airline_theme='base16_nord'
"let g:airline_theme='base16_ocean'
"let g:airline_theme='base16_oceanicnext'
"let g:airline_theme='base16_paraiso'
"let g:airline_theme='base16_pop' <-
"let g:airline_theme='base16_railscasts'
"let g:airline_theme='base16_seti'
"let g:airline_theme='base16_shapeshifter'
"let g:airline_theme='base16_shell'
"let g:airline_theme='base16_solarized'
"let g:airline_theme='base16_spacemacs'
"let g:airline_theme='base16_summerfruit'
"let g:airline_theme='base16_tomorrow'
"let g:airline_theme='base16_twilight'
"let g:airline_theme='base16_vim'
"let g:airline_theme='base16color'
"let g:airline_theme='base16color' <-
"let g:airline_theme='behelit' <-
"let g:airline_theme='biogoo'
"let g:airline_theme='bubblegum' <-
"let g:airline_theme='cobalt2'
"let g:airline_theme='cool'
"let g:airline_theme='dark' <-
"let g:airline_theme='dark_minimal' <-
"let g:airline_theme='desertink'
"let g:airline_theme='deus' <-
"let g:airline_theme='distinguished'
"let g:airline_theme='dracula'
"let g:airline_theme='durant' <-
"let g:airline_theme='fairyfloss'
"let g:airline_theme='fruit_punch' <-
"let g:airline_theme='hybrid'
"let g:airline_theme='hybridline' <-
"let g:airline_theme='jellybeans'
"let g:airline_theme='jet'
"let g:airline_theme='kalisi'
"let g:airline_theme='kolor'
"let g:airline_theme='laederon'
"let g:airline_theme='light'
"let g:airline_theme='lucius'
"let g:airline_theme='luna'
"let g:airline_theme='minimalist'
"let g:airline_theme='molokai' <-
"let g:airline_theme='monochrome'
"let g:airline_theme='murmur' <-
"let g:airline_theme='night_owl'
"let g:airline_theme='onedark' <-
"let g:airline_theme='ouo' <-
"let g:airline_theme='papercolor' <-
"let g:airline_theme='peaksea'
"let g:airline_theme='powerlineish' <-
"let g:airline_theme='qwq'
"let g:airline_theme='random'
"let g:airline_theme='raven'
"let g:airline_theme='ravenpower'
"let g:airline_theme='seagull'
"let g:airline_theme='serene'
"let g:airline_theme='sierra'
"let g:airline_theme='silver'
"let g:airline_theme='simple'
"let g:airline_theme='soda'
"let g:airline_theme='sol'
"let g:airline_theme='solarized'
"let g:airline_theme='solarized_flood'
"let g:airline_theme='term'
"let g:airline_theme='term_light'
"let g:airline_theme='tomorrow'
"let g:airline_theme='ubaryd'
"let g:airline_theme='understated'
"let g:airline_theme='vice'
"let g:airline_theme='violet'
"let g:airline_theme='wombat'
"let g:airline_theme='xtermlight'
"let g:airline_theme='zenburn'
"set noshowmode
"set foldmethod=indent
"set foldlevel=1
"set foldclose=all
"set mouse=a
"filetype indent on
"colorscheme desert
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview
"highlight VertSplit cterm=reverse ctermbg=17 ctermfg=17
"highlight VertSplit cterm=reverse ctermbg=Yellow ctermfg=Yellow
highlight VertSplit cterm=reverse ctermbg=Yellow ctermfg=Yellow
highlight LineNr cterm=NONE ctermfg=White
"highlight CursorLineNr cterm=NONE ctermbg=LightGreen ctermfg=White
"highlight CursorLineNr cterm=NONE ctermbg=DarkBlue ctermfg=White
highlight CursorLineNr cterm=bold ctermbg=48 ctermfg=16
highlight Visual cterm=NONE ctermfg=White ctermbg=DarkBlue
highlight StatusLine cterm=NONE ctermfg=White ctermbg=DarkBlue
highlight StatusLineNC cterm=underline ctermfg=DarkBlue
"highlight Search cterm=bold ctermbg=180 ctermfg=88
highlight Search cterm=bold ctermbg=88 ctermfg=229
highlight IncSearch cterm=NONE ctermfg=Yellow ctermbg=Blue
"highlight Search cterm=bold ctermbg=DarkGreen ctermfg=LightGrey
"highlight Search cterm=NONE ctermbg=DarkGrey ctermfg=Blue
"highlight CursorColumn cterm=NONE ctermbg=DarkMagenta
"highlight CursorLine cterm=NONE ctermbg=DarkMagenta
"highlight CursorColumn cterm=NONE ctermbg=18
"highlight CursorLine cterm=NONE ctermbg=18
"highlight CursorColumn cterm=NONE ctermbg=LightMagenta
"highlight CursorLine cterm=NONE ctermbg=LightMagenta
highlight CursorColumn cterm=NONE ctermbg=236
highlight CursorLine cterm=NONE ctermbg=236
highlight Folded cterm=bold ctermbg=NONE ctermfg=Black ctermbg=149
"highlight DiffChange ctermbg=NONE ctermfg=DarkGreen ctermbg=53
highlight DiffChange cterm=bold ctermbg=NONE ctermfg=DarkBlue
"highlight DiffChange ctermbg=NONE ctermfg=Blue
"highlight DiffText term=reverse cterm=bold ctermbg=Blue gui=bold guibg=olivedrab
"highlight DiffText cterm=bold ctermbg=58 ctermfg=190
"highlight DiffText cterm=bold ctermbg=94 ctermfg=14
highlight DiffText cterm=bold ctermbg=Red ctermfg=White
highlight DiffAdd cterm=bold ctermbg=20
highlight DiffDelete cterm=NONE ctermbg=DarkRed ctermfg=White
highlight qfLineNr cterm=NONE ctermfg=Blue
"highlight sqlSymbol cterm=NONE ctermfg=Cyan
highlight qfSeparator cterm=NONE ctermfg=Green
highlight TagbarKind cterm=bold guifg=Green ctermfg=154
highlight TagbarHighlight cterm=bold ctermfg=White ctermbg=Magenta
highlight TagbarFoldIcon cterm=NONE ctermfg=Yellow
"highlight TabLine     ctermfg=Blue ctermbg=Black
"highlight TabLineSel  ctermfg=Blue ctermbg=White
"highlight TabLineFill ctermfg=Black ctermbg=Black
highlight Pmenu cterm=NONE ctermfg=White ctermbg=DarkBlue
highlight PmenuSel cterm=bold ctermfg=Yellow ctermbg=DarkRed
highlight PmenuSbar cterm=NONE ctermbg=Cyan
highlight PmenuThumb cterm=NONE ctermbg=Magenta
highlight WarningMsg term=standout ctermfg=Red guifg=Black guibg=Green

let g:tagbar_iconchars = ['', '']
"let g:tagbar_iconchars = ['◆', '◊']
"let g:tagbar_iconchars = ['▶', '▼']
"let g:tagbar_iconchars = ['▶', '▷']
"let g:tagbar_iconchars = ['●', '○']
"let g:tagbar_iconchars = ['+', '-']
let g:tagbar_compact = 1

nmap <silent> st :TagbarToggle<CR>
nmap <silent> sl ::TagbarCurrentTag<CR>
nmap <silent> sx T<space>yE:call ExisteArchivo()<CR>
"nmap <silent> sn ::NERDTreeToggle<CR>
nmap <silent> sn ::NERDTreeVCS<CR>
nmap <silent> sf ::NERDTreeFind<CR>

map <C-Right> <C-W>l 
map <C-l> <C-W>l 
map <C-Left> <C-W>h 
map <C-h> <C-W>h 
map <C-Down> <C-W>j 
map <C-j> <C-W>j 
map <C-Up> <C-W>k 
map <C-k> <C-W>k 

au filetype lilypond setlocal makeprg=./proc.sh\ %
