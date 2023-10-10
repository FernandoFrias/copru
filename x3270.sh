#!/bin/bash

function login
{
	USER=$1
	if [[ "$USER" == "xm731011" ]]; then
		PASS=$(sed -n 2p $HOME/WO/uspas.txt)
	fi
	if [[ "$USER" == "IUT660" || "$user" == "IUT660BAT"  ]]; then
		PASS=$USER
	fi

	zenity --info --text="usuario:${USER}\npassword:${PASS}"

#	x3270if "String($USER)"
#	x3270if 'Tab()'
#	x3270if "String($PASS)"
#	x3270if "Enter()"

#	pt=$(x3270if 'Ascii(0,35,7)')
#	if [[ "$pt" == "Sign On" ]]; then
#		msg=$(x3270if 'Ascii(23,0,7)')
#		if [[ "CPF1108" == "$msg" ]]; then
#			cmd="Password erroneo"
#			x3270if "Info(\"$cmd\")"
#		fi
#		if [[ "CPF1120" == "$msg" ]]; then
#			cmd="Usuario inexistente"
#			x3270if "Info(\"$cmd\")"
#		fi
#	else
#		x3270if "Enter()"
#		msg=$(x3270if 'Ascii(3,40,12)')
#		if [[ "another job." == "$msg" ]]; then
#			x3270if "Enter()"
#			cmd="Ya existe una sesion activa"
#			x3270if "Info(\"$cmd\")"
#		else
#			msg=$(x3270if 'Ascii(0,1,4)')
#			if [[ "MAIN" != "$msg" ]]; then
#				cmd="Error"
#				x3270if "Info(\"$cmd\")"
#			else
#				msg=""
#			fi
#		fi
#	fi

#	if [[ -n $msg ]]; then
#		x3270if "Info(\"$msg\")"
#	else
#		titulo="${HOSTNAME}-${USER}"
#		x3270if "Title($titulo)"
#	fi

	return
}

function iniScript
{
	HOSTNAME='xertix'
	ip=/tmp/ip.$$
	op=/tmp/op.$$
	rm -f $ip $op
	mkfifo $ip $op
	x3270 -script -model 2 <$ip >$op &
	exec 5>$ip 6<$op
	rm -f $ip $op
	export X3270INPUT=5 X3270OUTPUT=6

	FILCON="$HOME/.conexiones"
	HostPort=$(grep $HOSTNAME $FILCON |sed -e "s/\t/\ /g"|cut -d' ' -f3)

	x3270if "Connect($HostPort)"
	x3270if "Wait(InputField)"
	login $1
	x3270if "PauseScript"
}

iniScript $1

