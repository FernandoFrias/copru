function fargs
{
	if [[ $BASE =~ ^(data|parm)$ ]]; then
		local ftpargs=$(echo "$ARGS"|sed -e "s|^\([0-9A-Z]\+\)$|\1 ${LIB}.\1|g")
	else
		if [[ $BASE =~ ^(cntl)$ ]]; then
			local ftpargs=$(echo "$ARGS"|sed -e "s|^\([A-Z0-9]\+\)\.\(.\+\)$|\1.\2 $(echo $LIB|sed -e 's/S660/U660/g').\1|g")
		else
			local ftpargs=$(echo "$ARGS"|sed -e "s|^\([A-Z0-9]\+\)\.\(.\+\)$|\1.\2 ${LIB}.\1|g")
		fi
	fi

#	if [[ $(basename $0) == "trans.sh" ]]; then
	if [[ $(basename $0) =~ (trans.sh|cprg.sh) ]]; then
		echo "$ftpargs"
	else
		echo "$ftpargs"|sed -e "s|^|$RUTA/|g"
	fi
}

function trans400a
{
	userpas
	sed -e "s/HOST/$XERTIX/g" -e "s/USUARIO/$USUARIO/g" -e "s/PASS/$PASS/g" $HOME/scripts/data/ta.txt > $HOME/scripts/transfer.txt
}

function trans400ax
{
	userpas
	sed -e "s/HOST/$XERTIX/g" -e "s/USUARIO/$USUARIO/g" -e "s/PASS/$PASS/g" $HOME/scripts/data/tax.txt > $HOME/scripts/transfer.txt
}

function resprest
{
	local mb=$(echo $AMB|cut -c 1-2)
	local fls=$(egrep $(toma_expresion 'cntl'|sed -e 's/\(\^\|\$\)//g') transfer.sh|cut -d' ' -f2)
	for f in $(echo "$fls"); do
		if [[ $1 -eq 1 ]]; then
			cp $f ${f}.resp
			sed -i "s/I[x,X][x,X]\([A-Z]660\)/I${mb}\1/g" $f
		fi
		if [[ $1 -eq 2 ]]; then
			mv ${f}.resp $f
		fi
	done
}

function genFTPw
{
	if [[ $(basename $0) == "transall.sh" ]]; then
		echo "open "${XERTIX} > ftp_${WO}.txt
		echo "usuario" >> ftp_${WO}.txt
		echo "password" >> ftp_${WO}.txt
		grep "^\(get\|put\)" transfer.sh >> ftp_${WO}.txt
		sed -i "s/\ I\($AMB\)/\ Ixx/g" ftp_${WO}.txt
		sed -i "s/\.56\./\.5x\./g" ftp_${WO}.txt

		ini="put\ server\/"
		lbm="batch\|dbparms\|dbsrce\|qcbllesrc\|srce"
		lbM="BATCH\|DBPARMS\|DBSRCE\|QCBLLESRC\|SRCE"
		sed -i "s/${ini}\(${lbm}\)\/\([a-zA-Z0-9\.]\+\)\ \([a-zA-Z0-9]\+\)\/\(${lbM}\)\.\([A-Z0-9]\+\)/${ini}\1\/\4\.\5\ \3\/\4\.\5/g" ftp_${WO}.txt
		sed -i "s/server\/cntl\///g" ftp_${WO}.txt
		sed -i "s/rexx/txt/g" ftp_${WO}.txt

		echo "quit" >> ftp_${WO}.txt

		unix2dos -q ftp_${WO}.txt
	fi
}

function etrans
{
	resprest 1
	chmod u+x transfer.sh
  	transfer.sh|grep -v 'quote\|quit'
	resprest 2
	genFTPw
  	rm transfer.sh
}

function trans400b
{
	sed -n '1,$p' $HOME/scripts/data/tb.txt >> $HOME/scripts/transfer.txt
	mv $HOME/scripts/transfer.txt transfer.sh
	etrans
}

function trans400bx
{
	sed -n '1,$p' $HOME/scripts/data/tbx.txt >> $HOME/scripts/transfer.txt
	mv $HOME/scripts/transfer.txt transfer.sh
	etrans
}

