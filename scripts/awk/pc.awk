#ordenar por:
#- Level 1 Regulatory Account
#- Level 2 Regulatory Account
#- Level 3 Regulatory Account
#- Level 0 Regulatory Account
BEGIN{
	FS="\t"
	RA1 = "RA1"
	RA2 = "RA2"
	RA3 = "RA3"
	RAC = "RAC"
	BAL = "BAL"
	fin_archivo=1
}

function valida_monto(monto)
{
#	if(monto !~ /-*[0-9]+.[0-9][0-9]/)
#		if(monto !~ /-*[0-9]+/)
#			if(monto !~ /-*[0-9]+.[0-9]/)
#			{
#				printf "formato de monto incorrecto en el registro %d del archivo Pesos(3): %s\n", NR + 1, monto
#				exit 1
#			}
	if(monto !~ /^-*[0-9]+.[0-9][0-9]$/)
		if(monto !~ /^-*[0-9]+$/)
			if(monto !~ /^-*[0-9]+.[0-9]$/)
			{
				printf "formato de monto incorrecto en el registro %d del archivo Pesos(3): %s\n", NR + 1, monto
				exit 1
			}
	if(monto !~ /[-,+]*[0-9]+(.[0-9][0-9])*/)
	{
		printf "formato de monto incorrecto en el registro %d del archivo Pesos(3): %s\n", NR + 1, monto
		exit 1
	}
}

function lee_campos()
{
	RA1_act = $12
	RA1_des = $13

	RA2_act = $10
	RA2_des = $11

	RA3_act = $8
	RA3_des = $9

	RAC_act = $6
	RAC_des = $7

	valida_monto($23)
	valida_monto($24)
	valida_monto($25)
	valida_monto($26)

	BB_Amt  = $23 + 0
	CP_Deb  = $24 + 0
	CP_Cre  = $25 + 0
	EB_Amt  = $26 + 0
}

function lee_registro()
{
	fin_archivo = getline
	lee_campos()
}

function no_fin()
{
	if(fin_archivo == 1)
		return 1 #true
	else
		return 0 #false
}

function anterior(X)
{
	if(X == "RA1")
	{
		RA1_ant = RA1_act;
		RA1_des_ant = RA1_des;
	}
	if(X == "RA2")
	{
		RA2_ant = RA2_act;
		RA2_des_ant = RA2_des;
	}
	if(X == "RA3")
	{
		RA3_ant = RA3_act;
		RA3_des_ant = RA3_des;
	}
	if(X == "RAC")
	{
		RAC_ant = RAC_act;
		RAC_des_ant = RAC_des;
	}
}

function iguala_anterior()
{
	anterior(RA1)
	anterior(RA2)
	anterior(RA3)
	anterior(RAC)
}

function igual(X)
{
	if(X == "RA1")
		if(RA1_ant == RA1_act)
			return 1
		else
			return 0
	if(X == "RA2")
		if(RA2_ant == RA2_act)
			return 1
		else
			return 0
	if(X == "RA3")
		if(RA3_ant == RA3_act)
			return 1
		else
			return 0
	if(X == "RAC")
		if(RAC_ant == RAC_act)
			return 1
		else
			return 0
	if(X == "F")
		if(F_ant == F_act)
			return 1
		else
			return 0
}

function iniRA1()
{
	RA1_BB_Amt = 0.0
	RA1_CP_Deb = 0.0
	RA1_CP_Cre = 0.0
	RA1_EB_Amt = 0.0
}

function ini_vars(X)
{
	if(X == "RA1")
	{
		RA1_BB_Amt = 0.0
		RA1_CP_Deb = 0.0
		RA1_CP_Cre = 0.0
		RA1_EB_Amt = 0.0
	}	
	if(X == "RA2")
	{
		RA2_BB_Amt = 0.0
		RA2_CP_Deb = 0.0
		RA2_CP_Cre = 0.0
		RA2_EB_Amt = 0.0
	}	
	if(X == "RA3")
	{
		RA3_BB_Amt = 0.0
		RA3_CP_Deb = 0.0
		RA3_CP_Cre = 0.0
		RA3_EB_Amt = 0.0
	}	
	if(X == "RAC")
	{
		RAC_BB_Amt = 0.0
		RAC_CP_Deb = 0.0
		RAC_CP_Cre = 0.0
		RAC_EB_Amt = 0.0
	}	
	if(X == "BAL")
	{
		BAL_BB_Amt = 0.0
		BAL_CP_Deb = 0.0
		BAL_CP_Cre = 0.0
		BAL_EB_Amt = 0.0
	}	
}

