#!/bin/bash

function genpdf
{
	if [[ $1 =~ (ma.tex) ]]; then
		tipo="Mayor Auxiliar"
		nm="ma"
	fi
	if [[ $1 =~ (mg.tex) ]]; then
		tipo="Mayor General"
		nm="mg"
	fi
	if [[ $1 =~ (ld.tex) ]]; then
		tipo="Diario"
		nm="ld"
	fi
	if [[ $1 =~ (as.tex) ]]; then
		tipo="Asientos Contables"
		nm="as"
	fi
	dlat="../scripts/latex"
	sed -e "s/TIPO/Libro $tipo/g" -e "s/PERIODO/$per/g" $dlat/tit.tex > titulo.tex
	sed -e "s/TIPO/Libro $tipo/g" $dlat/pp.tex > piep.tex
	fec=$(LC_ALL=es_MX date "+%d de %B de %Y")
	sed -e "s/FECHA/$fec/g" $dlat/fec.tex > fecha.tex
#	latexmk -silent -pdf $dlat/$1
#	pdflatex -interaction=batchmode $dlat/$1
#	pdflatex $dlat/$1
	/cygdrive/c/Users/xm731011/MiKTeX/miktex/bin/pdflatex $dlat/$1
# segunda invocacion para resolver referencias circulares(paginacion)
#	pdflatex -interaction=batchmode $dlat/$1
#	pdflatex $dlat/$1
	/cygdrive/c/Users/xm731011/MiKTeX/miktex/bin/pdflatex $dlat/$1
	rm titulo.tex piep.tex fecha.tex
	rm $nm.aux $nm.log tab_$1
#	rm $nm.aux $nm.log tab_$1 $nm.fdb_latexmk $nm.fls
	mv $nm.pdf $base/$dt/${nm}\_$dt.pdf
}

function copia_log
{
	mv $filerr $base/$dt
}

