#!/bin/sh

HERMES_DIR=/hermes/.hermes

init () {
    echo "Restore relayer keys..."

    hermes keys add --chain osmosis --key-file /tmp/key.osmosis.json
    hermes keys add --chain bitsong --key-file /tmp/key.bitsong.json --hd-path "m/44'/639'/0'/0/0"

    echo "Create transfer channel..."

    hermes create channel --a-chain bitsong --b-chain osmosis --a-port transfer --b-port transfer --new-client-connection --yes
}

sleep 15

if [ ! -d $HERMES_DIR/keys ]
then
    echo "Init hermes..."

    init
fi

hermes start &

wait