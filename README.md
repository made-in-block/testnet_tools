# Docker 4 BitSong

This repository contains docker helpers utility for `go-bitsong`

## Prerequisites

- [`Docker`](https://www.docker.com/)
- [`docker-compose`](https://github.com/docker/compose)

## Install Docker Utility

1. Run the following commands::

```sh
git clone https://github.com/bitsongofficial/docker.git
cd docker
```

2. Make sure your Docker daemon is running in the background and [`docker-compose`](https://github.com/docker/compose) is installed.

If running on linux, you can install these tools with the following commands:

- docker
```
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt install docker.io -y
```
- docker-compose
```
sudo apt install docker-compose -y
```

## Start, stop, and reset `go-bitsong`

- Start `go-bitsong`:

```sh
make start
```

Your environment now contains:

- [go-bitsong](http://github.com/bitsongofficial/go-bitsong) RPC node running on `tcp://localhost:26657`
- LCD running on http://localhost:1317

Stop `go-bitsong` (and retain chain data):

```sh
make stop
```

Stop `go-bitsong` (and delete chain data):

```sh
make restart
```

### Modifying node configuration

You can modify the node configuration of your validator in the `config/config.toml` and `config/app.toml` files.

#### Pro tip: Speed Up Block Time

To decrease block time, edit the `[consensus]` parameters in the `config/config.toml` file, and specify your own values.

The following example configures all timeouts to `200ms`:

```diff
##### consensus configuration options #####
[consensus]

wal_file = "data/cs.wal/wal"
- timeout_propose = "3s"
- timeout_propose_delta = "500ms"
- timeout_prevote = "1s"
- timeout_prevote_delta = "500ms"
- timeout_precommit_delta = "500ms"
- timeout_commit = "5s"
+ timeout_propose = "200ms"
+ timeout_propose_delta = "200ms"
+ timeout_prevote = "200ms"
+ timeout_prevote_delta = "200ms"
+ timeout_precommit_delta = "200ms"
+ timeout_commit = "200ms"
```

Additionally, you can use the following single line to configure timeouts:

```sh
sed -E -i '/timeout_(propose|prevote|precommit|commit)/s/[0-9]+m?s/200ms/' config/config.toml
```

### Modifying genesis

You can change the `genesis.json` file by altering `config/genesis.json`. To load your changes, restart your LocalOsmosis.

## Accounts

LocalOsmosis is pre-configured with one validator and 10 accounts with ION and OSMO balances.

| Account   | Address                                                                                                  | Mnemonic                                                                                                                                                                   |
| --------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| validator | `bitsong1app8yxq5fth6x45cm74k0d07gg586qmdee42el`<br/>`bitsongvaloper1pnudhva4k9xvpyz55qv69pgcuglwpnc2em2x96` | `human visual corn anchor pond buffalo limit radar used winner orphan taxi library warm finger pattern doctor disagree ask minimum frequent electric foam program`                    |
| user1     | `bitsong1zwyt5styty8aa9snray69jtnyhhntq3yuvdpce`                                                           | `satisfy town rack armed black belt equip ribbon such course drip float measure nature shift gospel flight monster abuse daughter stone canyon picnic satisfy`                       |
| user2     | `bitsong1whd73l9dkkey8ru8vj8rvzgxt5pm2kd8sz6wuy`                                                           | `idle popular match scissors news pumpkin slush legend cup one estate purchase drill history cheese field liar follow ripple gown since skate dirt stone`              |
| user3     | `bitsong15wvtc7c9ujew5zn7p6ym7s7wkywvemgek708lt`                                                           | `orient suit behave effort curious skate wild parade about sing farm such teach gesture chest size flavor evil shrug slush canoe fold trumpet muffin`        |

## Common issues

### Docker permissions problems

In case you get permission denied while trying to run `make start`

```
make start

Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/containers/json: dial unix /var/run/docker.sock: connect: permission denied
```

**Check that the docker engine is running:**

```bash
sudo systemctl status docker
```

If not:

```bash
# Configure Docker to start on boot
sudo systemctl enable docker.service

# Start docker service
sudo systemctl start docker.service
```

**Ensure that the current user is in the `docker` group:**

1. Create the docker group and add your user

```bash
# Create the docker group
sudo groupadd docker

# Add your user to the docker group.
sudo usermod -aG docker $USER
```

2. Log out and log back in so that your group membership is re-evaluated.

More details can be found [here](https://docs.docker.com/engine/install/linux-postinstall/).