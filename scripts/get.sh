#!/bin/bash
source userhost.bash
source transcom.bash
source dirent.bash
dirent $*

if [[ -z $AMBSRC ]]; then
	aMAY="PR"
	aMIN="pr"
	asfx=""
	mdo=$1
else
	aMAY=$(may $1)
	aMIN=$(min $1)
	if [[ $1 == "PR" ]]; then
		asfx="_pr"
	else
		asfx="_$aMIN"
	fi
	mdo=$2
fi

if [[ $ORIGEN =~ (server) ]]; then
	if [[ $ORIGEN =~ (batch|dbparms|dbsrce|qcbllesrc|srce|data)$ ]]; then
		if [[ $ORIGEN =~ (dbsrce|srce)$ ]]; then
			ext="cbl"
		fi
		if [[ $ORIGEN =~ (batch)$ ]]; then
			ext="rexx"
		fi
		if [[ $ORIGEN =~ (qcbllesrc)$ ]]; then
			ext="cpy"
		fi
		if [[ $ORIGEN =~ (dbparms)$ ]]; then
			ext="sql"
		fi
#		if [[ $ORIGEN =~ (data)$ ]]; then
#			ext="dat"
#		fi
		marg=$(echo "I${aMAY}S660/"$(may $BASE).$(echo $mdo|cut -d'.' -f1) $(echo $mdo|cut -d'.' -f1)${asfx}.$ext)
		recibe400 $marg
	else
#		for nomarch in $HOME/sources/PR/$(may $BASE)/$1; do
#			if [[ -f $HOME/sources/PR/$(may $BASE)/$1 ]]; then
#				cp -v $nomarch $(pwd)
#			else
#				echo "el archivo ~/sources/PR/$(may $BASE)/$1 no existe"
#			fi
#		done
		echo "No Definido"
	fi
else
	src="/Pathfinder/${aMIN}/$(echo $ORIGEN|sed -e "s|WO/[0-9][0-9][0-9][0-9]/||g")"
	echo "buscando en /Pathfinder ..."
	spar="s/\./${asfx}\./g"
	script -qc "scp -q aix:$src/$mdo $(echo $mdo|sed -e ${spar})"
#	if [[ -n $res ]]; then
#		if [[ $(echo "$res" | grep "No such file or directory" | wc -l) -ge 1 ]]; then
#			echo "el archivo $1 no existe"
#		else
#			echo "archivo(s) $1 copiado(s)"
#		fi
#	fi
	if [[ -n typescript ]]; then
		cat typescript
	fi
	echo "archivo(s) $mdo copiado(s)"
	rm typescript
fi

