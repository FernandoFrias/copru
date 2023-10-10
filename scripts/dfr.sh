#!/bin/bash

function may
{
	echo "${1^^}"
}

function min
{
	echo "${1,,}"
}

aMY=$(may $AMB)
aMN=$(min $AMB)
for modulo in *; do
	if [[ $modulo != dfr.sh ]]; then
		if [[ $modulo =~ difer_[a-z][a-z].txt ]]; then
			:
		else
			echo "buscando $modulo en $aMY"
			get.sh $aMY $modulo 1> /dev/null
			menv=$(echo $modulo|sed -e "s/\./_${aMN}\./g")
			if [[ -f $menv ]]; then
				echo "$menv copiado"
				diff -q $modulo $menv >> difer_${aMN}.txt
				rm $menv
				if [[ -f difer_${aMN}.txt ]]; then
					:
				else
					rm difer_${aMN}.txt
				fi
			else
				echo "$modulo no existe en $aMY"
			fi
		fi
	fi
done
