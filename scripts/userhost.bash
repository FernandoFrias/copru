function useramb
{
	case $1 in
		"xm731011"|"XM731011")
			export AMB='DV'
			;;
		"xm730323"|"XM730323")
			export AMB='DVX'
			;;
		"IUT660")
			export AMB='UT'
			;;
		"IUT660BAT")
			export AMB='UTB'
			;;
		"IST660")
			export AMB='ST'
			;;
		"IMO660")
			export AMB='MO'
			;;
		"IPR660")
			export AMB='PR'
			;;
		*)
			enok "Usuario \"$1\" desconocido"
			;;
	esac
}

function getuser
{
	case $AMB in
		"DV")
			echo "XM731011"
			;;
		"DVX")
			echo "XM730323"
			;;
		"UT")
			echo "IUT660"
			;;
		"UTB")
			echo "IUT660BAT"
			;;
		"ST")
			echo "IST660"
			;;
		"MO")
			echo "IMO660"
			;;
		"PR"|"pr")
			echo "IPR660"
			;;
	esac
}

function userpas
{
	local uspas=$HOME/scripts/data/uspas.txt
	if [[ -f $uspas ]]; then
		local user=$(getuser)
		local ppas=$(grep "${user}," $uspas|cut -d',' -f2)
		if [[ -z $ppas ]]; then
			echo "usuario $user no esta definido"
			exit 1
		else
			USUARIO=$(echo $user)
			PASS=$(echo $ppas)
		fi
	else
		echo "El archivo $uspas no existe"
		exit 1
	fi
}

