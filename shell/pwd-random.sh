#!/bin/bash

############################
# Usage:
# File Name: random-pwd.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-11 10:20:25
############################

#!/bin/bash
special[0]="#"
special[1]="$"
special[2]="&"
special[3]="^"
special[4]="!"
special[5]="%"
special[6]="@"
 
randstr(){
  index=0
  str=""
  for i in {a..z}; do arr[index]=$i; index=`expr ${index} + 1`; done
  for i in {A..Z}; do arr[index]=$i; index=`expr ${index} + 1`; done
  for i in {0..9}; do arr[index]=$i; index=`expr ${index} + 1`; done
  for i in ${special[@]}; do arr[index]=$i; index=`expr ${index} + 1`; done
  for i in {1..32}; do 
  	((random=$RANDOM%$index))
	str="$str${arr[random]}"
  done
  echo $str
}
 
password=`randstr`
echo ${password:3:12}
#echo "$password" |passwd root --stdin
