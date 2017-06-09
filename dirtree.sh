#!/bin/bash
showHelp(){
	echo "Usage: $0 [-d number of directories] [-f number of files] \
	[destination path (PWD default)]" 
}
#defaul values 
nDirs=5
nFiles=5
while getopts "h?d:f:" opt; do
    case "$opt" in
    h|\?)
        showHelp
        exit 0
        ;;
    d)  nDirs=$OPTARG
        ;;
    f)  nFiles=$OPTARG
        ;;
    esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift
DESTDIR=${1:-$PWD}
echo "making $nDirs directories with $nFiles files each"

if [ ! -d $DESTDIR ]; then
	mkdir -p $DESTDIR
fi
cd $DESTDIR
for ((i=0;i<$nDirs;++i)); do
	mkdir -p d$i
	cd d$i
	for ((j=0;j<$nFiles;++j)); do
		echo > f$j.txt
	done
	cd ..
done
echo "done"