BEGIN{
	FS="\t"
}

function lee_registro()
{
	OA = $1
	OS = $2
	key = $3
	ST = $4
	STN = $5
	NAC = $6
	NNC = $7
}

function valida_campos()
{
	if(ST !~ /[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]/)
	{
		printf "Formato del campo STAT inesperado en el registro %d: %s\n", NR, ST > error
		exit 1
	}

	if(NAC !~ /[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/)
	{
		printf "Formato del campo NEW ACCOUNT CUSF inesperado en el registro %d: %s\n", NR + 1, NAC > error
		exit 1
	}

	if(length(NNC) <= 1)
	{
		printf "El campo NEW NAME CUSF no esta informado en el registro %s %s\n", ST, NAC > error
		exit 1
	}
}

function escribe_registro()
{
	reg = sprintf("%s\t%s\t%s\n", ST, NAC, NNC)
	printf(reg) > salida
}

{
	if (NR > 0)
		salida = sprintf("%s.auxiliar", FILENAME)
	lee_registro()
	valida_campos()
	escribe_registro()
}

END{
}

