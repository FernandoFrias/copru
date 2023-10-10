#!/bin/bash

if [[ $# -eq 0 ]]; then
	echo "uso: $(basename $0) [nomarch]"
	exit 1
fi

if [[ -f $1 ]]; then
	if [[ "$(echo $1|sed -e 's/^.\+\(\.txt\)$/\1/g')" == ".txt" ]]; then
		:
	else
		echo "El nombre de archivo '$1' es incorrecto"
		exit 1
	fi
else
	echo "El archivo '$1' no existe"
	exit 1
fi

if [[ $(file -b $1) =~ ^(ASCII text)$ ]]; then
	:
else
	echo "El archivo '$1' no es de tipo texto"
	exit 1
fi

nomarch=$1
nomard=$(echo $nomarch|sed -e 's/^\(.\+\)\(\.txt\)$/\1/g').dat
if [[ -f $nomard ]]; then
	rm $nomard
fi
totalines=$(wc -l $nomarch|cut -d' ' -f1)
numline=1
numfld=1
te=0
tn=0
ta=0
tb=0
tt=0
#
# 01 contador de campos
# 02 contador tipo de campo
# 03 numero de fila
# 04 alto
# 05 numero de columna
# 06 longitud
# 07 tipo de campo:
#    - entero            0
#    - alfanumerico1 (*) 1
#    - alfanumerico2 (X) 2
#    - alfabetico    (#) 3
#    - numerico          4
#    - etiqueta          5
# 08 signado
# 09 decimales
# 10 etiqueta
#
until [[ $numline -gt $totalines ]]; do
	linefield=$(head -$numline $nomarch|tail -1|grep -bo '\S\+'|sed -e 's/:/|/')
	if [[ -n $linefield ]]; then
		for occurs in $linefield; do
			ini=$(echo $occurs|cut -d'|' -f1)
			ini=$((ini + 1))
			fld=$(echo $occurs|cut -d'|' -f2)
			lng=${#fld}
			signado=0
			decs=0
			if [[ $fld =~ ^((-|\+|)9+(\.|)9+)$ || $fld =~ ^((-|\+|)9+)$ ]]; then
				if [[ $fld =~ ^((-|\+|)9+)$ ]]; then
					tipo=0 #entero
					te=$((te + 1))
					cont=$te
				else
					tipo=4 #numerico
					tn=$((tn + 1))
					cont=$tn
					decp=$(echo $fld|sed -e 's/-\?9\+\.\(9\+\)/\1/g')
					decs=${#decp}
				fi
				if [[ "$(echo $fld|cut -c 1-1)" = "-" ]]; then
					signado=1
				fi
			else
				if [[ $fld =~ ^(\*+)$ ]]; then
					tipo=1 #alfanumerico1
					ta=$((ta + 1))
					cont=$ta
				else
					if [[ $fld =~ ^(\#+)$ ]]; then
						tipo=3 #alfabetico
						tb=$((tb + 1))
						cont=$tb
					else
						if [[ $fld =~ ^(\X+)$ ]]; then
							tipo=2 #alfanumerico2
							ta=$((ta + 1))
							cont=$ta
  					    else
							tipo=5 #etiqueta
							tt=$((tt + 1))
							cont=$tt
						fi
					fi
				fi
			fi
#			printf "%02d,%02d,%02d,%02d,%02d,%-45s,%c,%1s,%1d\n" "$numfld" "$cont" "$numline" "$ini" "$lng" "$fld" "$tipo" "$signado" "$decs" >> $nomard
			printf "%02d,%02d,%02d,%02d,%02d,%1d,%1d,%1d,%s\n" "$numfld" "$cont" "$numline" "$ini" "$lng" "$tipo" "$signado" "$decs" "$fld" >> $nomard
			numfld=$((numfld + 1))
		done
	fi
	numline=$((numline + 1))
done

# ordenar por: columna, longitud, fila
sed -n '/^\([0-9][0-9],\)\{5\}2/p' $nomard|sort -t',' -k4,4 -k5,5 -k3,3|cut -d',' -f3,4,5|sed -e 's/\([0-9][0-9]\),\([0-9][0-9]\),\([0-9][0-9]\)/\2\3,\1/g' > aux
#mv aux $nomard
#lant=$(head -1 $nomard|cut -d',' -f5,3,4)
#cat $nomard|
#while read linea; do
#	lact=$(head -1 $nomard|cut -d',' -f5,3,4)
#done
