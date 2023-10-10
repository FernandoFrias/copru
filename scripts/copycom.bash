function rep
{
	if [[ -d "$2" ]]; then
		echo -e "$1 \t-> $(echo $2/$3|sed -e "s|$HOME|~|g" -e "s|WO/||g" -e "s|/$WO/|/|g")"
		cp $1 "$2"/$3
		if [[ "$2" =~ (Delivery\ WO) ]]; then
			dos2unix "$2"/$3 2> /dev/null
		fi
	else
		echo "El directorio $2 no existe"
		exit 1
	fi
}

function copia
{
	for componente in $*; do
		if [[ $RUTA =~ ^(presentation) ]]; then
			RT=$(echo $RUTA|sed -e "s/presentation/presentationDV/g")
			rep $componente $HOME/WO/$WO/Delivery\ WO$WO/$RUTA $componente
			rep $componente $HOME/D/$RT $componente
		fi
		if [[ $RUTA =~ ^(webservices) ]]; then
			rep $componente $HOME/WO/$WO/Delivery\ WO$WO/$RUTA $componente
		fi
		if [[ $RUTA =~ ^(server) ]]; then
			if [[ $BASE =~ ^(cntl)$ ]]; then
				rep $componente $HOME/WO/$WO/Delivery\ WO$WO $(echo $componente|sed -e 's/rexx/txt/g')
			fi
			if [[ $BASE =~ ^(copymir)$ ]]; then
				rep $componente $HOME/WO/$WO/Delivery\ WO$WO/server/copymir $componente
				rep $componente $HOME/D/wb/server/qcbllesrc $componente
			fi
			if [[ $BASE =~ ^(qcbllesrc)$ ]]; then
				rep $componente $HOME/WO/$WO/Delivery\ WO$WO/$RUTA $(may $BASE).$(echo $componente|cut -d'.' -f1)
				ex=$(toma_expresion 'copymir')
				if [[ $componente =~ $ex ]]; then
					rep $componente $HOME/WO/$WO/Delivery\ WO$WO/server/copymir $componente
					rep $componente $HOME/WO/$WO/server/copymir $componente
					rep $componente $HOME/D/wb/server/qcbllesrc $componente
				fi
			fi
			if [[ $BASE =~ ^(dbparms)$ ]]; then
				if [[ $componente =~ ^(ALT) ]]; then
					mkdir -p $HOME/WO/$WO/CNTL
					rep $componente $HOME/WO/$WO/CNTL $componente
				else
					rep $componente $HOME/WO/$WO/Delivery\ WO$WO/$RUTA $(may $BASE).$(echo $componente|cut -d'.' -f1)
				fi
			fi
			if [[ $BASE =~ ^(batch|dbsrce|srce)$ ]]; then
				rep $componente $HOME/WO/$WO/Delivery\ WO$WO/$RUTA $(may $BASE).$(echo $componente|cut -d'.' -f1)
			fi
			if [[ $BASE =~ ^(data|parm)$ ]]; then
				rep $componente $HOME/WO/$WO/Delivery\ WO$WO/$RUTA $componente
			fi
		fi
	done
}

