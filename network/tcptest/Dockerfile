FROM alpine:latest

ENV TIMEZONE Asia/Shanghai

RUN mkdir -p /home/wwwroot/ && \
	mkdir -p /run/nginx && \
	mkdir /var/log/supervisor && \
	mkdir /home/nobody && chown -R nobody.nobody /home/nobody && \
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
	sed -ri 's#^(nobody:.*)?:/:(.*)#\1:/home/nobody:\2#g' /etc/passwd

RUN	apk update && \
	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	apk add --no-cache iproute2 nginx curl && \
	rm -rf /var/cache/apk/*

EXPOSE 80
ENTRYPOINT nginx -g "daemon off;"
