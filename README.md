# demystifying-starknet-accounts
Demystifying StarkNet accounts

## Set up

### Requirements

- [Python <=3.8](https://www.python.org/downloads/)

### 📦 Install

```bash
python -m venv env
source env/bin/activate
pip install cairo-lang
```

### ⛏️ Compile

```bash
make
```

### 🔧 Prepare the environement

```bash
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
```

### 🚀 Deploy the contract

First, deploy the contract that will be used for test. This is the target contract we will be invoking.

```bash
make deploy
```

**Save the `contract address` in `CONTRACT_ADDRESS` environement variable.**

```bash
export CONTRACT_ADDRESS=<the-contract-address-coming-from-the-output-of-make-deploy>
```

### 🚀 Deploy the account contract

Now, deploy the account contract. This is a contract like any other, except that it fullfils some interface that makes it 
usable by a wallet, as an account contract.

```bash
make deploy-account
```

Check the transaction has been accepted on L2 or L1 (wait until it is the case): `starknet get_transaction --hash <transaction-hash>`.

**Once the transaction has been accepted on L2 or L1**, go to [https://faucet.goerli.starknet.io/](https://faucet.goerli.starknet.io/) and copy-paste the account contract address to get some ETH.

You'll need it to pay fees.
Wait until the request is complete.
If you get `FEE_TRANSFER_FAILURE` errors while trying some commands below, just return to the faucet and ask for more ETH.


## Usage

The idea is to use the following commands in order to understand what is happening when you invoke a contract directly vs. 
when you invoke it through an account.

### Retrieve information about the last invokation

```bash
make get-last-invoke-info
```

This command returns information about the last invokation to the contract.
The structure of returned information is:

```cairo
struct InvokeInfo:
    # Id of the invokation. This is incremented everytime try_me is being invoked.
    member id : felt

    # The version of the transaction. It is fixed (currently, 0) in the OS, and should be
    # signed by the account contract.
    # This field allows invalidating old transactions, whenever the meaning of the other
    # transaction fields is changed (in the OS).
    member version : felt

    # The account contract from which this transaction originates.
    member account_contract_address : felt

    # The identifier of the chain.
    # This field can be used to prevent replay of testnet transactions on mainnet.
    member chain_id : felt

    # The block number in which the transaction occured
    member block_number : felt

    # The caller address as seen by the called contract
    member caller_address : felt
end
```

### Invoke the contract without using an account

```bash
make direct-invoke
```

Keep the transaction hash. You will notice that executing this command multiple times will always generate the same transaction
hash.

Check the transaction has been accepted on L2 or L1 (wait until it is the case): `starknet get_transaction --hash <transaction-hash>`.

**Once the transaction has been accepted on L2 or L1**, execute `make get-last-invoke-info` to retrieve interesting information about this invokation.

You should notice that the `caller_address` is 0, and the `account_contract_address` is the address of the contract itself.

If you try to call `make direct-invoke` again, the same transaction hash will be returned.

### Invoke the contract without using an account, but with different calldata

```bash
make direct-invoke-with-different-calldata
```

Note that the transaction hash is different than the one returned by `make direct-invoke`. This is because we invoked the contract's function with different parameter (ie. different calldata).

### Invoke the contract using an account

```bash
make account-invoke
```

Note the transaction hash. You will notice that executing this command multiple times will give you a different transaction
hash everytime.

Check the transaction has been accepted on L2 or L1 (wait until it is the case): `starknet get_transaction --hash <transaction-hash>`.

**Once the transaction has been accepted on L2 or L1**, execute `make get-last-invoke-info` to retrieve interesting information about this invokation.

You should notice that the `caller_address` is equal to the `account_contract_address`, which is the address of the account contract.
