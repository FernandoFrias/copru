function total(num)
{
	numa = gensub(/([0-9][0-9][0-9])$/, ",\\1", "g", sprintf("%d", num))
	numb = gensub(/([0-9][0-9][0-9]),([0-9][0-9][0-9])$/, ",\\1,\\2", "g", numa)
	numc = gensub(/([0-9][0-9][0-9]),([0-9][0-9][0-9]),([0-9][0-9][0-9])$/, ",\\1,\\2,\\3", "g", numb)
	gsub(/^,/,"", numc)
	return numc
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

function fecha(f)
{
	return sprintf("%02d-%02d-%4d", substr(f, 9, 2), substr(f, 6, 2), substr(f, 1, 4))
}

function general(d)
{
	ax = d
	gsub(/_/,"\\_",ax)
	gsub(/&/,"\\\\&",ax)
	gsub(/\$/,"\\$",ax)
	gsub(/´/,"'",ax)
	gsub(/¨/,"\"",ax)
	gsub(/%/,"\\%",ax)
	gsub(/°/,"$^o$",ax)
	gsub(/¥/,"Ñ",ax)
	gsub(/#/,"\\#",ax)
#	gsub(/ /,"\ ",ax)
	gsub(/ /,"\\ ",ax)
	gsub(/Ó/,"\\'O",ax)
	return ax
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

function valida_fecha(fecha)
{
	if(fecha !~ /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/)
	{
		printf "fecha con formato erroneo en el registro %d del archivo Asientos(5) %s", NR + 1, fecha
		exit 1
	}
}

function lee_campos()
{
# Asientos5.txt
	Reg_Acc = $6
	Reg_Acc_des = $9
	Center = $14
	Journal_Name = descripcion($21)
	BatchID = $27
	Jou_Eff_Date = substr($36, 1, 10)
	Entered_Currency = $39
	Line_Description = descripcion($38)
	Ent_Deb_Amt = cantidad($57)
	Ent_Cre_Amt = cantidad($58)
	Ent_Amount = cantidad($59)
	Acc_Deb_Amt = cantidad($60)
	Acc_Cre_Amt = cantidad($61)
	Acc_Amount = cantidad($62)
	Journal_Source_Code = $20
	Journal_Description = descripcion($26)
	valida_fecha(Jou_Eff_Date)
	MAP_CTA = descripcion($64)
	MAP_CTA_des = descripcion($65)
}

function lee_registro()
{
	fin_archivo = getline
	if(no_fin())
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
	if(X == "JED")
		JED_ant = Jou_Eff_Date;
	if(X == "BID")
		BID_ant = BatchID;
}

function igual(X)
{
	if(X == "JED")
		if(JED_ant == Jou_Eff_Date)
			return 1
		else
			return 0
	if(X == "BID")
		if(BID_ant == BatchID)
			return 1
		else
			return 0
}

function ini_vars(X)
{
	if(X == "BID")
	{
		BID_Deb = 0.0
		BID_Cre = 0.0
		BID_cnt = 0
	}	
	if(X == "ACC")
	{
		ACC_Deb = 0.0
		ACC_Cre = 0.0
		ACC_cnt = 0
	}	
}

function totales(X)
{
	if(X == "JED")
	{
		JED_Deb = JED_Deb + BID_Deb
		JED_Cre = JED_Cre + BID_Cre
#		++JED_cnt
		JED_cnt = JED_cnt + BID_cnt
	}
	if(X == "BID")
	{
		BID_Deb = BID_Deb + ACC_Deb
		BID_Cre = BID_Cre + ACC_Cre
#		++BID_cnt
		BID_cnt = BID_cnt + ACC_cnt
	}
	if(X == "ACC")
	{
		ACC_Deb = ACC_Deb + Acc_Deb_Amt
		ACC_Cre = ACC_Cre + Acc_Cre_Amt
		++ACC_cnt
	}
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

function linea_titulo()
{
	printf("&&&&&&&&&&&&\\\\\n\\bottomrule\n")
}

function linea_asiento(Jou_Eff_Date, Journal_Name, BatchID)
{
	col_A = sprintf("\\cellcolor{gray!35}\\textbf{\\sffamily{Fecha:} %s}", Jou_Eff_Date)
	col_B = sprintf("\\multicolumn{3}{L}{\\cellcolor{gray!35}\\textbf{\\sffamily{Origen:} %s}}", Journal_Name)
	col_D = sprintf("\\cellcolor{gray!35}")
	col_E = sprintf("\\cellcolor{gray!35}")
	col_F = sprintf("\\cellcolor{gray!35}")
	col_G = sprintf("\\cellcolor{gray!35}")
	col_H = sprintf("\\cellcolor{gray!35}")
	col_I = sprintf("\\cellcolor{gray!35}")
	col_J = sprintf("\\multicolumn{3}{K} \
					{\\cellcolor{gray!35}\\textbf{\\sffamily{Número de Asiento:} %s}} \
					\\\\\n\\toprule\n", BatchID)
	printf("%s&%s&%s&%s&%s&%s&%s&%s&%s", col_A, col_B, col_D, col_E, col_F, col_G, col_H, col_I, col_J)
}

function linea_detalle(Reg_Acc, Journal_Name, Line_Description, MAP_CTA, MAP_CTA_des, Journal_Source_Code, Center, Entered_Currency, Ent_Deb_Amt, Ent_Cre_Amt, Acc_Deb_Amt, Acc_Cre_Amt)
{
	col_A = sprintf("%s%s", tipo_renglon(), Reg_Acc)
	col_B = sprintf("%s", Journal_Name)
	col_D = sprintf("%s", Line_Description)
	col_E = sprintf("%s", MAP_CTA)
	col_F = sprintf("%s", MAP_CTA_des)
	col_G = sprintf("%s", Journal_Source_Code)
	col_H = sprintf("%s", Center)
	col_I = sprintf("%s", Entered_Currency)
	col_Ja = sprintf("%s", Ent_Deb_Amt)
	col_Jb = sprintf("%s", Ent_Cre_Amt)
	col_Jc = sprintf("%s", Acc_Deb_Amt)
	col_Jd = sprintf("%s\\\\\n", Acc_Cre_Amt)
	printf("%s&%s&&%s&%s&%s&%s&%s&%s&%s&%s&%s&%s", col_A, col_B, col_D, col_E, col_F, col_G, col_H, col_I, col_Ja, col_Jb, col_Jc, col_Jd)
}

function total_asiento(BID_ant, ACC_cnt, ACC_Deb, ACC_Cre)
{
	col_IJab = sprintf("\\multicolumn{3}{M}{\\cellcolor{gray!25}\\textbf{Total Asiento %s (%s movimientos):}}", BID_ant, ACC_cnt)
	col_Jc = sprintf("\\cellcolor{gray!25}\\textbf{%s}", ACC_Deb)
	col_Jd = sprintf("\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~~~~~-----}", ACC_Cre)
	printf("\\toprule&&&&&&&&%s&%s&%s", col_IJab, col_Jc, col_Jd)
}

function total_fecha(JED_ant, BID_cnt, BID_Deb, BID_Cre)
{
	col_Jc = sprintf("\\cellcolor{gray!25}\\textbf{%s}", BID_Deb)
	col_Jd = sprintf("\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~~~~~-----}", BID_Cre)
	printf("&&&&&&&&%s&%s&%s", col_IJab, col_Jc, col_Jd);
}

function total_general(JED_cnt, JED_Deb, JED_Cre)
{
	col_IJab = sprintf("\\multicolumn{3}{M}{\\cellcolor{gray!25}\\textbf{Gran Total (%s asientos):}}", JED_cnt)
	col_Jc = sprintf("\\cellcolor{gray!25}\\textbf{%s}", JED_Deb)
	col_Jd = sprintf("\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~~~~~-----}", JED_Cre)
	printf("&&&&&&&&%s&%s&%s", col_IJab, col_Jc, col_Jd)
}

function detalle(X)
{
	if(X == "ACC")
	{
		if(ACC_cnt == 0)
		{
			rc = 1
			if(NR > 1)
				linea_titulo()
			linea_asiento(fecha(Jou_Eff_Date), general(Journal_Name), BatchID)
		}
		linea_detalle(Reg_Acc, general(Journal_Name), general(Line_Description), MAP_CTA, MAP_CTA_des, Journal_Source_Code, Center, Entered_Currency, moneda(Ent_Deb_Amt), moneda(Ent_Cre_Amt), moneda(Acc_Deb_Amt), moneda(Acc_Cre_Amt))
	}
	if(X == "BID")
		total_asiento(BID_ant, total(ACC_cnt), moneda(ACC_Deb), moneda(ACC_Cre))
	if(X == "JED")
		total_fecha(fecha(JED_ant), total(BID_cnt), moneda(BID_Deb), moneda(BID_Cre))
}

function proceso_ACC()
{
	detalle(ACC)
	totales(ACC)
	lee_registro()
}

function proceso_BID()
{
	ini_vars(ACC)
	anterior(BID)
	while(no_fin() && igual(JED) && igual(BID))
		proceso_ACC()
	totales(BID)
	detalle(BID)
}

function proceso_JED()
{
	ini_vars(BID)
	anterior(JED)
	while(no_fin() && igual(JED))
		proceso_BID()
	totales(JED)
	detalle(JED)
}

BEGIN{
	FS="\t"
	JED = "JED"
	BID = "BID"
	ACC = "ACC"
	fin_archivo=1
}

{
	lee_campos()
	while(no_fin())
		proceso_JED()
}

END{
	total_general(total(JED_cnt), moneda(JED_Deb), moneda(JED_Cre))
}

