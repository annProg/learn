IMAGENAME ?= tcptest
TAG ?= latest
IMAGE = $(IMAGENAME)

all: build up

build:
	docker build -t $(IMAGE):$(TAG) .
up:
	docker run -d --privileged=true --sysctl net.ipv4.ip_local_port_range=1024\ 1026 -p 8999:80 --name tcptest-proxy  $(IMAGE);
	docker run -d --privileged=true --sysctl net.ipv4.ip_local_port_range=1024\ 1034 --name tcptest-webserver $(IMAGE);
	docker run -d --privileged=true --sysctl net.ipv4.ip_local_port_range=1024\ 10340 --name tcptest-client $(IMAGE);
clean:
	docker stop tcptest-proxy tcptest-webserver tcptest-client;
	docker rm tcptest-proxy tcptest-webserver tcptest-client;
