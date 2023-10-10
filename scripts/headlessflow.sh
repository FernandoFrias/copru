#!/bin/bash
source dirent.bash
dirent $*

function genxml
{
	saux=$(echo $1|cut -d'.' -f1)".aux"
	sxml=$(echo $1|cut -d'.' -f1)".xml"
	
	gawk '
		BEGIN{RS="><"}
		{
			if (FNR == 1)
				printf("%s>\n", $0)
			else
				printf("<%s>\n", $0)
		}
	' $1 > $saux
	sed -i '$s/>$//g' $saux
	xmllint --format $saux > $sxml
	rm $saux

	tgs="\ \+<Severity>\(.\+\)</Severity>"
	tgc="\ \+<Content>\(.\+\)</Content>"
	errs=$(gawk '/Severity|Content/ {print $0}' $sxml|sed -e "s|$tgs|Severidad \1:|g" -e "s|$tgc|\ \ \ \ \1|g")
	if [[ -z $errs ]]; then
		echo "Warnings:"
		xmllint --xpath 'string(//TableALL-MESSAGES-T)' $sxml |grep -v '^ \+$\|^$'
	else
		echo "$errs"
	fi
	rm $sxml
}

function call
{
	salida="salida.txt"
	curl -s -X POST -H "SOAPAction:." -H "Content-Type:text/xml; charset=utf-8" $1 -d @$2 -o $salida
	if [[ -f $salida ]]; then
		eok
		genxml $salida
		xmllint --format $salida > salida_$(echo $2|sed -e 's/\.xml//g').xml
#		xmllint --format $salida
		cat salida_$(echo $2|sed -e 's/\.xml//g').xml
		rm $salida
	else
		enok "error al invocar $1, no hubo respuesta"
	fi
}

URL="http://${AMB}660/PFBF1220RetrieveService/services/BF1220RetrieveService"
mensaje "invocando URL ambiente $AMB"
call $URL $1

