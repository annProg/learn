# TIME WAIT状态测试

容器启动参数加上 `--sysctl net.ipv4.ip_local_port_range=1024\ 1034`，即仅有11个可用端口

## HTTP 1.1
### net.ipv4.tcp_tw_reuse = 1
以privileged启动2个容器，宿主机开启tw_reuse

每次请求sleep 1s
```
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";sleep 1;don
e |sort |uniq -c
     20 404
```

连续请求
```
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";done |sort 
|uniq -c
      9 000
     11 404
```

状态码`000`时报错如下:
```
* Rebuilt URL to: http://172.17.0.2/
*   Trying 172.17.0.2...
* TCP_NODELAY set
* Immediate connect fail for 172.17.0.2: Address not available
* Closing connection 0
```

### net.ipv4.tcp_tw_reuse = 0
以privileged启动2个容器，宿主机关闭tw_reuse

每请求一次sleep 1s
```
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";sleep 1;don
e |sort |uniq -c
      9 000
     11 404
```

连续请求
```
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";done |sort 
|uniq -c
      9 000
     11 404
812e320d752c:~# 
812e320d752c:~# 
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";done |sort 
|uniq -c
     20 000
```

可见不等time wait释放就立即重新发起连接时会全部失败

## HTTP 1.0
使用HTTP 1.0发起请求时，由服务端主动关闭tcp连接，time wait状态出现在服务端

### net.ipv4.tcp_tw_reuse = 0
以privileged启动2个容器，宿主机关闭tw_reuse

```
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.0 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";sleep 1;don
e |sort |uniq -c
     20 404
812e320d752c:~# for id in `seq 1 20`;do curl -s --no-keepalive --http1.0 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";done |sort 
|uniq -c
     20 404
```

可见无论是否连续请求，都能成功返回，服务端的time wait状态数量不影响客户端发起连接

## keepalive
http 1.0中默认是关闭的，需要在http头加入"Connection: Keep-Alive"，才能启用Keep-Alive；http 1.1中默认启用Keep-Alive，如果加入"Connection: close "，才关闭。目前大部分浏览器都是用http1.1协议，也就是说默认都会发起Keep-Alive的连接请求了，所以是否能完成一个完整的Keep-Alive连接就看服务器设置情况。(https://www.cnblogs.com/skynet/archive/2010/12/11/1903347.html)

### 使用HTTP1.1长连接
```
812e320d752c:~# for id in `seq 1 20`;do curl -s --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";sleep 1;done |sort |uniq -
c
      9 000
     11 404
# 不等time wait释放继续请求
812e320d752c:~# for id in `seq 1 20`;do curl -s --http1.1 http://172.17.0.2 -o /dev/null -w "%{http_code}\n";done |sort |uniq -c
     20 000
```

## time wait数量上限
local port range 都是11，当启动2个客户端以http 1.0 协议发起请求时，服务端的time wait数量为 22
```
8e063d8387f9:~# ss -ant |grep WAIT |wc -l
22
```
可见服务端可以维护的time wait数量是不受local port限制的

将 `net.ipv4.tcp_max_tw_buckets` 设置为 5
服务端：
```
Every 1s: ss -ant |grep WAIT |wc -l                                                                                2018-07-09 03:31:20

5
```
