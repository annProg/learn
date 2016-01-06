set term png size 1366,768
set output "OUTPUTPATH"
set title "IMGTITLE"
set grid
set xlabel "time"
set ylabel "count"
set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
