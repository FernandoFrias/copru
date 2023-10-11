function inicializa()
{
	referencia = ""
	numlinea = ""
	numerror = ""
	descripcion = ""
}

BEGIN{
	inicializa()
}

{
	if(substr($0,1,1) == " ")
	{
		numlinea = gensub(/^ +([0-9]+) .+$/,"\\1",$0) 
		referencia = gensub(/^ +([0-9]+) ([0-9]+\/[0-9]+)* +(.+)$/,"\\3",$0)
	}
	else
		if(substr($0,1,1) == ">")
		{
			tipo = gensub(/^.+: ([E,I]) .+$/,"\\1",$0)
			numerror = gensub(/^.+ ([0-9]+): [E,I] .+$/,"\\1",$0)
			descripcion = gensub(/^.+ [0-9]+: [E,I] (.+)$/,"\\1",$0)
			if(length(numlinea) <= 0)
				numlinea=1
			if(length(referencia) <= 0)
				printf "%s|%s|%s|%s\n", tipo, numlinea, numerror, descripcion
			else
				printf "%s|%s|%s|%s: --> %s <--\n", tipo, numlinea, numerror, descripcion, referencia
			inicializa()
		}
		else
			if(length($0) > 0)
			{
				printf "%s\n", $0
				inicializa()
			}
}

