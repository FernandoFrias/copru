#!/bin/bash
source userhost.bash
source transcom.bash
source 3270.bash
source actcom.bash
source dirent.bash
dirent $*

for dir in $(echo "$ARGS"); do
	cd $HOME/sources/PR/$dir
	defvars $(pwd)
	echo "-> $BASE <-"
	actualiza
done

