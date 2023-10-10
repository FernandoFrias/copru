#!/bin/bash
#source $HOME/scripts/userhost.bash
#source $HOME/scripts/3270.bash
#source $HOME/scripts/dirent.bash

set -x
nums=$(ls $HOME/WO/[0-9][0-9][0-9][0-9] -d|sed -e "s|$HOME/WO/||g"|nl|sed -e 's/\(\ \|\t\)\+/\ /g' -e 's/^\ //g')
echo "nums = $nums"
zenity --list --title="Work Order" --text="Disponibles" --hide-header --print-column=2 --radiolist --column="Selección" --column="Numero" $nums 2> /dev/null

