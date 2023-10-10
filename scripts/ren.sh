#!/bin/bash
source dirent.bash
dirent $*

bn=$(may $BASE)
for file in $bn.*; do
	if [[ -f $file ]]; then
		pr=$(echo $file|cut -d'.' -f1)
		if [[ "$pr" =~ ^(SRCE|DBSRCE)$ ]]; then
			ext=".cbl"
		fi
		if [[ "$pr" =~ ^(PARM|DATA)$ ]]; then
			ext=""
		fi
		if [[ "$pr" == "BATCH" ]]; then
			ext=".rexx"
		fi
		if [[ "$pr" == "DBPARMS" ]]; then
			ext=".sql"
		fi
		if [[ "$pr" == "QCBLLESRC" ]]; then
			ext=".cpy"
		fi
		nm=$(echo $file|cut -d'.' -f2)
		mv $file $nm$ext
	else
		echo "$file no existe"
	fi
done

