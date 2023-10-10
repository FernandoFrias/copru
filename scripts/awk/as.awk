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

function lee_campos()
{
# Asientos8.txt
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
	MAP_CTA = descripcion($64)
	MAP_CTA_des = descripcion($65)

	Vendor_Name = descripcion($48)
	Policy_Number = descripcion($49)
	Payment_Receipt_Number = descripcion($50)
	RFC_Code = descripcion($51)
	Amount = descripcion($52)
	UUID = descripcion($53)
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
	if(X == "BID")
		BID_ant = BatchID;
}

function igual(X)
{
	if(X == "BID")
		if(BID_ant == BatchID)
			return 1
		else
			return 0
}

function ini_vars(X)
{
	if(X == "ACC")
	{
		ACC_Deb = 0.0
		ACC_Cre = 0.0
		ACC_cnt = 0
	}	
}

function totales(X)
{
	if(X == "BID")
	{
		BID_Deb = BID_Deb + ACC_Deb
		BID_Cre = BID_Cre + ACC_Cre
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

function linea_asiento(Jou_Eff_Date, Journal_Description, BatchID)
{
	linea0 = "\\begin{longtable}{ABsDEFGHIJJJJ}"
	linea1 = sprintf("\\titulos{%s}{%s}{%s}", Jou_Eff_Date, Journal_Description, BatchID)
	printf("%s", linea0)
	printf("%s", linea1)
}

function linea_detalle(Reg_Acc, Journal_Name, Line_Description, MAP_CTA, MAP_CTA_des, Journal_Source_Code, Center, Entered_Currency, Ent_Deb_Amt, Ent_Cre_Amt, Acc_Deb_Amt, Acc_Cre_Amt, Vendor_Name, Policy_Number, Payment_Receipt_Number, RFC_Code, Amount, UUID)
{
	col_A = sprintf("%s%s", tipo_renglon(), Reg_Acc)
	col_B = sprintf("%s", general(Journal_Name))
	col_D = sprintf("%s", general(Line_Description))
	col_E = sprintf("%s", general(MAP_CTA))
	col_F = sprintf("%s", general(MAP_CTA_des))
	col_G = sprintf("%s", Journal_Source_Code)
	col_H = sprintf("%s", Center)
	col_I = sprintf("%s", Entered_Currency)
	col_Ja = sprintf("%s", Ent_Deb_Amt)
	col_Jb = sprintf("%s", Ent_Cre_Amt)
	col_Jc = sprintf("%s", Acc_Deb_Amt)
	col_Jd = sprintf("%s", Acc_Cre_Amt)
	printf("%s&%s&&%s&%s&%s&%s&%s&%s&%s&%s&%s&%s\\\\\n", col_A, col_B, col_D, col_E, col_F, col_G, col_H, col_I, col_Ja, col_Jb, col_Jc, col_Jd)

	reg_salida = sprintf("%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s\n",\
					Jou_Eff_Date,\
					Journal_Description,\
					BatchID,\
					Reg_Acc,\
					Journal_Name,\
					Line_Description,\
					MAP_CTA,\
					MAP_CTA_des,\
					Journal_Source_Code,\
					Center,\
					Entered_Currency,\
					Ent_Deb_Amt,\
					Ent_Cre_Amt,\
					Acc_Deb_Amt,\
					Acc_Cre_Amt,\
					Vendor_Name,\
					Policy_Number,\
					Payment_Receipt_Number,\
					RFC_Code,\
					Amount,\
					UUID)

	if (cnt_regs == 0)
		printf("%s", cabecera) > "polizas.txt"

	printf("%s", reg_salida) >> "polizas.txt"
	++cnt_regs
}

function total_lote(BID_ant, ACC_cnt, ACC_Deb, ACC_Cre)
{
	printf("\\toprule\\addlinespace[0.5mm]")
	col_I = sprintf("\\multicolumn{3}{M}{\\cellcolor{gray!25}\\textbf{Total de registros del lote %s : %s}}", BID_ant, ACC_cnt)
	col_Jc = sprintf("\\cellcolor{gray!25}\\textbf{%s}", ACC_Deb)
	col_Jd = sprintf("\\cellcolor{gray!25}\\textbf{%s}\\\\\n\\hhline{~~~~~~~~-----}", ACC_Cre)
	printf("\\hhline{~~~~~~~~-----}\n&&&&&&&&%s&%s&%s", col_I, col_Jc, col_Jd)
	printf("\\end{longtable}")
}

function detalle(X)
{
	if(X == "ACC")
	{
		if(ACC_cnt == 0)
		{
			rc = 1
			linea_asiento(fecha(Jou_Eff_Date), general(Journal_Description), BatchID)

		}
		linea_detalle(Reg_Acc, Journal_Name, Line_Description, MAP_CTA, MAP_CTA_des, Journal_Source_Code, Center, Entered_Currency, moneda(Ent_Deb_Amt), moneda(Ent_Cre_Amt), moneda(Acc_Deb_Amt), moneda(Acc_Cre_Amt), Vendor_Name, Policy_Number, Payment_Receipt_Number, RFC_Code, moneda(Amount), UUID)
	}
	if(X == "BID")
	{
		total_lote(BID_ant, total(ACC_cnt), moneda(ACC_Deb), moneda(ACC_Cre))
		if(tr != NR)
			printf("\\newpage")
	}
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
	while(no_fin() && igual(BID))
		proceso_ACC()
	totales(BID)
	detalle(BID)
}

BEGIN{
	FS="\t"
	BID = "BID"
	ACC = "ACC"
	fin_archivo=1
	cabecera = sprintf("%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s<>%s\n",\
					"Fecha",\
					"Origen",\
					"Numero de Asiento",\
					"Cuenta Regulatoria",\
					"Nombre del asiento",\
					"Descripcion del asiento",\
					"Cuenta CUSF",\
					"Nombre De La Cuenta CUSF",\
					"Fuente",\
					"Centro de costos",\
					"Moneda",\
					"Debitos M.O.",\
					"Creditos M.O.",\
					"Debitos M.N.",\
					"Creditos M.N.",\
					"Nombre del proveedor",\
					"Numero de Poliza",\
					"Recibo de pago",\
					"RFC",\
					"Amount",\
					"UUID")

	cnt_regs = 0
}

{
	lee_campos()
	while(no_fin())
		proceso_BID()
}

