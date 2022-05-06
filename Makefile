.PHONY: build

build:
	mkdir -p artifacts
	starknet-compile contracts/callme.cairo --output artifacts/callme.json --abi artifacts/callme_abi.json

deploy:
	starknet deploy --network=alpha-goerli --contract artifacts/callme.json

deploy-account:
	export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
	starknet deploy_account --wallet=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount --account=demystifyer

get-last-invoke-info:
	starknet call --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function get_last_invoke_info

direct-invoke:
	starknet invoke --no_wallet --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function try_me

account-invoke:
	export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
	starknet invoke --wallet=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount --account=demystifyer --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function try_me
