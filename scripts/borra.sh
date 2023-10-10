#!/bin/bash
source userhost.bash
source 3270.bash
source dirent.bash
dirent $*

function valida_delete
{
	rsp=$(existe_pgm $1 $2)
	if [[ $rsp == "si" ]]; then
		lanza "DLTPGM PGM($1/$2)"
		msg=$(x3270if "Ascii(23,1,70)")
		echo $msg
	else
		echo $rsp
	fi
}

function elimina_objeto
{
	if [[ $1 =~ (cntl) ]]; then
		if [[ $2 =~ (CMP) ]]; then
			t="U"
			valida_delete I${AMB}${t}660 $2
		fi
	else
		t="O"
		valida_delete I${AMB}${t}660 $2
	fi
}

function elimina_fuente
{
	if [[ $1 =~ (CNTL) ]]; then
		lib=$(echo $1|sed -e 's/S660/U660/g')
	else
		lib=$1
	fi

	rsp=$(existe_mbr $lib $2)
	if [[ $rsp == "si" ]]; then
		lanza "RMVM FILE(${lib}) MBR($2)"
		msg=$(x3270if "Ascii(23,1,70)")
		echo $msg
	else
		echo $rsp
	fi
}

function delAIX
{
	cmd="rm /Pathfinder/$(min $AMB)/$1/$2"
	echo -n $cmd

	ssh aix -q $cmd 2> salida.txt
	typs=$(cat salida.txt)
	rm salida.txt
	if [[ -n $typs ]]; then
		err=$(echo $typs|cut -d':' -f3)
		echo ".$err"
	else
		echo ". OK"
	fi
}

numsrv=0
raiz=$(pwd)
folders=$(echo $ARGS)
for folder in $folders; do
	defvars $raiz/$folder
	general 
	if [[ -n $ARGS ]]; then
		nf=$(echo $ARGS|gawk '{printf NF}')
		cont=1
		while [[ $cont -le $nf ]]; do
			if [[ $ORIGEN =~ (server) ]]; then
				numsrv=$((numsrv + 1))
				if [[ $numsrv -eq 1 ]]; then
					conn
					sign_on
				fi
				modulo=$(echo $ARGS|cut -d' ' -f$cont|cut -d'.' -f1)
				elimina_fuente $LIB $modulo
				if [[ $LIB =~ (COPYMIR) ]]; then
					delAIX server/qcbllesrc $modulo.cpy
				fi
				if [[ $LIB =~ (SRCE) ]]; then
					elimina_objeto $RUTA $modulo
				fi
			else
				modulo=$(echo $ARGS|cut -d' ' -f$cont)
				delAIX $RUTA $modulo
				if [[ $modulo =~ (eadless) ]]; then
					nrut=$(echo $RUTA|sed -e 's/presentation/webservices/g')
					delAIX $nrut $modulo
				fi
			fi
			cont=$((cont + 1))
		done
	fi
done
	
if [[ $numsrv -gt 0 ]]; then
	sign_off
fi

