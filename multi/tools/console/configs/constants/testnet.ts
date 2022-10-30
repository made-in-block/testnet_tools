import { Chain } from "@chain-registry/types"

export const bitsongTestnetChain: Chain = {
	chain_name: "bitsong",
	status: "live",
	network_type: "testnet",
	website: "https://bitsong.io/",
	pretty_name: "BitSong Testnet",
	chain_id: "bitsong",
	bech32_prefix: "bitsong",
	slip44: 639,
	daemon_name: "bitsongd",
	apis: {
		rpc: [
			{
				address: "http://localhost:26657",
				provider: "bitsong",
			},
		],
		rest: [
			{
				address: "http://localhost:1317",
				provider: "bitsong",
			},
		],
		grpc: [
			{
				address: "http://localhost:26657",
				provider: "selfhost",
			},
		],
	},
}

export const osmosisTestnetChain: Chain = {
	chain_name: "osmosis",
	status: "live",
	network_type: "testnet",
	website: "https://osmosis.zone/",
	pretty_name: "Osmosis Testnet",
	chain_id: "osmosis",
	bech32_prefix: "osmo",
	slip44: 118,
	daemon_name: "osmosisd",
	apis: {
		rpc: [
			{
				address: "http://localhost:27657",
				provider: "osmosis",
			},
		],
		rest: [
			{
				address: "http://localhost:1417",
				provider: "osmosis",
			},
		],
		grpc: [
			{
				address: "http://localhost:27657",
				provider: "osmosis",
			},
		],
	},
}
