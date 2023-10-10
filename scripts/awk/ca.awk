BEGIN{
	FS="\t"
	HIHG_VALUES = "9999999999999999999"
}

function lee_registro()
{
	LINEA = $0
	F  = $6
}

function llena_campos_MAP()
{
	MAP_RAC = $1
	MAP_CTA = $2
	MAP_CTA_des = $3
}

function lee_registro_MAP()
{
	if (MAP_RAC != HIHG_VALUES){
		fin_archivo_MAP = getline < sprintf("%s", entrada)

		if(fin_archivo_MAP == 1)
			llena_campos_MAP()
		else
			MAP_RAC = HIHG_VALUES
	}
}

function escribe_registro()
{
	if(encontrado == 1){
		cmap = MAP_CTA
		cmapd = MAP_CTA_des
	}
	else{
		cmap = ""
		cmapd = ""
	}
	
	reg =  sprintf("%s\t%s\t%s\n", LINEA, cmap, cmapd)

	printf(reg) > salida
}

{
	lee_registro()

	if (NR == 1){
		lee_registro_MAP()
		salida = sprintf("%s.auxiliar", FILENAME)
	}

	encontrado=0
	while(F >= MAP_RAC)
		if(F == MAP_RAC){
			encontrado=1
			break
		}
		else
			lee_registro_MAP()

	escribe_registro()
}

END{
}

