SCRIPT=$(basename $0|cut -d'.' -f1)
PF=/Pathfinder
if [[ -f $HOME/.conexiones ]]; then
	XERTIX=$(grep 'xertix' $HOME/.conexiones|cut -d$'\t' -f3)
	ANTARA=$(grep 'antara' $HOME/.conexiones|cut -d$'\t' -f3)
else
	echo "El archivo .conexiones no existe"
	exit 1
fi

function may
{
	echo "${1^^}"
}

function min
{
	echo "${1,,}"
}

function dirent
{
	valida_directorio
	valida_argumentos $*
}

function toma_expresion
{
#
	if [[ $# -eq 1 ]]; then
		OO=$(echo $ORIGEN)
		ORIGEN=$(echo $1)
	fi
#
	if [[ $ORIGEN =~ processdefs$ ]]; then
		if [[ $ORIGEN =~ presentation ]]; then
			echo '^[A-Z0-9a-z-]+\.(f|s|p|cfg)$'
		else
			echo '^[A-Z0-9a-z-]+\.f$'
		fi
	fi
	
	if [[ $ORIGEN =~ (english|spanish)$ ]]; then
		echo '^[A-Z0-9a-z-]+\.htm$'
	fi
	
	if [[ $ORIGEN =~ images$ ]]; then
		echo '^[0-9a-z_]+\.gif$'
	fi
	
	if [[ $ORIGEN =~ js$ ]]; then
		echo '^[0-9A-Za-z-]+\.js$'
	fi

	if [[ $ORIGEN =~ (batch|BATCH)$ ]]; then
		echo '^I[0,9,U][0-9][A-Z0-9]{4,5}\.rexx$'
	fi

	if [[ $ORIGEN =~ cntl$ ]]; then
#		echo "^WO$WO(CMP.rexx|SUPP.sql)$"
		if [[ $SCRIPT =~ (settype|settypeall) ]]; then
			echo "^WO$WO(CMP.rexx)$"
		else
			echo "^WO$WO(CMP.rexx|SUPP.sql)$"
		fi
	fi

	if [[ $ORIGEN =~ copymir$ ]]; then
		echo '^[CNSVX]CWM[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9].cpy$'
	fi

	if [[ $ORIGEN =~ (data|DATA)$ ]]; then
		echo '^I[0,9][0-9][A,D,E,O,P,Y][A-Z0-9]{3,5}$'
	fi

	if [[ $ORIGEN =~ (dbparms|DBPARMS)$ ]]; then
		echo '^(CRF|CRS|CRT|CRV|DFT|DLT|FIX|FKT|INI|ALT)[A-Z0-9]{2,6}.sql$'
	fi

	if [[ $ORIGEN =~ (/dbsrce|/DBSRCE|^dbsrce)$ ]]; then
		echo '^[C,N,S,V,X]S(DU|IA|IB|IC|ID|IF|IG|IK|IN|IT|IU|IV)[A-Z0-9]{2,4}.cbl$'
	fi

	if [[ $ORIGEN =~ (parm|PARM)$ ]]; then
		echo '^I0[0-9][C,M,R,S,U][0-9][0-9][0-9][0-9]$'
	fi

	if [[ $ORIGEN =~ (qcbllesrc|QCBLLESRC)$ ]]; then
		echo '^[C,F,N,S,V,X,Z][C,Q](CL|CP|FH|FR|FW|LC|PA|PB|PC|PD|PE|PF|PG|PK|PL|PN|PP|PS|PT|PU|PV|PX|PZ|SA|SD|SI|SL|SN|SO|SR|SS|SW|SX|WD|WE|WH|WK|WL|WM|WT|WW|WZ)[0-9A-Z]{2,4}.cpy$'
	fi

	if [[ $ORIGEN =~ (/srce|/SRCE|^srce)$ ]]; then
		echo '^[C,F,N,S,V,X,Z][C,S](BM|BU|DA|DC|DD|DF|DG|DH|DI|DK|DP|DR|DS|DT|DU|DV|DW|DX|DY|LF|LU|OM|RQ)[0-9A-Z]{2,5}.cbl$'
	fi

	if [[ $ORIGEN =~ send$ ]]; then
		echo "send"
	fi

	if [[ $ORIGEN =~ resp$ ]]; then
		echo "resp"
	fi

	if [[ $ORIGEN =~ WO$ ]]; then
		echo "WO"
	fi

	if [[ $ORIGEN =~ (WO/[0-9][0-9][0-9][0-9])$ ]]; then
		echo "WO 9999"
	fi

	if [[ $ORIGEN =~ PR$ ]]; then
		echo "PR"
	fi

#
	if [[ $# -eq 1 ]]; then
		ORIGEN=$(echo $OO)
	fi
#
}

function origen
{
	if [[ $(basename $0) =~ (inix3270) ]]; then
		echo "x"
	else
		echo "s"
	fi
}

function mensaje
{
	if [[ $(origen) == "x" ]]; then
		:
	else
		echo -n "${1}... "
	fi
}

function enok
{
	if [[ $(origen) == "x" ]]; then
		mensaje_e "$1"
	else
		cok='\033[1;31m'
		ccr='\033[1;34m'
		noc='\033[0m'
		echo -e "${ccr}[${cok}ERROR${ccr}]${noc}"
		echo "$1"
		if [[ -n $2 ]]; then
			echo "$2"
		fi
	fi
	exit 1
}

function nok
{
	if [[ $(origen) == "x" ]]; then
		:
	else
		cok='\033[1;31m'
		ccr='\033[1;34m'
		noc='\033[0m'
		echo -e "${ccr}[${cok}ERROR${ccr}]${noc}"
	fi
}

function eok
{
	if [[ $(origen) == "x" ]]; then
		:
	else
		cok='\033[1;32m'
		ccr='\033[1;34m'
		noc='\033[0m'
		echo -e "${ccr}[${cok}OK${ccr}]${noc}"
	fi
}

function valida_directorio
{
	mensaje "Validando directorio"

	local direcs=$(echo "$STRUC"|grep "\<$SCRIPT\>"|cut -d',' -f1)
	local totdirs=$(echo "$direcs"|wc -l)
	local contador=1
	local dirok=0
	while [[ $contador -le $totdirs ]]; do
		local dir=$(echo "$direcs"|sed -n "${contador},${contador} p")
		if [[ $(pwd) =~ ^$dir$ ]]; then
			dirok=1
			break
		fi
		contador=$((contador + 1))
	done
	if [[ $dirok -eq 0 ]]; then
		enok "Debes de estar en alguno de los siguientes directorios:" "$(echo "$direcs"|sed -e "s/\[0-9\]/#/g")"
	fi

	eok
}

function general
{
	local expres=$(toma_expresion)

	if [[ $# -eq 0 ]]; then
		ARGS=$(ls $HOME/$ORIGEN 2> /dev/null|egrep "$expres")
	else
		for arg in $*; do
			if [[ -f $arg ]]; then
				if [[ $arg =~ $expres ]]; then
					:
				else
					enok "Nombre de archivo no estandarizado: $arg"
				fi
			else
				enok "El archivo $arg no existe"
			fi
		done
		ARGS="$(echo $*|sed -e 's| |\n|g')"
	fi
}

function uso_struc
{
	enok "Uso: ${SCRIPT}.sh ####" "  #### = numero de Work Order"
}

function uso_get
{
	enok "Uso: ${SCRIPT}.sh [DV|UT|ST|MO|PR] componente"
}

function uso_expande
{
	enok "Uso: ${SCRIPT}.sh componente"
}

function uso_cprg
{
	enok "Uso: ${SCRIPT}.sh componente"
}

function uso_clist
{
	enok "Uso: ${SCRIPT}.sh"
}

function uso_scan_ren
{
	enok "Uso: ${SCRIPT}.sh" "  no se permiten argumentos"
}

function defvars
{
	ORIGEN=$(echo $1|sed -e "s|$HOME/||g")
	BASE=$(basename $ORIGEN)
	if [[ $ORIGEN =~ ^(sources|batch|WO$) ]]; then
		:
	else
		WO=$(echo $ORIGEN|cut -d'/' -f2)
		RUTA=$(echo $1|sed -e "s|$HOME/WO/$WO/*||g")
		LIB="I${AMB}S660/$(may $BASE)"
	fi
}

function sufix
{
	if [[ $BASE =~ ^(BATCH|DBPARMS|QCBLLESRC|DBSRCE|SRCE)$ ]]; then
		echo '.'$(echo $(toma_expresion)|cut -d'.' -f2|cut -d'$' -f1)
	else
		echo ""
	fi
}

function tipo_wo
{
	if [[ $1 =~ ^([0-9][0-9][0-9][0-9])$ ]]; then
		echo "si"
	else
		echo "no"
	fi
}

function tipo_file
{
	case $1 in
		BATCH|batch)
			echo "CLLE"
			;;
		CNTL|cntl)
			echo "CLP"
			;;
		SRCE|srce)
			if [[ $ORIGEN =~ (server)$ ]]; then
				rs=$(grep 'END-EXEC' ~/$ORIGEN/srce/$2.cbl)
			else
				rs=$(grep 'END-EXEC' ~/$ORIGEN/$2.cbl)
			fi
			if [[ -z $rs ]]; then
				echo "CBLLE"
			else
				echo "SQLCBLLE"
			fi
#			if [[ $2 =~ ^([A-Z][A-Z]BM.+)$ ]]; then
#				echo "SQLCBLLE"
#			else
#				echo "CBLLE"
#			fi
			;;
		DBSRCE|dbsrce)
			echo "SQLCBLLE"
			;;
	esac
}

function tipo_batch
{
	local exp=$(toma_expresion batch)
	local nom=$(echo $exp|sed -e 's/\\.rexx//g')
	if [[ $1 =~ $nom ]]; then
		echo "si"
	else
		echo "no"
	fi
}

function tipo_dbsrce
{
	local exp=$(toma_expresion dbsrce)
	local nom=$(echo $exp|sed -e 's/.cbl//g')
	if [[ $1 =~ $nom ]]; then
		echo "si"
	else
		echo "no"
	fi
}

function tipo_srce
{
	local exp=$(toma_expresion srce)
	local nom=$(echo $exp|sed -e 's/.cbl//g')
	if [[ $1 =~ $nom ]]; then
		echo "si"
	else
		echo "no"
	fi
}

function compilable_ok
{
	if [[ $(tipo_batch "$1") == "si" ]]; then
		echo "si"
	else
		if [[ $(tipo_dbsrce "$1") == "si" ]]; then
			echo "si"
		else
			if [[ $(tipo_srce "$1") == "si" ]]; then
				echo "si"
			else
				if [[ $(tipo_wo "$1") == "si" ]]; then
					echo "si"
				else
					echo "no"
				fi
			fi
		fi
	fi
}

function uso_hf
{
	enok "Uso: $(basename $0) xmlfile"
}


function valida_argumentos
{
	mensaje "Validando argumentos"

	defvars $(pwd)
	case $SCRIPT in
		"headlessflow")
				if [[ $# -ne 1 ]]; then
					uso_hf
				else
					if [[ -f $1 ]]; then
						:
					else
						enok "El archivo $1 no existe"
					fi
				fi
				;;
		"settypeall")
				if [[ $# -gt 0 ]]; then
					enok "no se permiten argumentos"
				else
					ARGS=$(ls cntl 2> /dev/null|egrep "$(toma_expresion cntl)"|sed -e 's|^|cntl/|g';ls dbsrce 2> /dev/null|egrep "$(toma_expresion dbsrce)"|sed -e 's|^|dbsrce/|g';ls batch 2> /dev/null|egrep "$(toma_expresion batch)"|sed -e 's|^|batch/|g';ls srce 2> /dev/null|egrep "$(toma_expresion srce)"|sed -e 's|^|srce/|g')
					if [[ -z $ARGS ]]; then
						enok "Sin archivos a procesar"
					fi
				fi
				;;
		"settype")
				general $*
				ARGS=$(echo "$ARGS"|sed -e "s|^|$BASE/|g")
				if [[ -z $ARGS ]]; then
					enok "Sin archivos a procesar"
				fi
				;;
		"actall")
				if [[ $# -gt 0 ]]; then
					enok "no se permiten argumentos"
				else
					ARGS=$(find [B,D,Q,S,P]* -type d)
				fi
				;;
		"act")
				if [[ $# -gt 0 ]]; then
					enok "no se permiten argumentos"
				fi
				;;
		"ccase")
				if [[ $# -gt 0 ]]; then
					enok "no se permiten argumentos"
				fi
				;;
#		"borra")
#				if [[ $# -gt 0 ]]; then
#					enok "no se permiten argumentos"
#				fi
#				;;
		"genzip")
				if [[ $# -gt 0 ]]; then
					enok "no se permiten argumentos"
				fi
				;;
		"ren")
				if [[ $# -gt 0 ]]; then
					enok "no se permiten argumentos"
				fi
				;;
		"cprg")
				if [[ $# -eq 1 ]]; then
					if [[ -f $1 ]]; then
						ARGS=$(echo $1)
					else
						enok "el archivo $1 no existe"
					fi
				else
					uso_cprg
				fi
				;;
		"check")
				general $*
				if [[ -z $ARGS ]]; then
					enok "Sin elementos a validar"
				fi
				;;
		"trans"|"copy")
				general $*
				if [[ -z $ARGS ]]; then
					enok "Sin archivos a transmitir"
				fi
				;;
		"copyall"|"transall"|"borra")
				if [[ $# -eq 0 ]]; then
					ARGS=$(echo "$STRUC"|grep "\<copy\>"|cut -d',' -f1|sed -e "s|$HOME/WO/\(\[0-9\]\)\{4\}/||g")
				else
					enok echo "no se permiten argumentos"
				fi
				;;
		"struc")
				if [[ $# -ne 1 ]]; then
					uso_struc
				else
					if [[ $1 =~ ^([0-9][0-9][0-9][0-9])$ ]]; then
						if [[ -d $1 ]]; then
							enok "el directorio $1 ya existe"
						fi
					else
						uso_struc
					fi
				fi
				;;
		"get")
				AMBSRC=""
				if [[ $# -ge 1 && $# -le 2 ]]; then
					if [[ $# -ne 1 ]]; then
						if [[ $1 =~ ^(DV|UT|ST|MO|PR)$ ]]; then
							AMBSRC=$1
						else
							uso_get
						fi
					fi
				else
					uso_get
				fi
				;;
		"clist")
				if [[ $# -ne 0 ]]; then
					uso_clist
				fi
				;;
		"expande")
				if [[ $# -ne 1 ]]; then
					uso_expande
				fi
				;;
		"scan"|"ren")
				if [[ $# -ne 0 ]]; then
					uso_scan_ren
				fi
				;;
	esac

	eok
}

