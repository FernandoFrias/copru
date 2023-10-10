#!/bin/bash
source funcom.bash
valida_directorio
valida_argumentos $@

pw=$(pwd)
ls $1 > l.txt
grep -v 'address' $raiz$wo/parms.rexx > t.rexx
rexx t.rexx l.txt
rm l.txt
rm t.rexx
nms=$(ls *cvt|sed -e 's/.cvt//g')
mv -v *cvt ../../data
cd ../../data
rename ".cvt" "" *cvt
chmod 644 $nms
trans.sh $nms
cd $pw

