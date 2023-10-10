#!/bin/bash
source transcom.bash
source userhost.bash
source 3270.bash
source typecom.bash
source dirent.bash
dirent $*

#		recupera_spool ${njoba} ${ujob} ${mjob} $nt
# CPYSPLF FILE(I00PM057) TOFILE(IDVF660/I00PM057) JOB(718371/XM731011/I00PM057) SPLNBR(3)
function recupera_spool
{	
	ns=$(($4 - 1))
	FIL="SPLFILE"
	lib="I$AMB""F660"

	rsp=$(existe_file ${lib}/${FIL})
	if [[ $rsp == "si" ]]; then
		com="CLRPFM FILE(${lib}/${FIL}) MBR(${FIL})"
	else
		com="CRTPF FILE(${lib}/${FIL}) RCDLEN(132) FILETYPE(*DATA)"
	fi
	x3270if "String(\"$com\")"
	x3270if "Enter()"

	com="CPYSPLF FILE(${3}) TOFILE(${lib}/${FIL}) JOB(${1}/${2}/${3}) SPLNBR(${ns})"
	x3270if "String(\"$com\")"
	x3270if "Enter()"

	return
}

function genera_archivo_errores
{
	dest="${1}"
	sed -i '/XCWWCRHT/d' ${dest}
	CL="Control Language"
	if [[ -n $(head -1 $dest|grep "$CL") ]]; then
 		sed -ni 24,'$'p $dest
 		cat $dest|grep -v "$CL\|SEQNBR" > $dest.aux
		IFS=$'\n'
		cat $dest.aux|while read ln;do
			if [[ $ln =~ ^\*\ CPD[0-9]+ ]]; then
				echo "Line: $linen $ln" >> linerr
			else
				if [[ $ln =~ ^\ +[0-9]+- ]]; then
					linen=$(echo "$ln"|cut -d'-' -f1|sed -e 's/ //g')
				fi
			fi
		done

		sed -i '/^\* CPD[0-9]\+/d' $dest.aux
		totl=$(wc -l $dest.aux|cut -d' ' -f1)
		totlc=$(( $totl - 7 ))
		cat $dest.aux|head -$totlc > $dest
		echo "                                           Error List" >> $dest
		cat linerr|sed -e 's/\*/Error:/g' >> $dest
		echo "                       * * * * *   E N D   O F   E R R O R   L I S T   * * * * * " >> $dest
		cat $dest.aux|tail -7 >> $dest
		rm $dest.aux linerr
	fi

	SIC="SQL ILE COBOL"
	if [[ -n $(head -1 $dest|grep "$SIC") ]]; then
		sed -ni 52,'$'p $dest
		IFS=$'\n'
		cat $dest|grep -v "$SIC\|SEQNBR"|while read ln;do
			if [[ "$ln" =~ ^SQL.+$|^\ +[a-z]+.+\.$ ]]; then
				if [[ "$ln" =~ ^SQL.+\.$ ]]; then
					echo "$ln" >> $dest.aux
				else
 					if [[ "$ln" =~ "SQL" ]]; then
						ant0="$ln"
 					else
						ant1=$(echo "$ln"|sed -e 's/ \{21\}//g')
						echo "$ant0 $ant1" >> $dest.aux
 					fi
				fi
			else
				echo "$ln" >> $dest.aux
			fi
		done
		mv $dest.aux $dest
	fi

	IIB="IBM ILE COBOL"
	if [[ -n $(head -1 $dest|grep "$IIB") ]]; then
		sed -ni 61,'$'p $dest
		cat $dest|grep -v "$IIB\|STMT PL SEQNBR" > $dest.aux
		ini=$(cat $dest.aux|nl|grep 'COBOL Compiler Options in Effect'|head -1|cut -f1)
		fn=$(cat $dest.aux|nl|grep 'IDENTIFICATION'|head -1|cut -f1)
		fin=$((fn - 1))
		cat $dest.aux|sed -e "$ini,$fin d" > $dest
		rm $dest.aux
	fi

    dos2unix -q $dest

	return
}

mensaje "Inicia transferencia"
eok
transfer "$ARGS"
mensaje "Termina transferencia"
eok

