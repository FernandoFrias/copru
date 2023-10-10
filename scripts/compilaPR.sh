#!/bin/bash
source $HOME/scripts/dirent.bash
source $HOME/scripts/userhost.bash
source $HOME/scripts/3270.bash
source $HOME/scripts/zencom.bash

pnt_inicial_ok
elemento=$(toma_cadena)
if [[ -z "$elemento" ]]; then
	x3270if "Info(\"Debes de teclear el elemento en la linea de comandos\")"
	exit 1
fi

#if [[ $(tipo_wo "$elemento") == "no" ]]; then
#	x3270if "Info(\"el nombre del elemento $elemento no esta dentro de los estandares\")"
#	x3270if "EraseEOF"
#	exit 1
#fi

useramb $(toma_usuario)
FILE="SRCE"
LIB="IPRS660"
modulo="${elemento}"

#if [[ $(existe_mbr $LIB/$FILE $modulo) == "no" ]]; then
if [[ $(existe_mbr $LIB/$FILE $modulo) == "si" ]]; then
	:
else
	x3270if "Info(\"$LIB/$FILE.$modulo inexistente\")"
	x3270if "EraseEOF"
	exit 1
fi

stm="ICOMP PGM(${modulo}) SRCLIB(IPRS660) SRCFILE(SRCE) OBJLIB(I${AMB}O660)"

x3270if "String(\"$stm\")"
x3270if "Enter()"
x3270if "PauseScript"

