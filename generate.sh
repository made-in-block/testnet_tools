#!/bin/sh

# Set variables
BITSONG_DIR=./bitsong
BITSONG_BIN=bitsongd
BITSONG_CHAIN_ID=bitsong
BITSONG_GENESIS_COINS=1000000000000000ubtsg
BITSONG_VALIDATOR_COIN=1000000000ubtsg

OSMOSIS_DIR=./osmosis
OSMOSIS_BIN=osmosisd
OSMOSIS_CHAIN_ID=osmosis
OSMOSIS_GENESIS_COINS=1000000000000000uosmo
OSMOSIS_VALIDATOR_COIN=1000000000uosmo

MNEMONIC_1="guard cream sadness conduct invite crumble clock pudding hole grit liar hotel maid produce squeeze return argue turtle know drive eight casino maze host"
MNEMONIC_2="friend excite rough reopen cover wheel spoon convince island path clean monkey play snow number walnut pull lock shoot hurry dream divide concert discover"
MNEMONIC_3="fuel obscure melt april direct second usual hair leave hobby beef bacon solid drum used law mercy worry fat super must ritual bring faculty"

# Remove previous data
rm -rf $BITSONG_DIR
rm -rf $OSMOSIS_DIR

# Add directory for chains, exit if error
if ! mkdir -p $BITSONG_DIR 2>/dev/null; then
    echo "Failed to create chain folder. Aborting..."
    exit 1
fi

if ! mkdir -p $OSMOSIS_DIR 2>/dev/null; then
    echo "Failed to create chain folder. Aborting..."
    exit 1
fi

# Initialize bitsong
echo "Initializing $BITSONG_CHAIN_ID..."
$BITSONG_BIN --home $BITSONG_DIR init validator1 --chain-id=$BITSONG_CHAIN_ID

echo "Adding $BITSONG_CHAIN_ID genesis accounts..."
echo $MNEMONIC_1 | $BITSONG_BIN --home $BITSONG_DIR keys add validator --recover --keyring-backend=test 
echo $MNEMONIC_2 | $BITSONG_BIN --home $BITSONG_DIR keys add user1 --recover --keyring-backend=test 
echo $MNEMONIC_3 | $BITSONG_BIN --home $BITSONG_DIR keys add user2 --recover --keyring-backend=test 
$BITSONG_BIN --home $BITSONG_DIR add-genesis-account $($BITSONG_BIN --home $BITSONG_DIR keys show validator --keyring-backend test -a) $BITSONG_GENESIS_COINS
$BITSONG_BIN --home $BITSONG_DIR add-genesis-account $($BITSONG_BIN --home $BITSONG_DIR keys show user1 --keyring-backend test -a) $BITSONG_GENESIS_COINS
$BITSONG_BIN --home $BITSONG_DIR add-genesis-account $($BITSONG_BIN --home $BITSONG_DIR keys show user2 --keyring-backend test -a) $BITSONG_GENESIS_COINS

echo "Creating and collecting gentx $BITSONG_CHAIN_ID..."
$BITSONG_BIN --home $BITSONG_DIR gentx validator $BITSONG_VALIDATOR_COIN --chain-id $BITSONG_CHAIN_ID --keyring-backend test
$BITSONG_BIN --home $BITSONG_DIR collect-gentxs

echo "Prepare genesis $BITSONG_CHAIN_ID..."
$BITSONG_BIN --home $BITSONG_DIR prepare-genesis mainnet $BITSONG_CHAIN_ID

echo "Change settings in genesis.json file $BITSONG_CHAIN_ID..."
#sed -i 's/"voting_period": "172800s"/"voting_period": "20s"/g' $CHAIN_DIR/$CHAIN_ID/config/genesis.json

echo "Change settings in config.toml file $BITSONG_CHAIN_ID..."
#sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:'"$RPC_PORT"'"#g' $CHAIN_DIR/$CHAIN_ID/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' $BITSONG_DIR/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' $BITSONG_DIR/config/config.toml
sed -i 's/index_all_keys = false/index_all_keys = true/g' $BITSONG_DIR/config/config.toml

echo "Change settings in app.toml file $BITSONG_CHAIN_ID..."
sed -i 's/enable = false/enable = true/g' $BITSONG_DIR/config/app.toml
sed -i 's/swagger = false/swagger = true/g' $BITSONG_DIR/config/app.toml

# Initialize osmosis
echo "Initializing $OSMOSIS_CHAIN_ID..."
$OSMOSIS_BIN --home $OSMOSIS_DIR init validator1 --chain-id=$OSMOSIS_CHAIN_ID

echo "Adding $OSMOSIS_CHAIN_ID genesis accounts..."
echo $MNEMONIC_1 | $OSMOSIS_BIN --home $OSMOSIS_DIR keys add validator --recover --keyring-backend=test 
echo $MNEMONIC_2 | $OSMOSIS_BIN --home $OSMOSIS_DIR keys add user1 --recover --keyring-backend=test 
echo $MNEMONIC_3 | $OSMOSIS_BIN --home $OSMOSIS_DIR keys add user2 --recover --keyring-backend=test 
$OSMOSIS_BIN --home $OSMOSIS_DIR add-genesis-account $($OSMOSIS_BIN --home $OSMOSIS_DIR keys show validator --keyring-backend test -a) $OSMOSIS_GENESIS_COINS
$OSMOSIS_BIN --home $OSMOSIS_DIR add-genesis-account $($OSMOSIS_BIN --home $OSMOSIS_DIR keys show user1 --keyring-backend test -a) $OSMOSIS_GENESIS_COINS
$OSMOSIS_BIN --home $OSMOSIS_DIR add-genesis-account $($OSMOSIS_BIN --home $OSMOSIS_DIR keys show user2 --keyring-backend test -a) $OSMOSIS_GENESIS_COINS

echo "Creating and collecting gentx $OSMOSIS_CHAIN_ID..."
$OSMOSIS_BIN --home $OSMOSIS_DIR gentx validator $OSMOSIS_VALIDATOR_COIN --chain-id $OSMOSIS_CHAIN_ID --keyring-backend test
$OSMOSIS_BIN --home $OSMOSIS_DIR collect-gentxs

echo "Prepare genesis $OSMOSIS_CHAIN_ID..."
$OSMOSIS_BIN --home $OSMOSIS_DIR prepare-genesis mainnet $OSMOSIS_CHAIN_ID

echo "Change settings in genesis.json file $OSMOSIS_CHAIN_ID..."
#sed -i 's/"voting_period": "172800s"/"voting_period": "20s"/g' $CHAIN_DIR/$CHAIN_ID/config/genesis.json

echo "Change settings in config.toml file $OSMOSIS_CHAIN_ID..."
#sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:'"$RPC_PORT"'"#g' $CHAIN_DIR/$CHAIN_ID/config/config.toml
sed -i 's/seeds = ".*"/seeds = ""/g' $OSMOSIS_DIR/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' $OSMOSIS_DIR/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' $OSMOSIS_DIR/config/config.toml
sed -i 's/index_all_keys = false/index_all_keys = true/g' $OSMOSIS_DIR/config/config.toml

echo "Change settings in app.toml file $OSMOSIS_CHAIN_ID..."
sed -i 's/enable = false/enable = true/g' $OSMOSIS_DIR/config/app.toml
sed -i 's/swagger = false/swagger = true/g' $OSMOSIS_DIR/config/app.toml