function elimina_archivos
{
	rm -rf $dproc/*
}

function valida_rc
{
	if [[ $? -eq $1 ]]; then
		copia_log
		elimina_archivos
		exit
	fi
}

function valida_encabezado
{
	head -1 $1|gawk -f $2 > $filerr
	valida_rc 9
}

function existe_dir
{
	if [[ -d $1 ]]; then
		:
	else
		echo "El directorio $1 no existe"
		exit 0
	fi
}

function existe_arch
{
	if [[ -f $1 ]]; then
		:
	else
		echo "El archivo $1 no existe"
		exit
	fi
}

function valida_dt
{
	aa=$(echo $1|cut -c1-4)
	mm=$(echo $1|cut -c5-6)
	dd=$(echo $1|cut -c7-8)
	aini=2013
	if [[ $aa -ge $aini ]]; then
		if [[ ($mm =~ (01|03|05|07|08|10|12) && $dd = 31) ||
			  ($mm =~ (04|06|09|11) && $dd = 30) ||
			  ($mm = "02" && $dd =~ (28|29)) ]]; then
			:
		else
			echo "Dia/Mes invalido"
			exit
		fi
	else
		echo "año debe ser mayor o igual a $aini"
		exit
	fi
}

function cambia_codificacionA
{
	iconv -f ISO-8859-1 -t UTF-8 $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
}

function cambia_codificacionB
{
	iconv -f UTF-8 -t ISO-8859-1 $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
}

function elimina_encabezado
{
	sed -e '1d' $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
}

function ordena2
{
	sort -t$'\t' -k$2,$2 -k$3,$3 $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
}

function ordena3
{
	sort -t$'\t' -k$2,$2 -k$3,$3 -k$4,$4 $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
#	sort -t$'\t' -k${2}n,$2 -k${3}n,$3 -k${4}n,$4 $1 > $5
}

function ordena4
{
	sort -t$'\t' -k$2,$2 -k$3,$3 -k$4,$4 -k$5,$5 $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
}

function genera_totales
{
	LC_ALL=en_US.UTF-8 gawk -f $pcawk ${pesos}.$ext
	if [[ $? == "1" ]]; then
		exit 1
	fi
}

function cambia_formato_fecha_hora
{
	dg="[0-9]"
	dgs=$dg$dg
	fec="\($dgs\).\($dgs\).\($dg\{4\}\)"
	hr="\($dgs:$dgs\)"
	sed -e "s/$fec.$hr/\3-\2-\1 \4/g" $1 > ${1}.auxiliar
	mv ${1}.auxiliar $1
}

function depura_mapeo
{
	LC_ALL=en_US.UTF-8 gawk -f $mpawk error=$filerr $1
	if [[ -s $filerr ]]; then
		copia_log
		elimina_archivos
		exit 1
	fi
	mv ${1}.auxiliar $1
}

function complementa_RAC
{
	LC_ALL=en_US.UTF-8 gawk -f $crawk entrada=${2} $1
	mv ${1}.auxiliar $1
}

function complementa_asientos
{
	LC_ALL=en_US.UTF-8 gawk -f $caawk entrada=${2} $1
	mv ${1}.auxiliar $1
	dos2unix -q $1
}

function genera_ma
{
	LC_ALL=en_US.UTF-8 gawk -f $maawk   entrada1=${2} \
										entrada2=${3} \
										entrada3=${4} \
										entrada4=${5} \
										error=$filerr \
										$1 > $TMA
	if [[ -s $filerr ]]; then
		copia_log
		elimina_archivos
		exit 1
	fi
	mv ${5}.auxiliar $5
}

function genera_mg
{
#	LC_ALL=en_US.UTF-8 gawk -f $mgawk ffin="$ffin" entrada=${2} $1 > $TMG
	LC_ALL=en_US.UTF-8 gawk -f $mgawk ffin="$ffin" entrada=${2} map=${3} $1 > $TMG
}

function genera_ld
{
	LC_ALL=en_US.UTF-8 gawk -f $ldawk $1 > $TLD
}

function genera_as
{
	tr=$(wc -l $1|cut -d' ' -f1)
	LC_ALL=en_US.UTF-8 gawk -f $asawk tr="$tr" $1 > $TAS
}

################################################################################
# valida argumentos                                                            #
################################################################################
if [[ $# -eq 0 ]]; then
	dt=$(date +%Y%m%d)
else
	if [[ $# -eq 1 ]]; then
		dt=$1
	else
		echo "argumentos invalidos"
		exit 0
	fi
fi

################################################################################
# valida existencia directorio finanzas                                        #
################################################################################
base="/home/xm731011/sources/awk/finanzas"
existe_dir $base

################################################################################
# valida fecha correcta y existencia del directorio finanzas/fecha             #
################################################################################
valida_dt $dt
fini=01-$mm-$aa
ffin=$dd-$mm-$aa
per=$(echo "$fini al $ffin")
existe_dir $base/$dt

################################################################################
# valida existencia directorio proceso                                         #
################################################################################
proc="proceso"
dproc=$base/$proc
existe_dir $dproc

################################################################################
# valida existencia archivo Asientos.txt                                       #
################################################################################
ext="txt"
asientos="Asientos"
existe_arch $base/$dt/$asientos.$ext

################################################################################
# valida existencia archivo Pesos.txt                                          #
################################################################################
pesos="Pesos"
existe_arch $base/$dt/$pesos.$ext

################################################################################
# valida existencia archivo Mapeo.txt                                          #
################################################################################
mapeo="MapeoCUSF"
polizas="polizas"
existe_arch $base/$dt/$mapeo.$ext

################################################################################
# valida existencia directorio scripts                                         #
################################################################################
scripts="/home/xm731011/sources/awk/finanzas/scripts"
existe_dir $scripts

################################################################################
# valida existencia scripts awk                                                #
################################################################################
pcawk=$scripts/awk/pc.awk
maawk=$scripts/awk/ma.awk
mgawk=$scripts/awk/mg.awk
ldawk=$scripts/awk/ld.awk
asawk=$scripts/awk/as.awk
hpawk=$scripts/awk/hp.awk
haawk=$scripts/awk/ha.awk
hmawk=$scripts/awk/hm.awk
mpawk=$scripts/awk/mp.awk
crawk=$scripts/awk/cr.awk
caawk=$scripts/awk/ca.awk
filerr=logerr.txt
existe_arch $pcawk
existe_arch $maawk
existe_arch $mgawk
existe_arch $ldawk
existe_arch $asawk
existe_arch $hpawk
existe_arch $haawk
existe_arch $hmawk
existe_arch $mpawk
existe_arch $crawk
existe_arch $caawk

################################################################################
# valida existencia scripts latex                                              #
################################################################################
matex="ma.tex"
mgtex="mg.tex"
ldtex="ld.tex"
astex="as.tex"
titex="tit.tex"
existe_arch $scripts/latex/$matex
existe_arch $scripts/latex/$mgtex
existe_arch $scripts/latex/$ldtex
existe_arch $scripts/latex/$astex
existe_arch $scripts/latex/$titex

TMA="tab_ma.tex"
TMG="tab_mg.tex"
TLD="tab_ld.tex"
TAS="tab_as.tex"
################################################################################
# copia insumos a directorio auxiliar                                          #
################################################################################
cp $base/$dt/$asientos.$ext $dproc
cp $base/$dt/$pesos.$ext $dproc
cp $base/$dt/$mapeo.$ext $dproc
cd $dproc

################################################################################
#                                                                              #
# generacion de archivos tex                                                   #
#                                                                              #
################################################################################
# totales de cuentas por nivel
#set -x
cambia_codificacionA $pesos.$ext
valida_encabezado $pesos.$ext $hpawk
elimina_encabezado ${pesos}.$ext
ordena4 ${pesos}.$ext 12 10 8 6
genera_totales #RA1, RA2, RA3, RAC

cambia_codificacionA $mapeo.$ext
valida_encabezado ${mapeo}.$ext $hmawk
elimina_encabezado ${mapeo}.$ext
depura_mapeo ${mapeo}.$ext
ordena2 ${mapeo}.$ext 1 2
complementa_RAC RAC.$ext $mapeo.$ext

cambia_codificacionA $asientos.$ext
#dos2unix $asientos.$ext
valida_encabezado ${asientos}.$ext $haawk
elimina_encabezado ${asientos}.$ext
#dos2unix $asientos.$ext
cambia_formato_fecha_hora ${asientos}.$ext
#dos2unix $asientos.$ext
ordena3 ${asientos}.$ext 6 36 27
#dos2unix $asientos.$ext
cp ${asientos}.$ext ${asientos}1.$ext
complementa_asientos ${asientos}.$ext $mapeo.$ext
#dos2unix $asientos.$ext
ordena3 ${asientos}.$ext 36 27 6
#dos2unix $asientos.$ext
cp ${asientos}.$ext ${asientos}5.$ext

# mayor auxiliar
genera_ma RAC.$ext RA1.$ext RA2.$ext RA3.$ext ${asientos}1.$ext
# mayor general
ordena2 ${asientos}1.$ext 1 2
genera_mg RA1.$ext ${asientos}1.$ext ${mapeo}.$ext
rm ${asientos}1.$ext
# libro diario
genera_ld ${asientos}5.$ext
rm ${asientos}5.$ext
# libro asientos
ordena3 ${asientos}.$ext 22 6 28
dos2unix $asientos.$ext
genera_as ${asientos}.$ext

rm RAC.$ext RA1.$ext RA2.$ext RA3.$ext ${asientos}.$ext $mapeo.$ext $pesos.$ext

################################################################################
#                                                                              #
# generacion de los reportes mayor auxiliar y mayor general en formato pdf     #
#                                                                              #
################################################################################
# mayor auxiliar
genpdf $matex
# mayor general
genpdf $mgtex
# libro diario
genpdf $ldtex
# libro asientos
genpdf $astex

cambia_codificacionB $polizas.$ext
mv polizas.txt $base/$dt/"polizas_$dt.txt"

