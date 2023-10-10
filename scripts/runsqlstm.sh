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

if [[ $(tipo_wo "$elemento") == "no" ]]; then
	x3270if "Info(\"el nombre del elemento $elemento no esta dentro de los estandares\")"
	x3270if "EraseEOF"
	exit 1
fi

useramb $(toma_usuario)
FILE="CNTL"
LIB="I${AMB}U660"
modulo="WO${elemento}SUPP"

#if [[ $(existe_mbr $LIB/$FILE $modulo) == "no" ]]; then
if [[ $(existe_mbr $LIB/$FILE $modulo) == "si" ]]; then
	:
else
	x3270if "Info(\"$LIB/$FILE.$modulo inexistente\")"
	x3270if "EraseEOF"
	exit 1
fi

stm="SBMJOB CMD(RUNSQLSTM SRCFILE(${LIB}/${FILE}) SRCMBR(${modulo})) JOB(${modulo}) LOG(4 *JOBD *SECLVL)"

x3270if "String(\"$stm\")"
x3270if "Enter()"
x3270if "PauseScript"

