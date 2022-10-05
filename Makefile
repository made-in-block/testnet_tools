CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

build:
	env UID=${CURRENT_UID} GID=${CURRENT_GID}  docker-compose build

start:
	@if ! [ -f bitsong/data/priv_validator_state.json ]; \
		then mkdir -p ./bitsong/data/ && cp ./helpers/priv_validator_state.json ./bitsong/data ; \
	fi
	@if ! [ -f osmosis/data/priv_validator_state.json ]; \
		then mkdir -p ./osmosis/data/ && cp ./helpers/priv_validator_state.json ./osmosis/data ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID}  docker-compose up

startd:
	@if ! [ -f bitsong/data/priv_validator_state.json ]; \
		then mkdir -p ./bitsong/data/ && cp ./helpers/priv_validator_state.json ./bitsong/data ; \
	fi
	@if ! [ -f osmosis/data/priv_validator_state.json ]; \
		then mkdir -p ./osmosis/data/ && cp ./helpers/priv_validator_state.json ./osmosis/data ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID}  docker-compose up -d

stop:
	docker-compose stop

reset:
	docker-compose rm
	rm -f ./bitsong/config/addrbook.json || true
	rm -f ./bitsong/config/write-file* || true
	rm -rf ./bitsong/data/ || true 
	rm -f ./osmosis/config/addrbook.json || true
	rm -f ./osmosis/config/write-file* || true
	rm -rf ./osmosis/data/ || true 