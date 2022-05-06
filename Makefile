.PHONY: build

build:
	mkdir -p artifacts
	starknet-compile contracts/callme.cairo --output artifacts/callme.json --abi artifacts/callme_abi.json

deploy:
	starknet deploy --network=alpha-goerli --contract artifacts/callme.json

deploy-account:
	starknet deploy_account --network=alpha-goerli --wallet=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount --account=demystifyer

get-last-invoke-info:
	starknet call --no_wallet --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function get_last_invoke_info

direct-invoke:
	starknet invoke --no_wallet --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function try_me --inputs 1

direct-invoke-with-different-calldata:
	starknet invoke --no_wallet --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function try_me --inputs 2

account-invoke:
	starknet invoke --wallet=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount --account=demystifyer --network=alpha-goerli --address ${CONTRACT_ADDRESS} --abi artifacts/callme_abi.json --function try_me --inputs 1
