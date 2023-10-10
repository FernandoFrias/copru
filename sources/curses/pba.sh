#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Uso: $(echo $(basename $0)|cut -d'/' -f2) programa"
	exit 1
fi

if [[ -e $1 ]]; then
	:
else
	echo "$1 no existe"
	exit 1
fi

if [[ -x $1 ]]; then
	:
else
	echo "$1 no es un programa ejecutable"
	exit 1
fi

xterm +sb +tb -fg orange -bg black -e $1
