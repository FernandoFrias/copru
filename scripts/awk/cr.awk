BEGIN{
	FS="\t"
	HIHG_VALUES = "9999-9999-9999-9999"
}

function lee_registro()
{
	RAC = $1
	RAC_des = $2
	RAC_BB = $3
	RAC_DB = $4
	RAC_CR = $5
	RAC_EB = $6
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
	if(encontrado == 1)
		reg = sprintf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", RAC, RAC_des, MAP_CTA, MAP_CTA_des, RAC_BB, RAC_DB, RAC_CR, RAC_EB)
	else
		reg = sprintf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", RAC, RAC_des, "", "", RAC_BB, RAC_DB, RAC_CR, RAC_EB)
	printf(reg) > salida
}

{
	lee_registro()

	if (NR == 1){
		salida = sprintf("%s.auxiliar", FILENAME)
		lee_registro_MAP()
	}

	encontrado=0
	while(MAP_RAC <= RAC)
		if(MAP_RAC == RAC){
			encontrado=1
			break
		}
		else
			lee_registro_MAP()

	escribe_registro()
}

