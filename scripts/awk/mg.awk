#ordenar por:
#- Regulatory Account      [6,19]. XXXX-XXXX-XXXX-XXXX
#                                  RA3  RA2  RA1  RA0
#- Journal Effective Date  [28,10]
#- Batch ID                [22,8]

##################################################

BEGIN{
	FS="\t"
	fin_archivo_RA1=1
	fin_archivo_MOV=1
	Debitos_tot = 0.0
	Creditos_tot = 0.0
	HIHG_VALUES = "9999"
	MAP_RAC = ""
	MAP_CTA = ""
	MAP_CTA_des = ""
	TA = 0
}

function anterior(T)
{
	RA1_ant = RA1;
}

function igual(T)
{
	if(RA1_ant == RA1)
		return 1
	else
		return 0
}

function general(d)
{
	ax = d
	gsub(/_/,"\\_",ax)
	gsub(/&/,"\\\\&",ax)
	gsub(/´/,"'",ax)
	gsub(/%/,"\\%",ax)
	gsub(/°/,"$^o$",ax)
	gsub(/¥/,"Ñ",ax)
	gsub(/#/,"\\#",ax)
#	gsub(/ /,"\ ",ax)
	gsub(/ /,"\\ ",ax)
	gsub(/Ó/,"\\'O",ax)
	return ax
}

function moneda(num)
{
	numa = gensub(/([0-9][0-9][0-9])\.([0-9][0-9])/, ",\\1.\\2", "g", sprintf("%.2f", num))
	numb = gensub(/([0-9][0-9][0-9]),([0-9][0-9][0-9])\.([0-9][0-9])/, ",\\1,\\2.\\3", "g", numa)
	numc = gensub(/([0-9][0-9][0-9]),([0-9][0-9][0-9]),([0-9][0-9][0-9])\.([0-9][0-9])/, ",\\1,\\2,\\3.\\4", "g", numb)
	gsub(/^,/,"", numc)
	gsub(/^-,/,"-", numc)
	return numc
}

function no_fin_RA1()
{
	if(fin_archivo_RA1 == 1)
		return 1 #true
	else
		return 0 #false
}

function no_fin_MOV()
{
	if(fin_archivo_MOV == 1)
		return 1 #true
	else
		return 0 #false
}

function cantidad(cadena)
{
	auxiliar = cadena
	gsub(/"/, "", auxiliar)
	gsub(/,/, ".", auxiliar)
	return auxiliar
}

function descripcion(cadena)
{
	auxiliar = cadena
	gsub(/^"/, "", auxiliar)
	gsub(/"$/, "", auxiliar)
	gsub(/""/, "\"", auxiliar)
	return auxiliar
}

function lee_registro_MOV()
{
	fin_archivo_MOV = getline < sprintf("%s", entrada)

	if(no_fin_MOV())
	{
		Reg_Acc = $1
		RAC = substr(Reg_Acc, 1, 4)
		Jou_Eff_Date = $2
		Ent_Deb_Amt = $3
		Ent_Cre_Amt = $4
		Acc_Deb_Amt = $5
		Acc_Cre_Amt = $6
	}
}

function llena_campos_RA1()
{
# lee RA1.txt
	RA1 = $1
	RA1_des = $2
	RA1_BB = $3
	RA1_DB = $4
	RA1_CR = $5
	RA1_EB = $6
}

function llena_campos_MAP()
{
	MAP_RAC = substr($1, 1, 4)
	MAP_CTA = $2
	MAP_CTA_des = $3
}

function lee_registro_MAP()
{
	if (MAP_RAC != HIHG_VALUES){
		fin_archivo_MAP = getline < sprintf("%s", map)

		if(fin_archivo_MAP == 1)
			llena_campos_MAP()
		else
			MAP_RAC = HIHG_VALUES
	}
}

function fecha(f)
{
	return sprintf("%02d-%02d-%4d", substr(f, 9, 2), substr(f, 6, 2), substr(f, 1, 4))
}

function tipo_renglon()
{
	if(rc == 1)
	{
		tipo = "\\rowcolor{gray!25}"
		rc = rc + 1
	}
	else
	{
		tipo = ""
		rc = 1
	}

	return tipo
}

function imprime_detalle(FEC, CTA, DES, SI, DB, CR, CF)
{
	printf("%s%s&%s-0000-0000-0000&%s&%s&%s&%s&%s\\\\\n", tipo_renglon(), fecha(FEC), general(CTA), general(DES), moneda(SI), moneda(DB), moneda(CR), moneda(CF))
}

function imprime_total_parcial(D, C, S)
{
	printf("\\toprule\n\\hhline{~~~~--}&&\\multicolumn{2}{E}{\\textbf{Importe total de movimientos}}&\\cellcolor{gray!25}\\textbf{%s}&\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~--}\n", moneda(D), moneda(C))
	printf("\\addlinespace\\hhline{~~~~~~-}&&&&\\multicolumn{2}{F}{\\textbf{Saldo al %s}}&\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~~~-}\\\\\n", ffin, moneda(S))
#	printf("\\addlinespace\\hhline{~~~~~~-}&&&&\\multicolumn{2}{F}{\\textbf{Saldo al %s}}&\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~~~-}\\\\\n", ffin, moneda(RA1_BB_Amt + FEC_monto_debitos - FEC_monto_creditos ))
}

function proceso_fecha()
{
	c = c + 1
	DET_monto_debitos = DET_monto_debitos + Acc_Deb_Amt
	DET_monto_creditos = DET_monto_creditos + Acc_Cre_Amt
	lee_registro_MOV()
}

function movimientos_cuenta()
{
	c = 0
	DET_monto_debitos = 0.0
	DET_monto_creditos = 0.0
	Jou_Eff_Date_ant = Jou_Eff_Date
	while(no_fin_MOV() && RA1 == Reg_Acc && Jou_Eff_Date_ant == Jou_Eff_Date)
		proceso_fecha()
	DET_EB = DET_BB + DET_monto_debitos - DET_monto_creditos 
#	printf("%s %s %s %s %s %s %s\n", Jou_Eff_Date_ant, RA1, RA1_des, moneda(DET_BB), moneda(DET_monto_debitos), moneda(DET_monto_creditos), moneda(DET_EB))
	imprime_detalle(Jou_Eff_Date_ant, RA1, RA1_des, DET_BB, DET_monto_debitos, DET_monto_creditos, DET_EB)
	DET_BB = DET_EB
	CTA_monto_debitos = CTA_monto_debitos + DET_monto_debitos
	CTA_monto_creditos = CTA_monto_creditos + DET_monto_creditos
}

function busca_desc(d, a)
{
	e = 0;
	for(i = 0; i < TA; i++)
		if(d == a[i]){
			e = 1;
			break
		}
	return e;
}

function imprime_saldo_inicial(RA, RA_des, Amt)
{
	dsc[0] = "";
	while(MAP_RAC <= RA1){
		if(MAP_RAC == RA1){
			MAP_CTA_ant = MAP_CTA;
			if(busca_desc(MAP_CTA_des, dsc) == 0)
				dsc[TA++] = MAP_CTA_des;
		}
		lee_registro_MAP()
	}

	dt = "";
	for(i = 0; i < TA; i++)
		if(i == 0)
			dt = dsc[i];
		else
			dt = dt "<>" dsc[i];
	TA = 0;
	delete dsc;

	printf("&\\textbf{%s-00-00-00}&\\textbf{%s}&&\\multicolumn{2}{F}{}&\\\\\n", substr(MAP_CTA_ant, 1, 3), general(dt))

	printf("&\\textbf{%s-0000-0000-0000}&\\textbf{%s}&&\\multicolumn{2}{F}{\\textbf{Saldo inicial}}&\\textbf{%s}\\\\\n\\bottomrule\n", RA, general(RA_des), moneda(Amt))
}

{
	llena_campos_RA1()
	if (NR == 1){
		lee_registro_MOV()
		lee_registro_MAP()
	}


	anterior("RA1")
	DET_BB = RA1_BB
	CTA_monto_debitos = 0.0
	CTA_monto_creditos = 0.0
	rc = 1
	imprime_saldo_inicial(RA1, RA1_des, RA1_BB)
	while(no_fin_MOV() && RA1 == Reg_Acc)
		movimientos_cuenta()
#	printf(" total de movimientos %s %s\n", moneda(CTA_monto_debitos), moneda(CTA_monto_creditos))
	imprime_total_parcial(CTA_monto_debitos, CTA_monto_creditos, RA1_EB)
	Debitos_tot = Debitos_tot + CTA_monto_debitos
	Creditos_tot = Creditos_tot + CTA_monto_creditos
}

END{
	printf("\\hhline{~~~~--}&&\\multicolumn{2}{E}{\\textbf{Gran total del mes}}&\\cellcolor{gray!25}\\textbf{%s}&\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~--}\\\\\n", moneda(Debitos_tot), moneda(Creditos_tot))
}

