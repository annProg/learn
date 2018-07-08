IMAGENAME ?= tcptest
TAG ?= latest
IMAGE = $(IMAGENAME)

all: build up

build:
	docker build -t $(IMAGE):$(TAG) .
up:
	docker run -d --privileged=true --sysctl net.ipv4.ip_local_port_range=1024\ 1034  $(IMAGE)

