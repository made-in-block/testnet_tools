#!/bin/sh

CHAIN_ID=osmosis
CHAIN_DIR=/$CHAIN_ID/.osmosisd
CONFIG_DIR=$CHAIN_DIR/config
CHAIN_BIN=osmosisd
GENESIS_COINS=100000000000uosmo,100000000000uion,100000000000stake
VALIDATOR_COIN=1000000000000uosmo,1000000000000uion,1000000000000stake
MONIKER=validator1

MNEMONIC="bottom loan skill merry east cradle onion journey palm apology verb edit desert impose absurd oil bubble sweet glove shallow size build burst effort"
MNEMONIC_POOLS="traffic cool olive pottery elegant innocent aisle dial genuine install shy uncle ride federal soon shift flight program cave famous provide cute pole struggle"

edit_config () {
    echo "Edit config..."

    # Remove seeds
    dasel put string -f $CONFIG_DIR/config.toml '.p2p.seeds' ''

    # Expose the rpc
    dasel put string -f $CONFIG_DIR/config.toml '.rpc.laddr' "tcp://0.0.0.0:26657"

    # Reduce timeout
    dasel put string -f $CONFIG_DIR/config.toml '.consensus.timeout_commit' '1s'
    dasel put string -f $CONFIG_DIR/config.toml '.consensus.timeout_propose' '1s'

    # Enable API
    dasel put string -f $CONFIG_DIR/app.toml '.api.enable' 'true'
    dasel put string -f $CONFIG_DIR/app.toml '.api.swagger' 'true'
    dasel put string -f $CONFIG_DIR/app.toml '.api.enabled-unsafe-cors' 'true'
}

edit_genesis () {
    echo "Edit genesis..."

    GENESIS=$CONFIG_DIR/genesis.json

    # Update staking module
    dasel put string -f $GENESIS '.app_state.staking.params.bond_denom' 'uosmo'
    dasel put string -f $GENESIS '.app_state.staking.params.unbonding_time' '240s'

    # Update crisis module
    dasel put string -f $GENESIS '.app_state.crisis.constant_fee.denom' 'uosmo'

    # Udpate gov module
    dasel put string -f $GENESIS '.app_state.gov.voting_params.voting_period' '60s'
    dasel put string -f $GENESIS '.app_state.gov.deposit_params.min_deposit.[0].denom' 'uosmo'

    # Update epochs module
    dasel put string -f $GENESIS '.app_state.epochs.epochs.[1].duration' "60s"

    # Update poolincentives module
    dasel put string -f $GENESIS '.app_state.poolincentives.lockable_durations.[0]' "120s"
    dasel put string -f $GENESIS '.app_state.poolincentives.lockable_durations.[1]' "180s"
    dasel put string -f $GENESIS '.app_state.poolincentives.lockable_durations.[2]' "240s"
    dasel put string -f $GENESIS '.app_state.poolincentives.params.minted_denom' "uosmo"

    # Update incentives module
    dasel put string -f $GENESIS '.app_state.incentives.lockable_durations.[0]' "1s"
    dasel put string -f $GENESIS '.app_state.incentives.lockable_durations.[1]' "120s"
    dasel put string -f $GENESIS '.app_state.incentives.lockable_durations.[2]' "180s"
    dasel put string -f $GENESIS '.app_state.incentives.lockable_durations.[3]' "240s"
    dasel put string -f $GENESIS '.app_state.incentives.params.distr_epoch_identifier' "day"

    # Update mint module
    dasel put string -f $GENESIS '.app_state.mint.params.mint_denom' "uosmo"
    dasel put string -f $GENESIS '.app_state.mint.params.epoch_identifier' "day"

    # Update gamm module
    dasel put string -f $GENESIS '.app_state.gamm.params.pool_creation_fee.[0].denom' "uosmo"

    # Update txfee basedenom
    dasel put string -f $GENESIS '.app_state.txfees.basedenom' "uosmo"

    # Update wasm permission (Nobody or Everybody)
    dasel put string -f $GENESIS '.app_state.wasm.params.code_upload_access.permission' "Everybody"
}

add_genesis_accounts () {
    echo "Add genesis accounts..."
    
    $CHAIN_BIN add-genesis-account osmo12smx2wdlyttvyzvzg54y2vnqwq2qjateuf7thj $VALIDATOR_COIN --home $CHAIN_DIR
    $CHAIN_BIN add-genesis-account osmo1jllfytsz4dryxhz5tl7u73v29exsf80vz52ucc $GENESIS_COINS --home $CHAIN_DIR

    echo $MNEMONIC | $CHAIN_BIN keys add $MONIKER --recover --keyring-backend=test --home $CHAIN_DIR
    echo $MNEMONIC_POOLS | $CHAIN_BIN keys add pools --recover --keyring-backend=test --home $CHAIN_DIR
    $CHAIN_BIN gentx $MONIKER 500000000uosmo --keyring-backend=test --chain-id=$CHAIN_ID --home $CHAIN_DIR

    $CHAIN_BIN collect-gentxs --home $CHAIN_DIR
}

if [ ! -d $CONFIG_DIR ]
then
    echo "Init chain config..."

    echo $MNEMONIC | $CHAIN_BIN init -o --chain-id=$CHAIN_ID --home $CHAIN_DIR --recover $MONIKER
    
    edit_genesis
    add_genesis_accounts
    edit_config
fi

$CHAIN_BIN start --home $CHAIN_DIR &

wait