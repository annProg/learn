#!/bin/bash

############################
# Usage: 将浮点数转换到最近的整数
# File Name: 9-round.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-06 18:17:37
############################



function round() {
	echo $1 |awk '{if ($0 > 0 ) {print int($0+0.5)} else {print int($0-0.5)}}'	
}

round $1
