#ordenar por:
#- Regulatory Account      [6,19]. XXXX-XXXX-XXXX-XXXX
#                                  RA3  RA2  RA1  RA0
#- Journal Effective Date  [28,10]
#- Batch ID                [22,8]
##################################################

BEGIN{
	FS="\t"
	fin_archivo_RAC=1
	fin_archivo_MOV=1
	RAC1_ant = ""
	MAPP=0

	Mov_Deb_Fec_tot = 0.0
	Mov_Cre_Fec_tot = 0.0
}

function lee_RAC1()
{
	if(getline < sprintf("%s", entrada1) <= 0)
	{
		printf("EOF RA1.txt\n") > sprintf("%s", error)
		exit
	}
	RA1_RAC = $1
	RA1_RAC_des = $2
	RA1_BB_Amt = $3
	RA1_CP_Deb = $4
	RA1_CP_Cre = $5
	RA1_EB_Amt = $6
}

function lee_RAC2()
{
	if(getline < sprintf("%s", entrada2) <= 0)
	{
		printf("EOF RA2.txt\n") > sprintf("%s", error)
		exit
	}
	RA2_RAC = $1
	RA2_RAC_des = $2
	RA2_BB_Amt = $3
	RA2_CP_Deb = $4
	RA2_CP_Cre = $5
	RA2_EB_Amt = $6
}

function lee_RAC3()
{
	if(getline < sprintf("%s", entrada3) <= 0)
	{
		printf("EOF RA3.txt\n") > sprintf("%s", error)
		exit
	}
	RA3_RAC = $1
	RA3_RAC_des = $2
	RA3_BB_Amt = $3
	RA3_CP_Deb = $4
	RA3_CP_Cre = $5
	RA3_EB_Amt = $6
}

function anterior(T)
{
	if(T == "RAC1")
		RAC1_ant = RAC1_act;
	if(T == "RAC2")
		RAC2_ant = RAC2_act;
	if(T == "RAC3")
		RAC3_ant = RAC3_act;
	if(T == "RAC4")
		RAC4_ant = RAC4_act;
	if(T == "DAT")
		DAT_ant = DAT_act;
	if(T == "CTA")
		Reg_Acc = RAC;
	if(T == "FEC")
		Jou_Eff_Date_ant = Jou_Eff_Date;
}

