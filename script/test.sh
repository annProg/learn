#!/bin/bash
# getopts :s:h表示这个命令接受2个带参数选项，分别是-h和-s
while getopts :t:c:i:m:d:o: opt
do  
    case $opt in
        t) TYPE=$OPTARG ;;
        :) echo "-$OPTARG 需要参数值" ;;
        c) COMMENT=$OPTARG ;;
		i) ID=$OPTARG ;;
		m) MAIL=$OPTARG ;;
		d) DATE=$OPTARG ;;
		o) OUTPUT=$OPTARG ;;
        *) echo "-$OPTARG not recognized" ;;
    esac
done

