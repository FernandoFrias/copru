#!/bin/bash
source dirent.bash
dirent $*

mensaje "creando directorios"

direcs=$(echo "$STRUC"|grep "WO/"|cut -d',' -f1|sed -e "s|$HOME||g" -e "s|/WO/||g" -e "s|\[0-9\]\[0-9\]\[0-9\]\[0-9\]||g")
totdirs=$(echo "$direcs"|wc -l)
contador=1

while [[ $contador -le $totdirs ]]; do
	nomdir=$(echo "$direcs"|tail -$contador|head -1)
#	mkdir -p $1/Delivery$1/$nomdir
	mkdir -p $1/Delivery\ WO$1/$nomdir
	mkdir -p $1/$nomdir
	contador=$((contador + 1))
done
#rmdir $1/Delivery$1/server/cntl
rmdir $1/Delivery\ WO$1/server/cntl

eok

