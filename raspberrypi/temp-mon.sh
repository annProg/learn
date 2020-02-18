#!/bin/bash
# 监控温度并生成图片
# 临时方案，后续应换成监控系统

DT=`date +%Y-%m-%d`
LOG=/tmp/temp-$DT.log

TIME=`date +%H:%M:%S`

WEBROOT=/data/wwwroot/default/xianyu

CPU_TEMP=`cat /sys/class/thermal/thermal_zone0/temp |awk '{print $0/1000}'`
GPU_TEMP=`vcgencmd measure_temp |awk -F'=' '{print $2}' |cut -f1 -d"'"`

echo "$DT $TIME $CPU_TEMP $GPU_TEMP" >> $LOG

SCRIPT_PLOT=/tmp/$DT-gnuplot.txt

cat >$SCRIPT_PLOT<<EOF
set term png size 3800,768
set output '$WEBROOT/$DT.png'
set grid
set title 'RaspberryPI temperature'
set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
set xlabel 'Time'
set ylabel 'Temp'

plot '$LOG' using 2:3 with linespoint title 'CPU',\\
     '$LOG' using 2:4 with linespoint title 'GPU'
EOF

gnuplot $SCRIPT_PLOT
