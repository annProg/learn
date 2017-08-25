#!/bin/bash
SUM=`wc -l hnu2014.csv |awk '{print $1}'`
TITLE="湖南大学2014届 $SUM 名毕业生学院分布情况"
gnuplot<<EOF
set term png size 800,800 font "/usr/share/fonts/wqy-microhei/wqy-microhei.ttc,12"
set output "./img/college.png"
set style data histograms
set grid
set title "湖南大学2014届 $SUM 名毕业生学院分布情况"
#set label "湖南大学2014届 $SUM 名毕业生学院分布情况" at -3,-400 rotate by 90
set style fill solid 1.00 border -1
set xtic rotate by 290
set ytic rotate by 90
set ytics 100
#set key rotate by 90
plot "college.txt" using 1:xtic(2)
EOF

convert -rotate 90 img/college.png img/college_1.png 
#convert -font /usr/share/fonts/wqy-microhei/wqy-microhei.ttc -pointsize 16 -draw "text 100,26 '$TITLE'" img/college_1.png img/college.png

cat >convert.sh<<eof
#!/bin/bash
convert -rotate 90 img/college.png img/college_1.png 
convert -font /usr/share/fonts/wqy-microhei/wqy-microhei.ttc -pointsize 16 -draw 'text 100,26 "$TITLE"' img/college_1.png img/college.png
eof
#chmod +x convert.sh && source ./convert.sh