function totales(X)
{
	if(X == "RA1")
	{
		RA1_BB_Amt = RA1_BB_Amt + RA2_BB_Amt
		RA1_CP_Deb = RA1_CP_Deb + RA2_CP_Deb
		RA1_CP_Cre = RA1_CP_Cre + RA2_CP_Cre
		RA1_EB_Amt = RA1_EB_Amt + RA2_EB_Amt
	}
	if(X == "RA2")
	{
		RA2_BB_Amt = RA2_BB_Amt + RA3_BB_Amt
		RA2_CP_Deb = RA2_CP_Deb + RA3_CP_Deb
		RA2_CP_Cre = RA2_CP_Cre + RA3_CP_Cre
		RA2_EB_Amt = RA2_EB_Amt + RA3_EB_Amt
	}
	if(X == "RA3")
	{
		RA3_BB_Amt = RA3_BB_Amt + RAC_BB_Amt
		RA3_CP_Deb = RA3_CP_Deb + RAC_CP_Deb
		RA3_CP_Cre = RA3_CP_Cre + RAC_CP_Cre
		RA3_EB_Amt = RA3_EB_Amt + RAC_EB_Amt
	}
	if(X == "RAC")
	{
		RAC_BB_Amt = RAC_BB_Amt + BAL_BB_Amt
		RAC_CP_Deb = RAC_CP_Deb + BAL_CP_Deb
		RAC_CP_Cre = RAC_CP_Cre + BAL_CP_Cre
		RAC_EB_Amt = RAC_EB_Amt + BAL_EB_Amt
	}
	if(X == "BAL")
	{
		BAL_BB_Amt = BAL_BB_Amt + BB_Amt
		BAL_CP_Deb = BAL_CP_Deb + CP_Deb
		BAL_CP_Cre = BAL_CP_Cre + CP_Cre
		BAL_EB_Amt = BAL_EB_Amt + EB_Amt
	}
}

function formato(num)
{
	return sprintf("%f", num)
}

function saldos_ceros(I, D, C, F)
{
	if(I == 0.0 && D == 0.0 && C == 0.0 && F == 0.0)
		return 1
	else
		return 0
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

function imprime_saldos(A, B, I, D, C, F, N)
{
	tolerancia = 1
	oper = I + D - C
	if(oper > F)
		difer = oper - F
	else
		difer = F - oper

	if(difer > tolerancia)
	{
		printf "monto no coincide, cuenta:%s %s, calculado = %s, reportado = %s, diferencia = %s", A, B, moneda(oper), moneda(F), moneda(difer)
		exit 1
	}

	reg = sprintf("%s\t%s\t%s\t%s\t%s\t%s\n", A, B, formato(I), formato(D), formato(C), formato(F))
	printf(reg) > N".txt"
}

function detalle(X)
{
	if(X == "RAC")
		if(saldos_ceros(BAL_BB_Amt, BAL_CP_Deb, BAL_CP_Cre, BAL_EB_Amt) == 0)
			imprime_saldos(RAC_ant, RAC_des_ant, BAL_BB_Amt, BAL_CP_Deb, BAL_CP_Cre, BAL_EB_Amt, X)
	if(X == "RA3")
		if(saldos_ceros(RAC_BB_Amt, RAC_CP_Deb, RAC_CP_Cre, RAC_EB_Amt) == 0)
			imprime_saldos(substr(RA3_ant, 1, 14), RA3_des_ant, RAC_BB_Amt, RAC_CP_Deb, RAC_CP_Cre, RAC_EB_Amt, X)
	if(X == "RA2")
		if(saldos_ceros(RA3_BB_Amt, RA3_CP_Deb, RA3_CP_Cre, RA3_EB_Amt) == 0)
			imprime_saldos(substr(RA2_ant, 1, 9), RA2_des_ant, RA3_BB_Amt, RA3_CP_Deb, RA3_CP_Cre, RA3_EB_Amt, X)
	if(X == "RA1")
		if(saldos_ceros(RA2_BB_Amt, RA2_CP_Deb, RA2_CP_Cre, RA2_EB_Amt) == 0)
			imprime_saldos(substr(RA1_ant, 1, 4), RA1_des_ant, RA2_BB_Amt, RA2_CP_Deb, RA2_CP_Cre, RA2_EB_Amt, X)
}

function proceso_BAL()
{
	totales(BAL)
	lee_registro()
}

function proceso_RAC()
{
	ini_vars(BAL)
	while(no_fin() && igual(RA1) && igual(RA2) && igual(RA3) && igual(RAC))
		proceso_BAL()
	totales(RAC)
	detalle(RAC)
	anterior(RAC)
}

function proceso_RA3()
{
	ini_vars(RAC)
	while(no_fin() && igual(RA1) && igual(RA2) && igual(RA3))
		proceso_RAC()
	totales(RA3)
	detalle(RA3)
	anterior(RA3)
}

function proceso_RA2()
{
	ini_vars(RA3)
	while(no_fin() && igual(RA1) && igual(RA2))
		proceso_RA3()
	totales(RA2)
	detalle(RA2)
	anterior(RA2)
}

function proceso_RA1()
{
	ini_vars(RA2)
	while(no_fin() && igual(RA1))
		proceso_RA2()
	totales(RA1)
	detalle(RA1)
	anterior(RA1)
}

{
	lee_campos()
	iguala_anterior()
	while(no_fin())
		proceso_RA1()
	totales(FIN)
}

END{
}

