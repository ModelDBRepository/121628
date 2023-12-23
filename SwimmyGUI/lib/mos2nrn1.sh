#!/bin/sh
N=`cygpath -u $NU`
export N
PATH=$N/bin
export PATH

current=`pwd`
mosdir=""
if [ ! -r mosinit.hoc ] ; then # then look in other directories
echo "no mosinit.hoc in $current"
  for i in `ls -1F | grep '/'` ; do
echo "try in $i"
	if [ -r "${i}mosinit.hoc" ] ; then #use this as directory
echo "found a mosinit.hoc in $i"
		mosdir=$i
		break
	fi
  done
fi

if [ -n "$mosdir" ] ; then
	echo "working directory ${current}/${mosdir}"
	echo "$mosdir" |sed 's;/;;' > mos2nrn1.tmp
	cd $mosdir
	current="${current}/${mosdir}"
fi

ls
mod="`ls *.mod`"
dll="`ls *.dll`"

# decide whether to make a new nrnmech.dll
if [ -n "$mod" ] ; then # there are mod files so maybe
  if [ -z "$dll" ] ; then # no dll so make it
	sh $N/lib/mknrndl2.sh
  else # there is a dll but maybe it is the wrong version
   	nmodl_version="`nm nrnmech.dll | grep nocmodl5_2`"
	if [ -z "$nmodl_version" ] ; then #incompatible version
echo "The downloaded nrnmech.dll file is incompatible with"
echo " your installed version of NEURON. Remaking nrnmech.dll."
		sh $N/lib/mknrndl2.sh
	fi
  fi
fi

if [ -f moslocal.tmp ] ; then
	exit 0
fi

echo "Now is your chance to look at these files in"
echo " $current more closely before you go on."

echo -n "Hit Return key to run NEURON or 'n'(Return) to cancel."
read a
if [ -n "$a" ] ; then
	echo "no" > mos2nrn2.tmp
fi

