
NEURONHOME=$N
M=$N/lib

if test $# -gt 0
then
	files=$*
else
	files=`ls -1 *.[mM][oO][dD]`
fi
prefixes=`echo $files | sed 's/\.[mM][oO][dD]//g'`

#echo "COMPLETE FILE NAMES"
#echo $files
#echo "TRUNCATED FILE NAMES"
#echo $prefixes

MODOBJS=
if [ `echo "\n"` ]
then
	newline="\n"
else
	newline="\\\\n"
fi

echo '#include <stdio.h>
#include "hocdec.h"
/* change name when structures in neuron.exe change*/
/* and also change the mos2nrn1.sh script */
int nocmodl5_2;

modl_reg(){
	fprintf(stderr, "Additional mechanisms from files'$newline'");
' > mod_func.c

for i in $files
do
	echo 'fprintf(stderr," '$i'");' >>mod_func.c
done
echo 'NOT_PARALLEL_SUB(fprintf(stderr, "'$newline'");)' >>mod_func.c

for i in $prefixes
do
	rm -f $i.c
done

echo -n 'MODOBJFILES=' >$$.tmp
for i in $prefixes
do
	echo _"$i"_reg"();" >> mod_func.c
	echo -n " $i.o" >> $$.tmp
done
echo "}" >> mod_func.c

#echo ' "' >> $$.tmp
# cat $$.tmp
$N/bin/make -f $M/mknrndll.mak "`cat $$.tmp`" nrnmech.dll
rm $$.tmp

