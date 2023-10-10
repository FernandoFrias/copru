function desconexion
{
	x3270if "Disconnect"
	npid=$(ps|grep 3270|sed -e 's| \+| |g' -e 's|^\ *||g'|cut -d' ' -f1)
	kill -9 $npid
	wait $npid 2> /dev/null
}

function establece_tipo
{
	local tp=$(tipo_file $2 $3)
	local stm="CHGPFM (${1}/${2}) MBR(${3}) SRCTYPE(${tp})"
	x3270if "String(\"$stm\")"
	x3270if "Enter()"
}

function sign_off
{
	mensaje "Finalizando sesion"
	x3270if "String(90)"
	x3270if "Enter()"
	desconexion
	eok
}

function tipocntlm
{
	lanzam "CHGPFM (I${AMB}U660/CNTL) MBR($(echo ${1}|cut -d'.' -f1)) SRCTYPE(CLP)"
}

function tipolibm
{
	lanzam "UPDMBRLE SRCFILE($(may ${BASE}))"
}

function tipocntl
{
	lanza "CHGPFM (I${AMB}U660/CNTL) MBR($(echo ${1}|cut -d'.' -f1)) SRCTYPE(CLP)"
}

function tipolib
{
	lanza "UPDMBRLE SRCFILE($(may ${BASE}))"
}

function existe_file
{
	local com="CHKOBJ OBJ("$1") OBJTYPE(*FILE)"
	x3270if "String(\"$com\")"
	x3270if "Enter()"
	local msg=$(x3270if "Ascii(23,1,70)")
	x3270if "Home()"
	x3270if 'EraseEOF()'
	if [[ -z $(echo $msg|sed -e 's/\ //g') ]]; then
		echo "si"
	else
		echo "$msg"
	fi
}

function existe_mbr
{
	local com="CHKOBJ OBJ("$1") OBJTYPE(*FILE) MBR($2)"
	x3270if "String(\"$com\")"
	x3270if "Enter()"
	local msg=$(x3270if "Ascii(23,1,70)")
	x3270if "Home()"
	x3270if 'EraseEOF()'
#	if [[ $(echo "$msg"|grep 'not found'|wc -l) -eq 0 ]]; then
	if [[ -z $(echo $msg|sed -e 's/\ //g') ]]; then
		echo "si"
	else
#		echo "no"
		echo "$msg"
	fi
}

function existe_pgm
{
	local com="CHKOBJ OBJ(${1}/${2}) OBJTYPE(*PGM)"
	x3270if "String(\"$com\")"
	x3270if "Enter()"
	local msg=$(x3270if "Ascii(23,1,70)")
	x3270if "Home()"
	x3270if 'EraseEOF()'
#	if [[ $(echo "$msg"|grep 'not found'|wc -l) -eq 0 ]]; then
	if [[ -z $(echo $msg|sed -e 's/\ //g') ]]; then
		echo "si"
	else
#		echo "no"
		echo "$msg"
	fi
}

function lanzam
{
	mensaje "$1"
	x3270if "String(\"$1\")"
	x3270if "Enter()"
	x3270if "Wait(InputField)"
	eok
}

function lanza
{
	x3270if "String(\"$1\")"
	x3270if "Enter()"
	x3270if "Wait(InputField)"
}

function borra_mensajes
{
#	mensaje "borrando mensajes... "
	x3270if "String(DSPMSG)"
	x3270if "Enter()"
	x3270if "PF(13)"
	x3270if "Wait(InputField)"
	x3270if "Enter()"
#	eok
}

function type_user_pass
{
	x3270if "Home()"
	x3270if "String($1)"
	x3270if 'Tab()'
	x3270if "String($2)"
	x3270if "Enter()"
}

function toma_usuario
{
	x3270if "String(DSPWSUSR)"
	x3270if "Enter()"
	local user=$(x3270if 'Ascii(2,48,9)')
	local usr=$(echo $user|cut -d' ' -f1)
	x3270if "Enter()"
	echo $usr
}

function toma_cadena
{
	x3270if 'MoveCursor(24,1)'
	x3270if 'BackTab()'
	local campo=$(x3270if 'AsciiField')
	x3270if 'EraseEOF()'
	local cadena=$(echo "$campo"|sed -e 's/\s\+$//g')
	echo "$cadena"
}

function pnt_inicial
{
	local pt=$(x3270if 'Ascii(18,1,20)')
	if [[ "$pt" == "Selection or command" ]]; then
		echo "si"
	else
		echo "no"
	fi
}

function pnt_inicial_ok
{
	if [[ $(pnt_inicial) == "no" ]]; then
		x3270if "Info(\"Debes de estar en la pantalla principal\")"
		exit 1
	fi
}

function pnt_sign_on
{
	local pt=$(x3270if 'Ascii(0,35,7)')
	if [[ "$pt" == "Sign On" ]]; then
		echo "si"
	else
		echo "no"
	fi
}

function pnt_sign_on_ok
{
	if [[ $(pnt_sign_on) == "no" ]]; then
		x3270if "Info(\"Debes de estar en la pantalla de Sign On\")"
		exit 1
	fi
}

function valida_signon
{
	if [[ $(pnt_sign_on) == "si" ]]; then
		local msg=$(x3270if 'Ascii(23,0,79)')
		echo $(echo $msg|sed -e 's/\s\+$//g')
	else
		x3270if "Enter()"
		local msg=$(x3270if 'Ascii(3,40,12)')
		if [[ "another job." == "$msg" ]]; then
			x3270if "Enter()"
			echo "Error: ya existe una sesion activa"
		else
			local msg=$(x3270if 'Ascii(0,1,4)')
			if [[ "MAIN" != "$msg" ]]; then
				local msg=$(x3270if 'Ascii')
				echo "$msg"
			fi
		fi
	fi
}

function sign_on
{
	mensaje "Iniciando sesion"
	if [[ -z $USUARIO && -z $PASS ]]; then
		userpas
	fi
	type_user_pass $USUARIO $PASS
	local so=$(valida_signon)
	if [[ -n $so ]]; then
		x3270if "Disconnect"
		enok "$so"
	fi
	eok
}

function ini3270
{
	export USER=''
	local ip=/tmp/ip.$$
	local op=/tmp/op.$$
	rm -f $ip $op
	mkfifo $ip $op
	$(origen)3270 -script -model 2 <$ip >$op &
	exec 5>$ip 6<$op
	rm -f $ip $op
	export X3270INPUT=5 X3270OUTPUT=6
}

function conn
{
	local num=$(ps -a|grep 3270|wc -l)
	mensaje "conectando a $XERTIX"
	if [[ $num -ge 1 ]]; then
		enok "Ya existe una instancia en ejecucion"
	else
 		ini3270
		x3270if "Connect($XERTIX)"
		local conn=$(x3270if "Wait(InputField)")
		if [[ $conn == "Wait: Not connected" ]]; then
			enok "$conn"
		fi
		eok
	fi
}

