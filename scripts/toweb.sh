#!/bin/bash

function fecha_reporte
{
	fec=$(echo "$1"|sed -e 's/.\+Fecha:\ \{0,1\}\([0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]\)\ .\+/\1/g')
	dd=$(echo "$fec"|cut -d'/' -f1)
	mm=$(echo "$fec"|cut -d'/' -f2)
	ss=$(echo "$fec"|cut -d'/' -f3|cut -c 1-2)
	aa=$(echo "$fec"|cut -d'/' -f3|cut -c 3-4)
	echo ${dd}${mm}${aa}
}

function procesa_reporte
{
	parta=""
	partb=""
	linea=$(head -2 "$1"|tail -1)
	nomrepo=$(echo "$linea"|sed -e "s/^\ *\(CSBM[0-9A-Z][0-9][0-9][0-9]\).\+$/\1/g")

	if [[ $nomrepo == "CSBM0088" ]]; then
		lsdo=$(echo "$linea"|grep -l "$nomrepo\ \+Saldo")
		if [[ -n $lsdo ]]; then
			parta="${nomrepo}-1"
		fi
		lsdo=$(echo "$linea"|grep -l "$nomrepo\ \+Agente")
		if [[ -n $lsdo ]]; then
			parta="${nomrepo}-2"
		fi
	fi
#	if [[ "${nomrepo}-A" == "CSBM0212-A" ]]; then
#		parta="$nomrepo"
#	fi
	if [[ "${nomrepo}-B" == "CSBM0212-B" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM087" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBM0259" ]]; then
		lsdo=$(echo "$linea"|grep -l "$nomrepo\ \{32\}Extractos")
		if [[ -n $lsdo ]]; then
			parta="${nomrepo}-1"
		fi
		lsdo=$(echo "$linea"|grep -l "$nomrepo\ \{33\}Extractos")
		if [[ -n $lsdo ]]; then
			parta="${nomrepo}-2"
		fi
	fi
	if [[ $nomrepo == "CSBM0442" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBM2581" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBM3420" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBM7535" ]]; then
		lsdo=$(echo "$linea"|grep -l "${nomrepo}-O")
		if [[ -n $lsdo ]]; then
			parta="${nomrepo}-O"
		fi
		lsdo=$(echo "$linea"|grep -l "${nomrepo}-E")
		if [[ -n $lsdo ]]; then
			parta="${nomrepo}-E"
		fi
	fi
	if [[ $nomrepo == "CSBMM056" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM057" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM058" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM059" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM060" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM101" ]]; then
		parta="$nomrepo"
	fi
	if [[ $nomrepo == "CSBMM266" ]]; then
		parta="$nomrepo"
	fi


	if [[ -n $parta ]]; then
		partb=$(fecha_reporte "$linea")
		nomarch=${parta}_${partb}.html
	else
		nomarch=""
	fi
	
	echo $nomarch
}

fst="<meta http-equiv=\"Content-Type\" content=\"text\/html\; charset=utf-8\"\/>"
ini="<HTML><BODY><PRE>"
fin="</PRE></BODY></HTML>"

ex="CS[P,R][R,C,E][T,P,C][1,2,T][0-9][0-9][0-9][0-9][0-9][0-9].txt"

tot=$(ls $ex 2> /dev/null|wc -l)

if [[ $tot -gt 0 ]]; then
	for archivo in $ex; do
		iconv -f UTF-16 -t UTF-8 $archivo > auxiliar
		nom=$(procesa_reporte auxiliar)
		if [[ -n $nom ]]; then
			sed -e "1s/^/${fst}${ini}/g" auxiliar > $nom
			echo $fin >> $nom
			unix2dos -q $nom
			echo "archivo $nom generado"
		fi
		rm $archivo
	done
	if [[ -f auxiliar ]]; then
		rm auxiliar
	fi
else
	echo "No se encontraron archivos"
fi

