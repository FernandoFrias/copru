source $HOME/scripts/dirent.bash
source $HOME/scripts/userhost.bash
source $HOME/scripts/3270.bash

pnt_inicial_ok
elemento=$(toma_cadena)
if [[ -z "$elemento" ]]; then
	x3270if "Info(\"Debes de teclear el elemento en la linea de comandos\")"
	exit 1
fi

P660="S660"
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

#                   IDVS660   SRCE        CSBMM059
#	x3270if "Info(\"lib=$LIB, file=$FILE, mod=$modulo\")"

if [[ $(existe_mbr $LIB/$FILE $modulo) == "si" ]]; then
	:
else
	x3270if "Info(\"$LIB/$FILE.$modulo inexistente\")"
	x3270if "EraseEOF"
	exit 1
fi

#establece_tipo ${LIB} $FILE ${modulo}
if [[ $P660 == "U660" ]]; then
    stm="SBMJOB CMD(CRTCLPGM PGM(${LIB}/${modulo}) SRCFILE(${LIB}/$FILE) SRCMBR(${modulo})) JOB(${modulo}) LOG(4 *JOBD *SECLVL)"
else
	stm="ICOMP PGM(${modulo}) SRCFILE(${FILE}) OBJLIB(I${AMB}O660)"
fi

x3270if "String(\"$stm\")"
x3270if "Enter()"
x3270if "PauseScript"

