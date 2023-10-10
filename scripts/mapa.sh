#!/bin/bash

#	ccp4=$(copys_pl $ccl3".cbl")
#	for cpl4 in $ccp4; do
#		ccl4=$(cat ../QCBLLESRC/$cpl4".cpy"|grep "^.\{6\}\ \+\(CALL\ '*[A-Z0-9-]\+'*\ \+\|MOVE\ \+'[A-Z0-9]*'\ \+TO\ \+WPGWS-CALL-PGM-ID\)"|sed -e 's/^[0-9A-Z\/]\+//g' -e 's/\(MOVE\|\ CALL\ \)//g' -e 's/^\ \+//g' -e "s/'//g"|cut -d' ' -f1|grep -v 'WPGWS-CALL-PGM-ID\|ILBOABN0\|WTIMR-TIMER-PROGRAM'|sort|uniq|grep -v 'CSI\|XSD\|SSD\|FSD')
#		if [[ -n $ccl4 ]]; then
#			echo "4    $ccl4"
#		fi
#	done

function copys_pl
{
	pls=$(grep '^.\{6\}\ \+COPY\ [A-Z0-9]\+\.' $1|sed -e 's/^[A-Z0-9]\+//g' -e 's/^\ \+//g' -e 's/COPY\ //g'|grep -v 'CSI\|XSD\|SSD\|FSD\|XC\|SQL'|grep '^..PL'|sed -e 's/\.$//g')
	plss=$(echo $pls|gawk 'BEGIN{RS=" "}{printf("%s\n", $0)}')
	echo $plss
}

function ccl
{
	cl=$(cat ../QCBLLESRC/$1".cpy"|grep "^.\{6\}\ \+\(CALL\ '*[A-Z0-9-]\+'*\ \+\|MOVE\ \+'[A-Z0-9]*'\ \+TO\ \+WPGWS-CALL-PGM-ID\)"|sed -e 's/^[0-9A-Z\/]\+//g' -e 's/\(MOVE\|\ CALL\ \)//g' -e 's/^\ \+//g' -e "s/'//g"|cut -d' ' -f1|grep -v 'WPGWS-CALL-PGM-ID\|ILBOABN0\|WTIMR-TIMER-PROGRAM'|sort|uniq|grep -v 'CSI\|XSD\|SSD\|FSD')
	echo $cl
}

echo $1
ccp0=$(copys_pl $1)
for cpl0 in $ccp0; do
	ccl1=$(ccl $cpl0)
	echo "1 $ccl1"
	ccp1=$(copys_pl $ccl1".cbl")
	for cpl1 in $ccp1; do
		ccl2=$(ccl $cpl1)
		if [[ -n $ccl2 ]]; then
			echo "2  $ccl2"
			ccp2=$(copys_pl $ccl2".cbl")
			for cpl2 in $ccp2; do
				ccl3=$(ccl $cpl2)
				if [[ -n $ccl3 ]]; then
					echo "3   $ccl3"
##
					ccp4=$(copys_pl $ccl3".cbl")
					for cpl4 in $ccp4; do
						ccl4=$(ccl $cpl4)
						if [[ -n $ccl4 ]]; then
							echo "4    $ccl4"
##
							ccp5=$(copys_pl $ccl4".cbl")
							for cpl5 in $ccp5; do
								ccl5=$(cat ../QCBLLESRC/$cpl5".cpy"|grep "^.\{6\}\ \+\(CALL\ '*[A-Z0-9-]\+'*\ \+\|MOVE\ \+'[A-Z0-9]*'\ \+TO\ \+WPGWS-CALL-PGM-ID\)"|sed -e 's/^[0-9A-Z\/]\+//g' -e 's/\(MOVE\|\ CALL\ \)//g' -e 's/^\ \+//g' -e "s/'//g"|cut -d' ' -f1|grep -v 'WPGWS-CALL-PGM-ID\|ILBOABN0\|WTIMR-TIMER-PROGRAM'|sort|uniq|grep -v 'CSI\|XSD\|SSD\|FSD')
								if [[ -n $ccl4 ]]; then
									echo "5    $ccl5"
##
	ccp6=$(copys_pl $ccl5".cbl")
	for cpl6 in $ccp6; do
		ccl6=$(cat ../QCBLLESRC/$cpl6".cpy"|grep "^.\{6\}\ \+\(CALL\ '*[A-Z0-9-]\+'*\ \+\|MOVE\ \+'[A-Z0-9]*'\ \+TO\ \+WPGWS-CALL-PGM-ID\)"|sed -e 's/^[0-9A-Z\/]\+//g' -e 's/\(MOVE\|\ CALL\ \)//g' -e 's/^\ \+//g' -e "s/'//g"|cut -d' ' -f1|grep -v 'WPGWS-CALL-PGM-ID\|ILBOABN0\|WTIMR-TIMER-PROGRAM'|sort|uniq|grep -v 'CSI\|XSD\|SSD\|FSD')
		if [[ -n $ccl6 ]]; then
			echo "6    $ccl6"
		fi
	done
##
								fi
							done
##
						fi
					done
##
				fi

			done
		fi
	done
done
