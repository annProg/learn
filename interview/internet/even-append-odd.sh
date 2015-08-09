#!/bin/bash

#-----------------------------------------------------------
# Usage: 偶数行附加到奇数行后
# $Id: even-append-odd.sh  i@annhe.net  2015-08-09 17:19:51 $
#-----------------------------------------------------------

# 列如文件内容如下
# aa
# bb
# cc
# dd
# 输出为
# aa bb
# cc dd

cat >a.txt <<EOF
aa
bb
cc
dd
EOF

awk 'NR%2==1' a.txt >1.txt
awk 'NR%2==0' a.txt >2.txt

paste -d ' ' 1.txt 2.txt
rm -f a.txt 1.txt 2.txt
