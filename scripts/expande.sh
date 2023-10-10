#!/bin/bash
source dirent.bash
dirent $*

ab()
{
	rep=$(echo "$linea"|sed -ne '/BY/p'|wc -l|sed -e 's/\ //g')
	if [[ "$rep" = "1" ]]; then
		ab=$(echo $linea|sed -e "s/BY/|/g;s/\.//g;s/'//g")
		pa=$(echo $ab|cut -d'|' -f1)
		pb=$(echo $ab|cut -d'|' -f2)
		a=$(echo $pa|gawk '{print $NF}'|sed -e 's/=//g')
		b=$(echo $pb|sed -e 's/=//g')
		if [[ "$occ" = "1" ]];then
			sd="sed -e \"s/$a/$b/g\""
		else
			sd="$sd|sed -e \"s/$a/$b/g\""
		fi
	fi
}

excpy()
{
	cpys="1"

	cpystr="cat $copys/$mycpy"
	if [[ "$sd" != "" ]]; then
		sdx=$(echo $sd|sed -e 's/\$/\\$/g')
		cpystr="$cpystr|$sdx"
	fi

	echo "expandiendo copy $cpy ..."
	if [[ "$cpys" == 0 ]]; then
#		echo "      * --> inicia copy $cpy <--" >> $destino
		eval $cpystr >> $destino
#		echo "      * --> termina copy $cpy <--" >> $destino
	else
#		echo "      * --> inicia copy $cpy <--" >> $destino
		fnx=$(eval $cpystr|gawk -v cpx=$cpy '{
			spc=""
			rs = 71 - length($0)
			for(cnt=0; cnt<=rs; ++cnt)
				spc=sprintf("%s ", spc)
			printf("%s%s %s\n", $0, spc, cpx)
		}')
		echo "$fnx" >> $destino
#		echo "      * --> termina copy $cpy <--" >> $destino
	fi
}
sources=$HOME/sources
ruta=$sources/PR
rutaexp=$sources/PRexp
copys=$ruta/QCBLLESRC
rutaDBSRCE=$ruta/DBSRCE
rutaSRCE=$ruta/SRCE

bn=$(basename $1)
dn=$(dirname $1)
pw=$(pwd)
bnx=$(basename $pw)

if [[ "$rutaDBSRCE" = "$pw" || "$rutaSRCE" = "$pw" ]]; then
	ori=$pw/$bn
else
	ori=$ruta/$bnx/$bn
fi

if [[ -f $ori ]]; then
	origen="$ori"
	destino=$rutaexp/$bnx/$bn
else
	origen="$ori".cbl
	if [[ -f $origen ]]; then
		destino="$rutaexp/$bnx/$bn".cbl
	else
		echo "El archivo \"$ori""[.cbl]\" no existe"
		exit 1
	fi
fi

if [[ -f $destino ]]; then
	rm $destino
fi
touch $destino

numlinea_contenido=$(grep -n "^.\{6\}\ COPY" $origen)
total_lineas=$(echo "$numlinea_contenido"|wc -l)
total_lineas_archivo=$(cat $origen|wc -l)
contador=1
anterior=1

numlineas=$(echo "$numlinea_contenido"|cut -d':' -f1)
contenidos=$(echo "$numlinea_contenido"|sed -e 's/^[0-9]*://g')

until [[ "$contador" -gt "$total_lineas" ]];do
	numero=$(echo "$numlineas"|sed -ne "$contador p")
	linea=$(echo "$contenidos"|sed -ne "$contador p")
	cpy=$(echo "$linea"|cut -c8-|sed -e 's/\./\ /g'|cut -d' ' -f2)

	endpoint=$(echo "$linea"|sed -n '/\./p'|wc -l|sed -e 's/\ //g')
	occ=1
	sd=""
	until [[ "$endpoint" = "1" ]]; do
		ab
		numaux=$((numero + occ))
		linea=$(sed -ne "$numaux p" $origen)
		endpoint=$(echo "$linea"|sed -n '/\./p'|wc -l|sed -e 's/\ //g')
		occ=$((occ + 1))
	done
	ab

	i=$(echo $anterior|sed -e 's/\ //g')
	f=$(echo $((numero + occ - 1))|sed -e 's/\ //g')
	sed -n "$i,$f p" $origen >> $destino

#	orgn=$(sed -n "$i,$f p" $origen)
#	sed -n "$i,$f p" $origen|grep -n "COPY"|cut -d':' -f1
	
	cpyq=$(echo $cpy|cut -c1)
	if [[ "$cpyq" = "Q" ]]; then
		echo "copy $cpy no expandida"
	else
		if [[ -f "$copys/$cpy" ]]; then
			mycpy="$cpy"
			excpy
		else
			mycpy="$cpy".cpy
			if [[ -f "$copys/$mycpy" ]]; then
				excpy
			else
				echo "copy $cpy no existe"
			fi
		fi
	fi

	anterior=$((numero + occ))
	contador=$((contador + 1))
done
i=$(echo $anterior|sed -e 's/\ //g')
f=$(echo $total_lineas_archivo|sed -e 's/\ //g')
sed -n "$i,$f p" $origen >> $destino
dos2unix -q $destino