function recibe400
{
	echo "<-- AS/400($XERTIX)"
	trans400a
	echo "$*"|sed -e 's|^|get |g' >> $HOME/scripts/transfer.txt
	trans400b
}

function recibe400x
{
	trans400ax
	echo "$*"|sed -e 's|^|get |g' >> $HOME/scripts/transfer.txt
	trans400bx
}

function recibe400m
{
	echo "<-- AS/400($XERTIX)"
	trans400a
	echo "$*"|sed -e 's|^|get |g' >> $HOME/scripts/transfer.txt
	trans400b
}

function envia400
{
	trans400a
	echo "$*"|sed -e 's|^|put |g' >> $HOME/scripts/transfer.txt
	trans400b
}

function envia400x
{
	trans400ax
	echo "$*"|sed -e 's|^|put |g' >> $HOME/scripts/transfer.txt
	trans400bx
}

function envia400m
{
	echo "--> AS/400($XERTIX)"
	trans400a
	echo "$*"|sed -e 's|^|put |g' >> $HOME/scripts/transfer.txt
	trans400b
}

function ejecuta_scp
{
	contador=1
	for f in $(echo "$1"); do
		echo -n "    $contador. $f"
#		scp -q $f $2 2> salida.txt
		scp2 -Q $f $2 2> salida.txt

		if [[ -f $HOME/WO/${WO}/sftpg3_${WO}.txt ]]; then
			:
		else
			echo "open user@192.168.5x.23" > $HOME/WO/${WO}/sftpg3_${WO}.txt
		fi
		dst=$(echo $2|sed -e "s/\/$3\//\/xx\//g"|cut -d':' -f2)
		ori=$(echo $dst|cut -d'/' -f 1,2,3,4 --complement|sed -e 's|\/|\\|g')
		echo "cd $dst" >> $HOME/WO/${WO}/sftpg3_${WO}.txt
		echo $(echo "put $ori/$f"|sed -e 's/qcbllesrc/server\/qcbllesrc/g'|sed -e 's/\//\\/g') >> $HOME/WO/${WO}/sftpg3_${WO}.txt

		typs=$(cat salida.txt)
		rm salida.txt
		if [[ -n $typs ]]; then
			echo " (Error! $typs)"
			exit 9
		fi
		echo " (100%)"
		contador=$((contador + 1))
	done
}

function transfer
{
	if [[ $ORIGEN =~ ^(batch) ]]; then
		echo "tipo temp"
	else
		if [[ $RUTA =~ ^(server) ]]; then
			if [[ $BASE =~ (copymir)$ ]]; then
				echo "--> $PF/$(min $AMB)/server/qcbllesrc($(echo "$@"|wc -w))"
#				ejecuta_scp "$*" aix:$PF/$(min $AMB)/server/qcbllesrc
				ejecuta_scp "$*" XertixAIX:$PF/$(min $AMB)/server/qcbllesrc $(min $AMB)
			fi
#			if [[ $(basename $0) = trans.sh ]]; then
			if [[ $(basename $0) =~ (trans.sh|cprg.sh) ]]; then
				envia400m "$(fargs)"
			fi
		else
			echo "--> $PF/$(min $AMB)/$RUTA($(echo "$@"|wc -w))"
#			ejecuta_scp "$*" aix:$PF/$(min $AMB)/$RUTA
			ejecuta_scp "$*" XertixAIX:$PF/$(min $AMB)/$RUTA $(min $AMB)

			if [[ $RUTA =~ (presentation/processdefs)$ ]]; then
				tothf=$(echo "$*"|sed -e 's/\ /\n/g'|grep Headless|wc -l)
				if [[ $tothf -gt 0 ]]; then
					nms=$(echo "$*"|sed -e 's/\ /\n/g'|grep Headless)
					echo "--> $PF/$(min $AMB)/webservices/processdefs($tothf)"
#					ejecuta_scp "$nms" aix:$PF/$(min $AMB)/webservices/processdefs
					ejecuta_scp "$nms" XertixAIX:$PF/$(min $AMB)/webservices/processdefs $(min $AMB)
				fi
			fi

		fi
	fi
}

