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
"set foldmethod=indent
"set foldlevel=1
"set foldclose=all
"set mouse=a
filetype on
filetype plugin on
"filetype indent on
"colorscheme desert
colorscheme ron
syn on
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview
highlight Cob400Division cterm=NONE ctermfg=White
highlight Cob400DivisionName cterm=NONE ctermfg=White
highlight Cob400Section cterm=underline ctermfg=Yellow
highlight Cob400SectionName cterm=underline ctermfg=Yellow
highlight Cob400Paragraph cterm=NONE ctermfg=LightBlue
highlight Cob400Reserved cterm=bold ctermfg=LightGreen
"highlight Cob400String cterm=bold ctermfg=DarkCyan
highlight Cob400String cterm=bold ctermfg=LightRed
highlight Cob400Pic cterm=bold ctermfg=White
highlight Cob400Watch cterm=bold ctermfg=Green
highlight Cob400Number cterm=bold ctermfg=Yellow
highlight Cob400Signs cterm=NONE ctermfg=Magenta
highlight Cob400CALLs cterm=bold ctermfg=Yellow
highlight Cob400Copy cterm=NONE ctermfg=Grey
highlight Cob400Marker cterm=bold ctermfg=DarkCyan
highlight Cob400GoTo cterm=bold ctermfg=LightBlue
highlight VertSplit cterm=reverse ctermbg=White ctermfg=Grey
highlight LineNr cterm=NONE ctermfg=White
highlight CursorLineNr cterm=NONE ctermbg=LightGreen ctermfg=White
highlight Visual cterm=NONE ctermfg=White ctermbg=DarkBlue
highlight StatusLine cterm=NONE ctermfg=White ctermbg=DarkBlue
highlight StatusLineNC cterm=underline ctermfg=DarkBlue
highlight Search cterm=NONE ctermbg=LightBlue ctermfg=Grey
"highlight Search cterm=bold ctermbg=DarkGreen ctermfg=LightGrey
"highlight Search cterm=NONE ctermbg=DarkGrey ctermfg=Blue
highlight IncSearch cterm=NONE ctermfg=Yellow ctermbg=Blue
highlight CursorColumn cterm=NONE ctermbg=DarkGrey
highlight CursorLine cterm=NONE ctermbg=DarkGrey
"highlight CursorColumn cterm=NONE ctermbg=LightMagenta
"highlight CursorLine cterm=NONE ctermbg=LightMagenta
highlight Folded ctermbg=NONE ctermfg=White ctermbg=LightGreen
highlight DiffChange ctermbg=NONE ctermfg=Blue
highlight qfLineNr cterm=NONE ctermfg=Blue
highlight sqlSymbol cterm=NONE ctermfg=Cyan
highlight qfSeparator cterm=NONE ctermfg=Green
highlight TagbarKind guifg=Green ctermfg=Green
highlight TabLine     ctermfg=Blue ctermbg=Black
highlight TabLineSel  ctermfg=Blue ctermbg=White
highlight TabLineFill ctermfg=Black ctermbg=Black
highlight TagbarHighlight cterm=NONE ctermfg=White ctermbg=Magenta
highlight Pmenu cterm=NONE ctermfg=White ctermbg=DarkBlue
highlight PmenuSel cterm=NONE ctermfg=Yellow ctermbg=DarkRed
highlight PmenuSbar cterm=NONE ctermbg=Green
highlight PmenuThumb cterm=NONE ctermbg=Magenta

au filetype sql setlocal makeprg=~/querys/launch.sh\ %
au filetype sql map <silent> <F5> :make<CR>
"au filetype Cob400 setlocal makeprg=compile.sh\ %
"au filetype Cob400 nmap <silent> sf :call FoldCopy()<CR>
"au filetype Cob400 nmap <silent> sg :call FoldAllCopys()<CR>
au filetype Cob400 setlocal makeprg=cprg.sh\ %
au filetype Cob400 map <silent> <F5> :call Compilacion()<CR>
au filetype Cob400 nmap <silent> sg :call Fold()<CR>
au filetype Cob400 setlocal foldtext=TextoPliegue()
"au filetype rexx setlocal makeprg=compile.sh\ %
au filetype rexx setlocal makeprg=cprg.sh\ %
au filetype rexx map <silent> <F5> :call Compilacion()<CR>

set tags=/home/xm731011/sources/PR/QCBLLESRC/.QCBLLESRC,/home/xm731011/sources/PR/SRCE/.SRCE,/home/xm731011/sources/PR/DBSRCE/.DBSRCE
let g:tagbar_iconchars = ['▶', '▼']
"let g:tagbar_iconchars = ['▶', '▷']
"let g:tagbar_iconchars = ['●', '○']
"let g:tagbar_iconchars = ['+', '-']
let g:tagbar_compact = 1

"source /home/xm731011/.scripts/vim/abrecopy.vim
"source /home/xm731011/.scripts/vim/foldcopy.vim
source /home/xm731011/.vim/scripts/basico.vim
source /home/xm731011/.vim/scripts/compila.vim

nmap <silent> sa :			call MaysMins("normal", "mayusculas")<CR>
vmap <silent> sa :<c-u>'<,'>call MaysMins("rango", "mayusculas")<CR>

nmap <silent> si :			call MaysMins("normal", "minusculas")<CR>
vmap <silent> si :<c-u>'<,'>call MaysMins("rango", "minusculas")<CR>

nmap <silent> ss T<space>dw"0P: call Sustitucion()<CR>

nmap <silent> st :TagbarToggle<CR>
nmap <silent> sl :TlistToggle<CR>
nmap <silent> sx T<space>yE:call ExisteArchivo()<CR>

map <C-Right> <C-W>l 
map <C-l> <C-W>l 
map <C-Left> <C-W>h 
map <C-h> <C-W>h 
map <C-Down> <C-W>j 
map <C-j> <C-W>j 
map <C-Up> <C-W>k 
map <C-k> <C-W>k 

"	CheckStandards
set efm+=%E%*[\ \+]%n%*[\ \+]%l\ :\ %m
"	IBM ILE COBOL
set efm+=%W%#%*[\ \+]%l\ \ MSGID:\ LNC%n\ \ SEVERITY:\ %*[10\|20]\ \ SEQNBR:\ %*[\ \|+]%*[0-9\+],
set efm+=%C\ \ \ \ \ \ \ \ \ \Message\ .\ .\ .\ .\ :\ \ \ %m,%Z%>
set efm+=%E%#%*[\ \+]%l\ \ MSGID:\ LNC%n\ \ SEVERITY:\ %*[30\|40\|50]\ \ SEQNBR:\ %*[\ \|+]%*[0-9\+],
set efm+=%C\ \ \ \ \ \ \ \ \ \Message\ .\ .\ .\ .\ :\ \ \ %m,%Z%>
"	SQL ILE COBOL
set efm+=%WSQL%n\ %*[\ \+]%*[0\|10\|20]%*[\ \+]%l\ \ %m
set efm+=%ESQL%n\ %*[\ \+]%*[30\|40\|50]%*[\ \+]%l\ \ Position\ %c\ %m
"	Control Language
set efm+=%WLine:\ %l\ Error:\ CPD%n\ %*[0\|10\|20]\ \ %m
set efm+=%ELine:\ %l\ Error:\ CPD%n\ %*[30\|40\|50]\ \ %m

