#!/bin/bash
#this divides numbers with decimal dots with set precision
showHelp(){
	echo "Usage: $0 [-p precision] divided divisor" 
}
killSign(){
	res=${1//+/}
	res=${res//-/}
	echo $res
}

prec=2 #default precision
sign=0 #0-positive 1-negative
#handling options
while getopts ":hp:" opt; do
    case "$opt" in
    p)  prec=$OPTARG
		break
        ;;
    h)
        showHelp
        exit 0
        ;;
    \?) break
		;;
    esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift
#############################################
a=$1
b=$2

if ! [[  $1 =~ ^[-+]?[0-9]+\.?[0-9]+$  ]]; then
    echo "invalid operand $1"
    exit 1
fi
if ! [[ $2 =~ ^[-+]?[0-9]+\.?[0-9]+$ ]]; then
    echo "invalid operand $2"
    exit 1
fi
#echo "python says:"
#echo  print $a/$b | python
#deciding the sign of resuult
[ `expr match "$a" '-'` -eq 0 ] && aSign=0 || aSign=1 
[ `expr match "$b" '-'` -eq 0 ] && bSign=0 || bSign=1 

sign=$(($aSign+$bSign%2)) #TODO XOR
#get rid of the sign in strings
a=$(killSign $a)
b=$(killSign $b)
#count how many decimal numbers after the dot, kills thrailing zeros
dotPosa=0 
dotPosb=0
if [[ $a == *.* ]]; then
    a=$(echo $a | sed 's/0*$//g')
    dotPosa=$((${#a}-`expr index "$a" "."`)) #pos of . from the end of a
fi
if [[ $b == *.* ]]; then
    b=$(echo $b | sed 's/0*$//g')
    dotPosb=$((${#b}-`expr index "$b" "."`))
fi

a=${a//./} #deleting the dots
b=${b//./}
#removing zeros at the beginning
a=$(echo $a | sed 's/^0*//')
b=$(echo $b | sed 's/^0*//')
#shifting numbers so that position of dot is the same
if [ $dotPosa -gt $dotPosb ]; then
    for (( i=0; i<$(($dotPosa-$dotPosb)) ; ++i )); do
        b+="0"
    done;
else
    for (( i=0; i<$(($dotPosb-$dotPosa)) ; ++i )); do
        a+="0"
    done;
fi;
out=$(($a/$b)).
rem=$(($a%$b))
for (( i=1 ; i<=$prec ; ++i));do
    rem=$((10*$rem))
    out+=$(($rem/$b))
    rem=$(($rem%$b))
done
#echo "my script says:"
if [ $sign -eq 1 ]; then
    echo -n "-" 
fi; 
echo $out