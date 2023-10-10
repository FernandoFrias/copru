#!/bin/bash
source userhost.bash
source transcom.bash
source dirent.bash
dirent $*

mensaje "Inicia transferencia"
eok
raiz=$(pwd)
folders=$(echo $ARGS)
for folder in $folders; do
	defvars $raiz/$folder
	general 
	if [[ -n $ARGS ]]; then
		if [[ $RUTA =~ ^(server) ]]; then
			echo -n "Generando argumentos ftp $(may $BASE)"
			fgs=$(fargs)
			argus=$argus$(echo -e "${fgs}'\n'")
			echo '('$(echo "$fgs"|wc -l)')'
			if [[ $BASE =~ ^(copymir)$ ]]; then
				cd $raiz/$folder
				transfer $ARGS
			fi
		else
			cd $raiz/$folder
			transfer $ARGS
		fi
	fi
done

cd $raiz
envia400 "$(echo "$(echo "$argus"|sed -e "s|'||g")")"
mensaje "Termina transferencia"

#	if [[ $(grep "close" $HOME/WO/${WO}/sftpg3_${WO}.txt|wc -l) -eq 0 ]]; then
	if [[ -f $HOME/WO/${WO}/sftpg3_${WO}.txt ]]; then
		echo "close" >> $HOME/WO/${WO}/sftpg3_${WO}.txt
		echo "quit" >> $HOME/WO/${WO}/sftpg3_${WO}.txt
	fi

eok
