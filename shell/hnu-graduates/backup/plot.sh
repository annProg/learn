#!/bin/bash
gnuplot<<EOF
set term png size 6000,800 font "/usr/share/fonts/wqy-microhei/wqy-microhei.ttc,12"
set output 'tmp.png'
set style data histograms
set grid
set style fill solid 1.00 border -1
#set xrange [0:200]
set xtic rotate by 270
plot 'tmp' using 1:xtic(2)
EOF
