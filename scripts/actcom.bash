function sortcard
{
	mensaje "Transfiriendo STOREMIN"
	local STM=$HOME/scripts/data/STOREMIN
	if [[ $BASE =~ ^(DATA|PARM)$ ]]; then
		local la=$(grep 'Last Change Date' $STM|cut -d'=' -f2)
		local lb=$(grep 'Last Change Time' $STM|cut -d'=' -f2)
	else
		local la=$(grep 'Last Source Update' $STM|cut -d'=' -f2)
		local lb=$(grep 'Last Update Time' $STM|cut -d'=' -f2)
	fi
	sed -i "15s/\(FNC\)\ \([0-9][0-9][0-9]\)\ \([0-9][0-9][0-9]\)/\1\ $la/g" $STM
	sed -i "16s/\(FNC\)\ \([0-9][0-9][0-9]\)\ \([0-9][0-9][0-9]\)/\1\ $lb/g" $STM

	envia400x $STM I${AMB}S660/PARM.STOREMIN
	eok
}

function gendes
{
	mensaje "Generando descripciones"
	lanza "DLTF FILE(I${AMB}F660/STOREMIN)"
	lanza "CRTPF FILE(I${AMB}F660/STOREMINS) RCDLEN(22) FILETYPE(*DATA) SIZE(150000)"
	lanza "DSPFD FILE(IPRS660/${BASE}) TYPE(*MBR) OUTPUT(*OUTFILE) OUTFILE(I${AMB}F660/STOREMIN) OUTMBR(*FIRST)"
	lanza "FMTDTA INFILE(I${AMB}F660/STOREMIN) OUTFILE(I${AMB}F660/STOREMINS) SRCFILE(I${AMB}S660/PARM) SRCMBR(STOREMIN)"
	eok
}

function recdes
{
	mensaje "Recuperando descripciones"
	recibe400x I${AMB}F660/STOREMINS.STOREMINS $HOME/scripts/data/cambios/$BASE.dat
	eok
}

function eliaux
{
	mensaje "Eliminando auxiliares"
	lanza "RMVM FILE(I${AMB}S660/PARM) MBR(STOREMIN)"
	lanza "DLTF FILE(I${AMB}F660/STOREMINS)"
	lanza "DLTF FILE(I${AMB}F660/STOREMIN)"
	eok
}

function ordes
{
	mensaje "Ordenando descripciones"
	sort $HOME/scripts/data/cambios/$BASE.dat > $HOME/scripts/data/cambios/$BASE.txt
	sed -e "s/\([A-Z0-9 ]\{10\}\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)/\1,\2-\3-\4,\5:\6:\7/g" -e 's/\s\+//g' $HOME/scripts/data/cambios/$BASE.txt > $HOME/scripts/data/cambios/$BASE.dat
	rm $HOME/scripts/data/cambios/$BASE.txt
	eok
}

function desact
{
	if [[ -f $HOME/scripts/data/cambios/${BASE}_ant.dat ]]; then
		local difs=$(diff -y --suppress-common-lines $HOME/scripts/data/cambios/${BASE}.dat $HOME/scripts/data/cambios/${BASE}_ant.dat)
#		local eliminar=$(echo "$difs"|sed -n '/>/p' |cut -d'>' -f2|cut -d',' -f1|sed -e 's/^\( \|\t\)\+//g')
#		echo "$eliminar" > eli_${BASE}.txt
#		if [[ -n $eliminar ]]; then
#			rm -v $eliminar
#		fi
		local elementos="$(echo "$difs"|cut -d',' -f1)"
	else
		local elementos="$(cut -d',' -f1 $HOME/scripts/data/cambios/$BASE.dat)"
	fi

	if [[ -n $elementos  ]]; then
		echo "Descargando actualizaciones ($(echo "$elementos"|wc -l))"
		local sfx=$(sufix)
		recibe400 "$(echo "$elementos"|sed -e "s|^\([A-Z0-9]\+\)$|IPRS660/${BASE}.\1 \1${sfx}|g")"
		mv $HOME/scripts/data/cambios/${BASE}.dat $HOME/scripts/data/cambios/${BASE}_ant.dat
		mensaje "Generando tags"
		ctags --verbose=no -f $HOME/sources/PR/$BASE/.$BASE -R .
		eok
	else
		rm $HOME/scripts/data/cambios/${BASE}.dat
		echo "Sin Cambios"
	fi

	if [[ $BASE == 'SRCE' ]]; then
		:
	else
		echo ""
	fi
}

function actualiza
{
	sortcard
	conn
	sign_on
	borra_mensajes
	gendes
	recdes
	eliaux
	sign_off
	ordes
	desact
}

