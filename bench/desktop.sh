count=5000
for i in {1,50,100,300,500};do
    ab -c $i -n $count "http://application.desktop.scloud.letv.com/api/v1/app/mainIcon" >./log/mainIcon_$i.log
    ab -c $i -n $count "http://application.desktop.scloud.letv.com/iptv/api/box/getDeskIcon" >./log/getDeskIcon_$i.log
done
