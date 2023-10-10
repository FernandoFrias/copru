#!/bin/bash
source dirent.bash
dirent $*

sed -e "s/DESTINO//g" $HOME/scripts/check.rexx > ck.rexx
rexx ck.rexx $ARGS

rt=$(echo $ARGS|cut -d'.' -f1)
if [[ -f $rt.STD ]]; then
	rename STD err $rt.STD
	dos2unix -q $rt.err
	cat $rt.err|nl -b p: > $rt.aux
	sed -i 's/\t/ /g' $rt.aux
	mv $rt.aux $rt.err
	chmod 644 *err
else
	if [[ -f $rt.err ]]; then
		rm $rt.err
	fi
fi
rm ck.rexx

