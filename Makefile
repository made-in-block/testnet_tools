CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

build:
	docker-compose build

start:
	@if ! [ -d osmosis ]; \
		then mkdir ./osmosis ; \
	fi
	@if ! [ -d bitsong ]; \
		then mkdir ./bitsong ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID} docker-compose up

startd:
	@if ! [ -d osmosis ]; \
		then mkdir ./osmosis ; \
	fi
	@if ! [ -d bitsong ]; \
		then mkdir ./bitsong ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID}  docker-compose up -d

stop:
	docker-compose stop

reset:
	docker-compose rm
	rm -rf ./bitsong || true
	rm -rf ./osmosis || true 