#!/bin/bash
source $HOME/scripts/userhost.bash
source $HOME/scripts/3270.bash
source $HOME/scripts/zencom.bash

pnt_sign_on_ok

if [[ $# -eq 0 ]]; then
	tomausuario
else
	useramb $1
	userpas
fi

type_user_pass $USUARIO $PASS
x3270if "Title(\"x3270 xertix - $USUARIO\")"
x3270if "Enter()"

x3270if "PauseScript"

