source $HOME/scripts/dirent.bash
source $HOME/scripts/userhost.bash
source $HOME/scripts/3270.bash
#source $HOME/scripts/zencom.bash

pnt_inicial_ok
elemento=$(toma_cadena)
if [[ -z "$elemento" ]]; then
	x3270if "Info(\"Debes de teclear el elemento en la linea de comandos\")"
	exit 1
fi

P660="O660"
if [[ $(tipo_batch "$elemento") == "si" ]]; then
	FILE="BATCH"
else
	if [[ $(tipo_dbsrce "$elemento") == "si" ]]; then
		FILE="DBSRCE"
	else
		if [[ $(tipo_srce "$elemento") == "si" ]]; then
			FILE="SRCE"
		else
			if [[ $(tipo_wo "$elemento") == "si" ]]; then
				FILE="CNTL"
				P660="U660"
			else
				x3270if "Info(\"el nombre del elemento $elemento no esta dentro de los estandares\")"
				x3270if "EraseEOF"
				exit 1
			fi
		fi
	fi
fi

useramb $(toma_usuario)
LIB="I${AMB}${P660}"

if [[ $P660 == "U660" ]]; then
	modulo="WO${elemento}CMP"
else
	modulo="${elemento}"
fi

#if [[ $(existe_pgm $LIB $modulo) == "no" ]]; then
if [[ $(existe_pgm $LIB $modulo) == "si" ]]; then
	:
else
	x3270if "Info(\"$LIB.$modulo inexistente\")"
	x3270if "EraseEOF"
	exit 1
fi

if [[ $P660 == "U660" ]]; then
	stm="SBMJOB CMD(CALL PGM(I${AMB}U660/${modulo})) JOB(${modulo}) LOG(4 *JOBD *SECLVL)"
else
	stm="SBMJOB CMD(CALL PGM(${modulo})) JOB(${modulo}) LOG(4 *JOBD *SECLVL)"
fi

x3270if "String(\"$stm\")"
x3270if "Enter()"
x3270if "PauseScript"

