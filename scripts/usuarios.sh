#!/bin/bash
#source $HOME/scripts/userhost.bash
#source $HOME/scripts/3270.bash
#source $HOME/scripts/dirent.bash

uss=$(cut -d',' -f1 $HOME/scripts/data/uspas.txt|nl)
zenity --list --title="Selecciona Usuario" --text="Usuarios Disponibles" --print-column=2 --radiolist --column="Selección" --column="Usuario" $uss 2> /dev/null

