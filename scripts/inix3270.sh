#!/bin/bash
source $HOME/scripts/userhost.bash
source $HOME/scripts/3270.bash
source $HOME/scripts/dirent.bash
source $HOME/scripts/zencom.bash

if [[ $# -eq 0 ]]; then
	tomausuario
else
	useramb $1
fi
conn
sign_on
x3270if "Title(\"x3270 xertix - $USUARIO\")"
x3270if "PauseScript"

