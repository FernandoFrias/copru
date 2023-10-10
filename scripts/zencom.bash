function tomausuario
{
	up=$(zenity --password --username 2> /dev/null)
	if [[ $? -eq 0  ]]; then
		local U=$(echo $up|cut -d'|' -f1)
		local P=$(echo $up|cut -d'|' -f2)
		if [[ -z $U ]]; then
			zenity --error --text="Usuario no informado" 2> /dev/null
			exit 1
		else
			if [[ -z $P ]]; then
				zenity --error --text="Password no informado" 2> /dev/null
				exit 1
			else
				USUARIO=$(echo $U)
				PASS=$(echo $P)
			fi
		fi
	else
		if [[ $? -eq 1  ]]; then
			:
		else
			zenity --error --text="$?" 2> /dev/null
		fi
		exit 1
	fi
}

function mensaje_w
{
	zenity --warning --text="$1" 2> /dev/null
}

function mensaje_e
{
	zenity --error --text="$1" 2> /dev/null
}

function mensaje_i
{
	zenity --info --text="$1" 2> /dev/null
}

function mensaje_q
{
	zenity --question --text="$1" 2> /dev/null
}

