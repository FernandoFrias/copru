function! Compilacion()
	exe 'make'
	let pos = stridx(expand('%:t'), ".")
	let part = strpart(expand('%:t'), 0, pos)
	let ferr = printf("%s.err", part)
	if filereadable(ferr)
		exe printf("cf %s", ferr)
	endif
endfunction
