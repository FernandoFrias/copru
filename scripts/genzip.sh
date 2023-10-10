#!/bin/bash
source copycom.bash
source dirent.bash
dirent $*

raiz=$(pwd)
folders=$(echo $(echo "$STRUC"|grep "\<copy\>"|cut -d',' -f1|sed -e "s|$HOME/WO/\(\[0-9\]\)\{4\}/||g"))
for folder in $folders; do
	defvars $raiz/$folder
	general 
	if [[ -n $ARGS ]]; then
		cd $raiz/$folder
		copia $ARGS
	fi
done

cp $HOME/WO/$WO/ftp_${WO}.txt $HOME/WO/$WO/Delivery\ WO$WO

cd $raiz
bp="/cygdrive/c/Users/$(echo $HOME|sed -e 's|/home/||g')/Mis documentos/"
fp=$(echo "$(ls -ld ~/Documentos/[0-9][0-9][0-9]*|sed -e 's/\ \+/\ /g'|grep -v 'zip'|grep RCQPR0000${WO}$|cut -d '/' -f5)")
if [[ -z $fp ]]; then
	echo "no existe el directorio ${bp}XXXX - RCQPR0000${WO}"
	exit 1
fi
if [[ -d "${bp}${fp}" ]]; then
	if [[ -f "${bp}${fp}"/Delivery\ WO$WO.zip ]]; then
		rm "${bp}${fp}"/Delivery\ WO$WO.zip
	fi
#	zip "${bp}${fp}"/Delivery\ WO$WO.zip Delivery${WO}* -r
	zip "${bp}${fp}"/Delivery\ WO$WO.zip Delivery\ WO${WO}* -r
	if [[ -d CNTL ]]; then
		zip "${bp}${fp}"/CNTL.zip CNTL* -r
	fi
#	if [[ -f server/cntl/WO${WO}SUPP.sql ]]; then
#		cp server/cntl/WO${WO}SUPP.sql "${bp}${fp}"
#	fi
else
	echo "no existe el directorio ${bp}${fp}"
fi


