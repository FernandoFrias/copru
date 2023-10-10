#!/bin/bash
source $HOME/scripts/dirent.bash
source $HOME/scripts/zencom.bash

function userpas
{
	local uspas=$HOME/scripts/data/uspas.txt
	if [[ -f $uspas ]]; then
		local user="IPR660BAT"
		local ppas=$(grep "${user}," $uspas|cut -d',' -f2)
		if [[ -z $ppas ]]; then
			enok "usuario $user no esta definido"
		else
			USUARIO=$(echo $user)
			PASS=$(echo $ppas)
		fi
	else
		enok "El archivo $uspas no existe"
	fi
}
userpas

x3270 -loginmacro "String($USUARIO) Tab() String($PASS) Enter() Title(\"x3270 antara - $USUARIO\")" antara &
