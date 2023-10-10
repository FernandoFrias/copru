function! MaysMins(modo, tipo) range
	let cp = getpos(".")

	if a:tipo == "mayusculas"
		let com = "gUU"
	endif
	if a:tipo == "minusculas"
		let com = "guu"
	endif

	exe printf("%d,%d g/^/normal %s", a:firstline, a:lastline, com)

	call setpos(".", cp)
	echo printf("%s: conversión a %s desde la linea %d hasta la linea %d, total : %d linea(s)",
		\ a:modo, a:tipo, a:firstline, a:lastline, (a:lastline - a:firstline) + 1)
endfunction

function! Sustitucion()
	echo printf("sustitucion: %s por %s", getreg(""), getreg(0))
endfunction

