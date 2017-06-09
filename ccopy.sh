#!/bin/bash

#copying files with progress bar

src=$1
dst=$2
if [ ! -d $dst ]; then
    mkdir  $dst
fi
srcSize=`du -s $src | cut -f1`
#dstSize=`du -s $dst/$(basename $src ) | cut -f1`
#pbar function 1st param - number of '#' in the bar, 2nd - some info in the end e.g. "123/1000 files"
pbar() {
    echo -n '[';
    for (( i = 0; i < $len; ++i )); do
        echo -n '-' 
    done;
    echo -n ']';
    echo -ne '\r['
    for (( i = 0; i < $1; ++i )); do
        echo -n '#' 
    done;
    for (( i = 0; i < $len - $1; ++i ));do
         echo -n '-'
    done;
echo -ne '] ' $2 '%\r';
}

#now the fun begins
len=$(tput cols);
len=$(($len-10))
if [[ ! -e $src ]];then
    echo "the file or folder passed does not exist!"
    exit 1
fi

cp -arn $src $dst &
PROC_ID=$!
while kill -0 "$PROC_ID" >/dev/null 2>&1 ; do
    pbar $(($len*$((`du -s $dst/$(basename $src ) | cut -f1`))/$srcSize)) $((100*$((`du -s $dst/$(basename $src ) | cut -f1`))/$srcSize))
    sleep .1
done 
#pbar $len 100 #uncomment if u want to have 100% at the 
echo -e '\ndone'