function igual(T)
{
	if(T == "RAC1")
		if(RAC1_ant == RAC1_act)
			return 1
		else
			return 0
	if(T == "RAC2")
		if(RAC2_ant == RAC2_act)
			return 1
		else
			return 0
	if(T == "RAC3")
		if(RAC3_ant == RAC3_act)
			return 1
		else
			return 0
	if(T == "RAC4")
		if(RAC4_ant == RAC4_act)
			return 1
		else
			return 0
	if(T == "DAT")
		if(DAT_ant == DAT_act)
			return 1
		else
			return 0
	if(T == "FEC")
		if(Jou_Eff_Date_ant == Jou_Eff_Date)
			return 1
		else
			return 0
	if(T == "CTA")
		if(Reg_Acc == RAC)
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

function imprime_cuenta_saldos(n, c, d, sb, se)
{
	if(n == 1)
		com = "-0000-0000-0000"
	if(n == 2)
		com = "-0000-0000"
	if(n == 3)
		com = "-0000"
	if(n == 4)
		com = ""

	if(MAPP == 0){
		printf("&&\\textbf{%s}&\\multicolumn{3}{Q}{\\textbf{%s}}&&&&&&&&&&&\\\\\n\\cline{3-6}\n", MAP_CTA, MAP_CTA_des)
		MAPP=1
	}
	if(n <= 3)
		printf("&&%s%s&\\multicolumn{3}{Q}{%s}&&&&&&%s&&&&&%s\\\\\n\\cline{3-6}\\cline{12-12}\\cline{17-17}\n", c, com, general(d), moneda(sb), moneda(se))
	else
		printf("&&%s%s&\\multicolumn{3}{Q}{%s}&&&&&&%s&&&&&%s\\\\\n\n\\bottomrule", c, com, general(d), moneda(sb), moneda(se))
}

function obtiene_saldo(cuenta)
{
	if(cuenta == "RAC1")
	{
		while(RA1_RAC != RAC1_act) { lee_RAC1() }
		imprime_cuenta_saldos(1, RA1_RAC, RA1_RAC_des, RA1_BB_Amt, RA1_EB_Amt)
	}
	if(cuenta == "RAC2")
	{
		while(RA2_RAC != RAC2_act) { lee_RAC2() }
		imprime_cuenta_saldos(2, RA2_RAC, RA2_RAC_des, RA2_BB_Amt, RA2_EB_Amt)
	}
	if(cuenta == "RAC3")
	{
		while(RA3_RAC != RAC3_act) { lee_RAC3() }
		imprime_cuenta_saldos(3, RA3_RAC, RA3_RAC_des, RA3_BB_Amt, RA3_EB_Amt)
	}
	if(cuenta == "RAC4")
		imprime_cuenta_saldos(4, RAC, RA3_RAC_des, RAC_BB, RAC_EB)
}

function no_fin_RAC()
{
	if(fin_archivo_RAC == 1)
		return 1 #true
	else
		return 0 #false
}

function no_fin_RA1()
{
	if(fin_archivo_RA1 == 1)
		return 1 #true
	else
		return 0 #false
}

function no_fin_RA2()
{
	if(fin_archivo_RA2 == 1)
		return 1 #true
	else
		return 0 #false
}

function no_fin_RA3()
{
	if(fin_archivo_RA3 == 1)
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

#function cantidad(cadena)
#{
#	auxiliar = cadena
#	gsub(/"/, "", auxiliar)
#	gsub(/,/, ".", auxiliar)
#	return auxiliar
#}

function valida_monto(monto)
{
	if(monto !~ /^-*[0-9]+.[0-9][0-9]$/)
		if(monto !~ /^-*[0-9]+$/)
			if(monto !~ /^-*[0-9]+.[0-9]$/)
			{
				printf ("formato de monto incorrecto en el registro %d del archivo Asientos(4): %s\n", NR + 1, monto) > sprintf("%s", error)
				exit 1
			}
}

function descripcion(cadena)
{
	auxiliar = cadena
	gsub(/^"/, "", auxiliar)
	gsub(/"$/, "", auxiliar)
	gsub(/""/, "\"", auxiliar)
	return auxiliar
}

function valida_fecha(fecha)
{
	if(fecha !~ /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/)
	{
		printf ("fecha con formato erroneo en el registro %d del archivo RAC: %s\n", NR + 1, fecha) > sprintf("%s", error)
		exit 1
	}
}

function lee_registro_MOV()
{
	fin_archivo_MOV = getline < sprintf("%s", entrada4)

	if(no_fin_MOV())
	{
		Reg_Acc = $6
		Center = $14
		Journal_Name = descripcion($21)
		BatchID = $27
		Jou_Eff_Date = substr($36, 1, 10)
		Entered_Currency = $39

		valida_monto($57)
		valida_monto($58)
		valida_monto($59)
		valida_monto($60)
		valida_monto($61)
		valida_monto($62)

		Ent_Deb_Amt = $57
		Ent_Cre_Amt = $58
		Ent_Amount = $59
		Acc_Deb_Amt = $60
		Acc_Cre_Amt = $61
		Acc_Amount = $62
		Journal_Source_Code = $20
		Journal_Description = descripcion($26)
		valida_fecha(Jou_Eff_Date)

		cadena = sprintf("%s\t%s\t%s\t%s\t%s\t%s\n", substr(Reg_Acc, 1, 4), Jou_Eff_Date, Ent_Deb_Amt, Ent_Cre_Amt, Acc_Deb_Amt, Acc_Cre_Amt)
		if(NR == 1)
			printf(cadena) > sprintf("%s.auxiliar", entrada4)
		else
			printf(cadena) >> sprintf("%s.auxiliar", entrada4)
	}
}

function llena_campos_RAC()
{
	RAC = $1
	RAC1_act = substr(RAC, 1, 4)
	RAC2_act = substr(RAC, 1, 9)
	RAC3_act = substr(RAC, 1, 14)
	RAC4_act = $1
	RAC_des = $2
	MAP_CTA = $3
	MAP_CTA_des = $4
	RAC_BB = $5
	RAC_DB = $6
	RAC_CR = $7
	RAC_EB = $8
}

function lee_registro_RAC()
{
	fin_archivo_RAC = getline
	if(no_fin_RAC())
		llena_campos_RAC()
}

function inicializa_detalle()
{
	cont = 0
	Mov_Deb_Fec = 0.0
	Mov_Cre_Fec = 0.0
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

function imprime_detalle()
{
	printf("%s%s&%s&%s&%s&&%s&&%s&%s&%s&%s&&%s&%s&%s&%s&%s\\\\\n", tipo_renglon(), fecha(Jou_Eff_Date), BatchID, Reg_Acc, general(RAC_RAC_des), general(Journal_Name), general(Journal_Description), Journal_Source_Code, Center, Entered_Currency, moneda(Ent_Deb_Amt), moneda(Ent_Cre_Amt), moneda(Acc_Deb_Amt), moneda(Acc_Cre_Amt), moneda(Mov_EB))
	MAPP=0
}

function imprime_total_parcial(D, C)
{
	printf("\\toprule\\addlinespace[0.5mm]\\hhline{~~~~~~~~~~~~~~--~}&&&&&&&&&&&&\\multicolumn{2}{R}{\\textbf{Importe total de movimientos}}&\\cellcolor{gray!25}\\textbf{%s}&\\cellcolor{gray!25}\\textbf{%s}&\\\\\n\\hhline{~~~~~~~~~~~~~~--~}\n\\addlinespace[3mm]",  moneda(D), moneda(C))
}

function movimientos_cuenta()
{
	inicializa_detalle()
	Mov_BB = RAC_BB
	rc = 1
	while(Reg_Acc <= RAC && no_fin_MOV())
	{
		if(Reg_Acc == RAC)
		{
			Mov_Deb_Fec = Mov_Deb_Fec + Acc_Deb_Amt
			Mov_Cre_Fec = Mov_Cre_Fec + Acc_Cre_Amt

			Mov_EB = Mov_BB + Acc_Deb_Amt - Acc_Cre_Amt

			Mov_Deb_Fec_tot = Mov_Deb_Fec_tot + Acc_Deb_Amt
			Mov_Cre_Fec_tot = Mov_Cre_Fec_tot + Acc_Cre_Amt
			cont++
			imprime_detalle()

			Mov_BB = Mov_EB
		}
		lee_registro_MOV()
	}
	imprime_total_parcial(Mov_Deb_Fec, Mov_Cre_Fec)
	lee_registro_RAC()
}

function proceso_RAC4()
{
	obtiene_saldo("RAC4")
	anterior("RAC4")
	while(no_fin_RAC() && igual("RAC1") && igual("RAC2") && igual("RAC3") && igual("RAC4"))
		movimientos_cuenta()
}

function proceso_RAC3()
{
	obtiene_saldo("RAC3")
	anterior("RAC3")
	while(no_fin_RAC() && igual("RAC1") && igual("RAC2") && igual("RAC3"))
		proceso_RAC4()
}

function proceso_RAC2()
{
	obtiene_saldo("RAC2")
	anterior("RAC2")
	while(no_fin_RAC() && igual("RAC1") && igual("RAC2"))
		proceso_RAC3()
}

function proceso_RAC1()
{
	obtiene_saldo("RAC1")
	anterior("RAC1")
	while(no_fin_RAC() && igual("RAC1"))
		proceso_RAC2()
}

{
	llena_campos_RAC()
	if (NR == 1){
		lee_registro_MOV()
		Reg_Acc_ant = Reg_Acc
	}

	while(no_fin_RAC())
		proceso_RAC1()
}

END{
	printf("\\addlinespace[1mm]\\hhline{~~~~~~~~~~~~~~--}&&&&&&&&&&&&\\multicolumn{2}{R}{\\textbf{Gran Total del mes}}&\\cellcolor{gray!25}\\textbf{%s}&\\cellcolor{gray!25}\\textbf{%s}&\\\\\n\\hhline{~~~~~~~~~~~~~~--}\n",  moneda(Mov_Deb_Fec_tot), moneda(Mov_Cre_Fec_tot))
}

