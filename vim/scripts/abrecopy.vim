function! ExisteArchivo()
	let copy = getreg('0')
	if empty(copy) == 1
		echo printf("Nombre de copy no informada")
	else
		let ix = stridx(copy, ".")
		if ix == -1
			let nomarch = copy . ".cpy"
		else
			let nomarch = copy . "cpy"
		endif
		let rt = "/home/xm731011/sources/PR/QCBLLESRC/"
		if empty(findfile(nomarch, rt)) == 1
			echo printf("La copy %s no existe", nomarch)
		else
			execute ':tabe ' . rt . nomarch
		endif
	endif
endfunction

