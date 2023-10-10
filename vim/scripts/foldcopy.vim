function! LinExpCopy()
	normal g_
	if getpos(".")[2] < 77
		let r = ""
	else
		normal $byw
		let r = getreg("0")
	endif
	return r
endfunction

function! Direccion(d)
	if a:d == "A"
		normal k
	endif
	if a:d == "B"
		normal j
	endif
endfunction

function! Linea(d, lim, c)
	if a:d == "A"
		let r = a:lim - a:c
	endif
	if a:d == "B"
		let r = (a:lim + a:c) - 1
	endif
	return r
endfunction

function! LineaCopy()
	return (match(getline("."), " COPY") == 6)
endfunction

function! PRLineCopy()
	let c = LinExpCopy()
	while strlen(c) == 0
		normal j
		let c = LinExpCopy()
	endwhile
	return c
endfunction

function! Continua(d)
	if a:d == "A"
		if LineaCopy()
			let c= "n"
		else
			let c= "s"
		endif
	else
		let c= "n"
	endif
	return c
endfunction

function! RecLin(p, cpy, dir)
	call setpos(".", a:p)
	let continuar = "s"
	let contador = 0
	while continuar == "s"
		call Direccion(a:dir)
		let contador = contador + 1
		if a:cpy == LinExpCopy()
			let continuar = "s"
		else
			let continuar = Continua(a:dir)
		endif
	endwhile
	return Linea(a:dir, a:p[1], contador)
endfunction

function! FoldCopy()
	if searchpos('^.\{73\}[A-Z0-9]\{4,8\}$', 'n', line('$'))[0] > 0
		if foldlevel(line(".")) == 0
			let pin = getpos(".")
			let lec = LinExpCopy()
			if strlen(lec) == 0
				if LineaCopy()
					let lec = PRLineCopy()
					let npin = getpos(".")
					exe printf("%d,%dfo", pin[1], RecLin(npin, lec, "B"))
				endif
			else
				exe printf("%d,%dfo", RecLin(pin, lec, "A"), RecLin(pin, lec, "B"))
			endif
			call cursor(pin[1], pin[2])
		else
			normal za
		endif
	endif
endfunction

function! Busqueda()
	let [l, c] = searchpos('^.\{6\}\ COPY', 'n', line('$'))
	return l
endfunction

function! FoldAllCopys()
	let po = getpos(".")
	call cursor(1, 1)
	if searchpos('^.\{73\}[A-Z0-9]\{4,8\}$', 'n', line('$'))[0] > 0
		normal zj
		if line(".") == 1
			let l = Busqueda()
			let lineas = []
			while l > 0
				call cursor(l, 1)
				call add(lineas, l)
				normal j
				let l = Busqueda()
			endwhile
			for occ in lineas
				call cursor(occ, 1)
				call FoldCopy()
			endfor
		else
			let pa = po[1]
			let pb = line(".")
			while pa != pb
				normal za
				let pa = pb
				normal zj
				let pb = line(".")
			endwhile
		endif
	endif
	call cursor(po[1], po[2])
endfunction

function! TextoPliegue()
	let linea = getline(v:foldstart)
	let total = (v:foldend - v:foldstart) + 1
	let lin1 = substitute(linea, '^\(.\{6\}\)\ \(COPY\)\(\ \)\([0-9A-Z]\+\).\+', '\1+\2\ \4+', 'g')
	let lin2 = printf("%s(%d lineas)", lin1, total)
	let sp = "\\ "
	exe printf("set fillchars=fold:%s", sp)
	return lin2
endfunction

function! TipoLinea()
	let r = -1
	if substitute(getline('.'), '^.\{6\}\ COPY.\+$', 'C', 'g') == "C"
		let r = 0
	else
		if substitute(getline('.'), '^\ \+==.\+$', 'R', 'g') == "R"
			let r = 1
		else
			if substitute(getline('.'), '^.\{73\}[A-Z0-9]\{4,8\}$', 'E', 'g') == "E"
				let r = 2
			endif
		endif
	endif
	return r
endfunction

function! Fold()
"	echo printf("Pos = %d", TipoLinea())
	let po = getpos(".")
	call cursor(1, 1)
	let nul = 0
	normal zj
	if line(".") != 1
		let nul = line(".")
	endif
	echo printf("copy en la linea %d, tipo = %d", nul, TipoLinea())
"	call cursor(po[1], po[2])
endfunction

