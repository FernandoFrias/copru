#!/bin/bash
source copycom.bash
source dirent.bash
dirent $*

raiz=$(pwd)
folders=$(echo $ARGS)
for folder in $folders; do
	defvars $raiz/$folder
	general 
	if [[ -n $ARGS ]]; then
		cd $raiz/$folder
		copia $ARGS
	fi
done

