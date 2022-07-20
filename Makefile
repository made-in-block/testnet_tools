CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

start:
	@if ! [ -f data/priv_validator_state.json ]; \
		then mkdir -p ./data/ && cp priv_validator_state.json ./data ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID}  docker-compose up

startd:
	@if ! [ -f data/priv_validator_state.json ]; \
		then mkdir -p ./data/ && cp priv_validator_state.json ./data ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID}  docker-compose up -d

stop:
	docker-compose stop

reset:
	docker-compose rm
	rm -f ./config/addrbook.json || true
	rm -f ./config/write-file* || true
	sudo rm -rf ./data/ || true 

restart: reset start