if [[ -z $ARGS ]]; then
	echo "sin archivos a procesar en $BASE"
	exit 0
fi

conn
sign_on
tipos
#TP=$(echo $tp)
#echo "TP = $TP"

MD=$(echo $ARGS|cut -d'.' -f1)
LB="I${AMB}O660"

cmd="SBMJOB CMD(ICOMP PGM(${MD}) SRCFILE($(may $BASE)) OBJLIB(${LB})) JOB(${MD})  LOG(4 *JOBD *SECLVL)"
#echo "$cmd"
x3270if "String(\"$cmd\")"
x3270if "Enter()"
if [[ "$(x3270if 'Ascii(23,1,40)')" == "A message has arrived on a message queue" ]]; then
	x3270if "Enter()"
fi
job=$(x3270if 'Ascii(23,5,25)'|cut -d' ' -f1)
#echo "$job"
cjob=$(echo $job|cut -d '/' -f1)
njoba=$((cjob + 2))
njobb=$((cjob + 3))
x3270if "Enter()"
ujob=$(echo $job|cut -d '/' -f2)
mjob=$(echo $job|cut -d '/' -f3)

cont="si"
occ=1
jobendmsg='Job log not displayed or listed because job has ended.'
jobusername=${njoba}/${ujob}/${mjob}
echo -e "Job $jobusername En ejecucion\c"
until [[ "$cont" == "no" ]];do
	cmd="DSPJOB JOB(${jobusername}) OPTION(*JOBLOG)"
	x3270if "String(\"$cmd\")"
	x3270if "Enter()"
	msg=$(x3270if 'Ascii(5,3,54)')
	echo -e ".\c"
	if [[ $msg == $jobendmsg ]]; then
		x3270if "Enter()"
		x3270if "String(dspmsg)"
		x3270if "Enter()"
		line=$(echo "$(x3270if 'Ascii')"|grep $jobusername)
		completed=$(echo "$line"|sed -e "s|   Job ${jobusername} [a-z]\+ \([a-z]\+\).\+$|\1|g")
		if [[ $completed == "abnormally" ]]; then
			nok
			echo -e "Recuperando spool \c"
			x3270if "Enter()"
			cmd="WRKSPLF SELECT(*ALL) JOB(${jobusername})"
			x3270if "String(\"$cmd\")"
			x3270if "Enter()"
			nt=$(x3270if 'Ascii'|grep ${ujob}|wc -l)
			x3270if "Enter()"
			recupera_spool ${njoba} ${ujob} ${mjob} $nt
			eok
			echo -e "Transfiriendo spool \c"
			recibe400x I${AMB}F660/SPLFILE.SPLFILE ${MD}.err
			eok
			echo -e "Generando archivo ${MD}.err \c"
			genera_archivo_errores ${MD}.err
			eok
		else
			if [[ -f ${MD}.err ]]; then
				rm ${MD}.err
			fi
			eok
		fi
		cont="no"
	else
		if [[ $occ -gt 15 ]]; then
			nok "Tiempo agotado"
			x3270if "Enter()"
		fi
		occ=$((occ + 1))
	fi
	x3270if "Enter()"
done

sign_off

#CBLLE ok
#Job 653681/XM731011/XSDU2558 completed normally on 02/20/17 at 11:03:17.
#Job 653682/XM731011/ICOMPBATCH completed normally on 02/20/17 at 11:03:17.
#Job 653683/XM731011/XSDU2558 completed normally on 02/20/17 at 11:03:23. (1)

#SQLCBLLE ok
#Job 653685/XM731011/NSOM0950 completed normally on 02/20/17 at 11:10:14.
#Job 653686/XM731011/ICOMPBATCH completed normally on 02/20/17 at 11:10:14.
#Job 653687/XM731011/NSOM0950 completed normally on 02/20/17 at 11:10:20. (1,2)

#WRKSPLF SELECT(*ALL) JOB(653693/XM731011/NSOM0950)

#cpysplf file(NSOM0950) tofile(IDVF660/SPLFILE) job(653766/XM731011/NSOM0950) SPLNBR(1)

