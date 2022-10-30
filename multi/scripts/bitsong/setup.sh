#!/bin/sh

CHAIN_ID=bitsong
CHAIN_DIR=/$CHAIN_ID/.bitsongd
CONFIG_DIR=$CHAIN_DIR/config
CHAIN_BIN=bitsongd
GENESIS_COINS=1000000000000000ubtsg
VALIDATOR_COIN=1000000000ubtsg
MONIKER=validator1

MNEMONIC="bottom loan skill merry east cradle onion journey palm apology verb edit desert impose absurd oil bubble sweet glove shallow size build burst effort"
MNEMONIC_FAUCET="tackle fruit urban stand chunk image monkey burger purse feel acquire polar radar moment negative pupil winter chef steak ladder tail town expose west"

edit_config () {
    echo "Edit config..."

    # Remove seeds
    dasel put string -f $CONFIG_DIR/config.toml '.p2p.seeds' ''

    # Expose the rpc
    dasel put string -f $CONFIG_DIR/config.toml '.rpc.laddr' "tcp://0.0.0.0:26657"
    dasel put string -f $CONFIG_DIR/config.toml '.rpc.cors_allowed_origins' "*"

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
    dasel put string -f $GENESIS '.app_state.staking.params.bond_denom' 'ubtsg'
    dasel put string -f $GENESIS '.app_state.staking.params.unbonding_time' '240s'

    # Update crisis module
    dasel put string -f $GENESIS '.app_state.crisis.constant_fee.denom' 'ubtsg'

    # Udpate gov module
    dasel put string -f $GENESIS '.app_state.gov.voting_params.voting_period' '60s'
    dasel put string -f $GENESIS '.app_state.gov.deposit_params.min_deposit.[0].denom' 'ubtsg'

    # Update mint module
    dasel put string -f $GENESIS '.app_state.mint.params.mint_denom' 'ubtsg'

    # Update fantoken module
    dasel put string -f $GENESIS '.app_state.fantoken.params.burn_fee.denom' 'ubtsg'
    dasel put string -f $GENESIS '.app_state.fantoken.params.issue_fee.denom' 'ubtsg'
    dasel put string -f $GENESIS '.app_state.fantoken.params.mint_fee.denom' 'ubtsg'

    # Update merkledrop module
    dasel put string -f $GENESIS '.app_state.merkledrop.params.creation_fee.denom' 'ubtsg'
}

add_genesis_accounts () {
    echo "Add genesis accounts..."

    $CHAIN_BIN add-genesis-account bitsong1gws6wz8q5kyyu4gqze48fwlmm4m0mdjz0620gw 1000000000ubtsg --home $CHAIN_DIR
    $CHAIN_BIN add-genesis-account bitsong1ermg6v2remlagtq7l32kjwc9vglvc2ytdfx89j 100000000000ubtsg --home $CHAIN_DIR

    echo $MNEMONIC | $CHAIN_BIN keys add $MONIKER --recover --keyring-backend=test --home $CHAIN_DIR
    echo $MNEMONIC_FAUCET | $CHAIN_BIN keys add faucet --recover --keyring-backend=test --home $CHAIN_DIR

    $CHAIN_BIN gentx $MONIKER 500000000ubtsg --keyring-backend=test --chain-id=$CHAIN_ID --home $CHAIN_DIR

    $CHAIN_BIN collect-gentxs --home $CHAIN_DIR
}

if [ ! -d $CONFIG_DIR ]
then
    echo "Init chain config..."

    echo $MNEMONIC | $CHAIN_BIN init -o --chain-id=$CHAIN_ID --home $CHAIN_DIR --recover $MONIKER
    
    edit_config
    edit_genesis
    add_genesis_accounts
fi

$CHAIN_BIN start --home $CHAIN_DIR &

wait