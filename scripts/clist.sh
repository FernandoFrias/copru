#!/bin/bash
source dirent.bash
dirent $*

listado(){
	orgnM=$(echo $origen)
	if [[ "$origen" != "qcbllesrc" ]]; then
		echo "procesando $orgnM's ..."
	fi

	ext=$(echo $(toma_expresion $origen)|cut -d'.' -f2|sed -e 's/\$//g')
	names="*.${ext}"
	listaX=$(find ../$origen/ -name $names|cut -d'/' -f3|cut -d'.' -f1)

	if [[ -n "$lista" ]]; then
		lst=$(echo $lista|sed -e 's/ /\\|/g')
		listaM=$(grep -w $lst ~/sources/PR/$orgnM/[!tags]*|cut -d'/' -f7|cut -d'.' -f1|sort|uniq)
	fi

	if [[ -n "$listaX" && -n "$listaM" ]]; then
		listaN=$(echo "$listaX"$'\n'"$listaM"|sort|uniq)
	else
		if [[ -n "$listaX" ]]; then
			listaN=$(echo "$listaX")
		else
			if [[ -n "$listaM" ]]; then
				listaN=$(echo "$listaM")
			fi
		fi
	fi

	return
}

despliega(){
	if [[ "$origen" != "batch" ]]; then
		listado
	else
		orgnM=$(echo $origen)
		echo "procesando $orgnM's ..."
	fi

	if [[ "$origen" != "qcbllesrc" ]]; then
		if [[ -n "$listaN" ]]; then
			if [[ $c -eq 0 ]]; then
				echo "/*****************************************************************/" >> $fname
				echo "/* THIS CL ALLOWS FOR MASS COMPILES OF SPECIFIED PROGRAMS        */" >> $fname
				echo "/* REPEAT LINE TO ADD MORE PROGRAMS                              */" >> $fname
				echo "/* REMEMBER TO COMPILE THE CL AFTER MAKING CHANGES (OPTION 14)   */" >> $fname
				echo "/* AFTER CL IS COMPILED, SUBMIT WITH OPTION 'C' (IT IS A CALL)   */" >> $fname
				echo "/*****************************************************************/" >> $fname
				echo "           PGM                                                     " >> $fname
				echo "            DCL VAR(&OBJLIB) TYPE(*CHAR) LEN(7) VALUE('IxxO660')   " >> $fname
			fi
			echo "$listaN"|
			while read linea; do
				echo "             ICOMP PGM($linea) SRCFILE($orgnM) OBJLIB(&OBJLIB)" >> $fname
			done
			c=$((c + 1))
		fi
	fi
	return
}

c=0
declare -u orgnM
fname="WO"$(pwd|cut -d'/' -f5)"CMP.rexx"
if [[ -f $fname ]]; then
	rm $fname
fi

qcbllesrc_DB=$(find ../qcbllesrc/ -type f|grep '(WZ\|FW\|FR\|PZ)'|cut -d'/' -f3|cut -d'.' -f1)
lista=$(echo "$qcbllesrc_DB")
origen="dbsrce"
despliega
if [[ -n "$listaN" ]]; then
	tot_dbsrce=$(echo "$listaN"|wc -l)
else
	tot_dbsrce=0
fi

lista=$(echo "$listaN")
origen="qcbllesrc"
despliega

lista=$(echo "$listaN")
origen="srce"
despliega
if [[ -n "$listaN" ]]; then
	tot_srce=$(echo "$listaN"|wc -l)
else
	tot_srce=0
fi

listaN=$(find ../batch/ -type f|cut -d'/' -f3|cut -d'.' -f1)
origen="batch"
despliega
if [[ -n "$listaN" ]]; then
	tot_batch=$(echo "$listaN"|wc -l)
else
	tot_batch=0
fi

if [[ $tot_dbsrce > 0 || $tot_srce > 0 || $tot_batch > 0 ]]; then
	echo "           ENDPGM                                                   " >> $fname
	echo "" >> $fname
	echo ""
	printf "DBSRCE's = %4d\n" $tot_dbsrce
	printf "SRCE's   = %4d\n" $tot_srce
	printf "BATCH's  = %4d\n" $tot_batch
	echo "----------------"
	printf "   Total = %4d\n" $((tot_batch + tot_dbsrce + tot_srce))
else
	echo "Sin dependencias"
fi

