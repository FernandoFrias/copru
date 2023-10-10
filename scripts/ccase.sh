#!/bin/bash
source dirent.bash
dirent $*

function cpf
{
	fbase="/cygdrive/f"
	if [[ -d $fbase ]]; then
		destdir=$fbase/$(basename $(pwd))/INGENIUM
		if [[ -d $destdir ]]; then
			echo "borrando el directorio ~F/$(basename $(pwd)) ..."
			rm $destdir* -rfv 1> /dev/null 2> salida.txt
			if [[ $(cat salida.txt|wc -l) -gt 0 ]]; then
				cat salida.txt
				rm salida.txt
				exit 1
			fi
		fi
		mkdir -p $destdir
		lst=$(find presentation/ server/ webservices/ -type f)
	
		echo "$lst"|
		while read linea; do
			if [[ $(echo $linea|grep 'cntl\|dbparms/ALT\|server/copymir'|wc -l) -eq 0 ]]; then
				echo "copiando $linea ..."
				cp --parents $linea $destdir
				if [[ $(echo $linea|grep 'presentation'|wc -l) -eq 0 ]]; then
					if [[ $(echo $linea|grep 'dbsrce\|qcbllesrc\|srce'|wc -l) -le 0 ]]; then
						mv $destdir/$linea $destdir/$(echo $linea|cut -d'.' -f1)
					fi
				fi
			fi
		done
		echo "convirtiendo a formato DOS ..."
		find $destdir -type f -exec unix2dos -q {} \+
		echo "archivos copiados"
	else
		echo "el directorio destino $fbase no existe"
		exit 1
	fi
}

batf="$HOME/F/$WO/INGENIUM/ci.bat"
function ini_a
{
	echo "@echo off" > $batf
	echo "M:" >> $batf
	echo "cd \\INGENIUM_UT_xm731011_dview\\INGENIUM" >> $batf
}

function fin_a
{
	echo "F:" >> $batf
	echo "erase ci.bat" >> $batf
	echo "ejecutar ci.bat para hacer checkin a los elementos"
}

cpf
#exit 0

if [[ ! -d /cygdrive/M/INGENIUM_UT_xm731011_dview/INGENIUM ]]; then
	echo "no existe xm731011_dview/INGENIUM"
	exit 1
fi

mydir=$(pwd)
c=0
d=0
e=0
for nomarch in $(find $HOME/F/$WO/INGENIUM -type f); do
	trg=$(echo $nomarch|sed -e "s|F/$WO|M|g")
	if [[ -f $trg ]]; then
		if [[ $(diff -q $nomarch $trg|wc -l) -gt 0 ]]; then
			cd $(dirname $trg)
			bnm=$(basename $trg)
			log=$(cmd /c cleartool describe $bnm)
			if [[ $(echo "$log"|grep 'checked out'|wc -l) -gt 0 ]]; then
				echo $(basename $trg) ya esta en checkout
			else
				cmd /c cleartool co -c $WO $bnm
				echo "copiando $(basename $nomarch) ..."
				cp $nomarch $trg
				base[$c]=$(echo "$trg"|sed -e "s|$HOME/M/INGENIUM/||g")
				c=$((c + 1))
			fi
			cd $mydir
		else
			echo $(basename $nomarch) sin cambios
		fi
	else
		bs=$(echo "$trg"|sed -e "s|$HOME/M/INGENIUM/||g")
		mke[$d]=$(echo $bs)
		ori[$d]=$(echo $nomarch)
		des[$d]=$(echo $trg)
		cis[$e]=$(echo $(dirname $bs))
		e=$((e + 1))
		d=$((d + 1))
	fi
done

dc=$(for i in ${cis[*]}; do echo $i;done)
dco=$(echo "$dc"|sort|uniq)
if [[ -n $dco ]]; then
	cd $HOME/M/INGENIUM
	cmd /c cleartool co -c WO$WO $dco
	mkes=$(for i in ${mke[*]}; do echo $i;done)
	cont=0
	until [[ $cont -ge ${#mke[@]} ]];do
		echo "${ori[$cont]} -> ${des[$cont]}"
		cp ${ori[$cont]} ${des[$cont]}
		cont=$((cont + 1))
	done
	cd $mydir
fi

nomc=$(for i in ${base[*]}; do echo $i;done)
if [[ c -gt 0 || -n $dco ]]; then
	ini_a
	if [[ -n $nomc ]]; then
		echo "cleartool ci -c WO$WO" $nomc >> $batf
	fi
	if [[ -n $dco ]]; then
		echo "cleartool mkelem -c WO$WO" $mkes >> $batf
		echo "cleartool ci -c WO$WO" $mkes >> $batf
		echo "cleartool ci -c WO$WO" $dco >> $batf
	fi
	fin_a
fi

