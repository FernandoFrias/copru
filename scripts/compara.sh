#!/bin/bash

function readA
{
	if [[ $CA -gt $TA ]]; then
		FA='si'
		NA="ZZZZZZZZZZZ"
	else
		FA='no'
		NA=${A[$CA]}
		CA=$((CA + 1))
	fi
}

function readB
{
	if [[ $CB -gt $TB ]]; then
		FB='si'
		NB="ZZZZZZZZZZZ"
	else
		FB='no'
		NB=${B[$CB]}
		CB=$((CB + 1))
	fi
}

RUTA='/home/xm731011/sources/comp'
if [[ $(pwd) != $RUTA ]]; then
	echo "Debes estar en la ruta $RUTA"
	exit 1
fi

if [[ $# -ne 1 ]]; then
	echo "Uso: $(basename $0) nomdir"
	exit 1
fi

if [[ -d ../PR/$1 ]]; then
	:
else
	echo "El directorio $1 no existe en PR"
	exit 1
fi

if [[ -d ../CPR/$1 ]]; then
	:
else
	echo "El directorio $1 no existe en CPR"
	exit 1
fi

DIR=$1
DA=PR
DB=CPR

EA=$(ls ../$DA/$DIR)
EB=$(ls ../$DB/$DIR)

cont=0
for elemento in $EA; do
	cont=$((cont + 1))
	A[$cont]=$elemento
done
TA=$cont

cont=0
for elemento in $EB; do
	cont=$((cont + 1))
	B[$cont]=$elemento
done
TB=$cont

FA='no'
FB='no'
CA=1
CB=1
NA=''
NB=''
EFA=$DIR/faltantes_$DA.txt
EFB=$DIR/faltantes_$DB.txt

if [[ -f $EFA ]]; then
	rm $EFA
fi

if [[ -f $EFB ]]; then
	rm $EFB
fi

readA
readB
until [[ $FA == 'si' && $FB == 'si' ]]; do
	if [[ $NA == $NB ]]; then
		difers=$(diff -y --suppress-common-lines ../$DA/$DIR/$NA ../$DB/$DIR/$NB)
		if [[ -n $difers ]]; then
			echo "diferencias en el elemento $(basename $NA)"
			echo "$difers"|sed -e 's///g' > $DIR/$NA.txt
		else
			echo "Elemento $NA sin diferencias"
		fi
		readA
		readB
	else
		if [[ $NA > $NB ]]; then
			echo "El elemento $NB no existe en $DA"
			echo $NB >> $EFA
			readB
		else
			echo "El elemento $NA no existe en $DB"
			echo $NA >> $EFB
			readA
		fi
	fi
done

find . -name *txt -exec unix2dos {} \+ 2> /dev/null

