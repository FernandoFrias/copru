function tipos
{
	for arg in $(echo "$ARGS"); do
		local mbr=$(echo $arg|cut -d'/' -f2|cut -d'.' -f1)
		if [[ -z $(echo $arg|grep '/') ]]; then
			local fil=$(may $(echo $LIB|cut -d'/' -f2))
		else
			local fil=$(may $(echo $arg|cut -d'/' -f1))
		fi
		if [[ $arg =~ (CMP.rexx)$ ]]; then
			local lib=I${AMB}U660
		else
			local lib=I${AMB}S660
		fi
#		if [[ $(existe_mbr $lib/$fil $mbr ) == 'no' ]]; then
#			echo "$lib/$fil.$mbr no existe"
#		else
#			tp=$(tipo_file $fil $mbr)
#			lanzam "CHGPFM (${lib}/${fil}) MBR(${mbr}) SRCTYPE(${tp})"
#		fi
		if [[ $(existe_mbr $lib/$fil $mbr ) == 'si' ]]; then
			tp=$(tipo_file $fil $mbr)
			lanzam "CHGPFM (${lib}/${fil}) MBR(${mbr}) SRCTYPE(${tp})"
		else
			echo "$lib/$fil.$mbr no existe"
		fi
	done
}

function settype
{
	if [[ -n $ARGS ]]; then
		conn
		sign_on
 		tipos
 		sign_off
	else
		echo "sin archivos a procesar en $BASE"
	fi
}

