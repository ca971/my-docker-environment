DOCKER=/usr/local/bin/docker

DOCKER_MACHINE=/usr/local/bin/docker-machine
DOCKER_MACHINE_CREATE_ARGS:=create
DOCKER_MACHINE_START_ARGS:=start

DOCKER_MACHINE_NAME:=default
DOCKER_MACHINE_IP=$(shell docker-machine ip $(DOCKER_MACHINE_NAME))

DOCKER_COMPOSE=/usr/local/bin/docker-compose
DOCKER_COMPOSE_UP_ARGS:= -d

DOCKER_DNS_DOMAIN:=docker.local

ENV_VARS= DOCKER_DNS_DOMAIN=$(DOCKER_DNS_DOMAIN) DOCKER_MACHINE_IP=$(DOCKER_MACHINE_IP)

machine: machine-vmware resolver

machine-vmware:
	$(DOCKER_MACHINE) \
		$(DOCKER_MACHINE_CREATE_ARGS) \
    --driver vmwarefusion \
    --vmwarefusion-cpu-count 2 \
    --vmwarefusion-disk-size 80000 \
    --vmwarefusion-memory-size 4096 \
    $(DOCKER_MACHINE_NAME)

machine-virtualbox:
	$(DOCKER_MACHINE) \
		$(DOCKER_MACHINE_CREATE_ARGS) \
    --driver virtualbox \
    --virtualbox-cpu-count 2 \
    --virtualbox-disk-size 80000 \
    --virtualbox-memory 4096 \
    $(DOCKER_MACHINE_NAME)

resolver:
	sudo mkdir -p /etc/resolver
	echo "nameserver $(shell docker-machine ip $(DOCKER_MACHINE_NAME))" | sudo tee /etc/resolver/$(DOCKER_DNS_DOMAIN)
	echo "nameserver $(shell docker-machine ip $(DOCKER_MACHINE_NAME))\n\nport 8600" | sudo tee /etc/resolver/local.consul

machine:
	$(DOCKER_MACHINE) \
		$(DOCKER_MACHINE_START_ARGS) \
		$(DOCKER_MACHINE_NAME)

up:
	$(ENV_VARS)	\
		$(DOCKER_COMPOSE) \
		up $(DOCKER_COMPOSE_UP_ARGS)

start:
	$(ENV_VARS)	\
		$(DOCKER_COMPOSE) \
		start

rmf:
	$(ENV_VARS) \
		$(DOCKER_COMPOSE) \
		rm --force

compose:
	$(ENV_VARS)	\
		$(DOCKER_COMPOSE)

stop rm logs ps version build:
	$(ENV_VARS) \
		$(DOCKER_COMPOSE) \
		$@

rebuild: stop rmf up
