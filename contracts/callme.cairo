%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    get_tx_info, get_caller_address, TxInfo, get_block_number)

struct InvokeInfo:
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

@storage_var
func last_invoke_info() -> (res : InvokeInfo):
end

# Returns information about the transaction and the caller
@view
func get_last_invoke_info{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        invoke_info : InvokeInfo):
    let (invoke_info : InvokeInfo) = last_invoke_info.read()
    return (invoke_info)
end

@external
func try_me{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (block_number) = get_block_number()
    let (tx_info : TxInfo*) = get_tx_info()
    let (caller_address) = get_caller_address()

    let invoke_info = InvokeInfo(
        version=tx_info.version,
        account_contract_address=tx_info.account_contract_address,
        chain_id=tx_info.chain_id,
        block_number=block_number,
        caller_address=caller_address)

    last_invoke_info.write(invoke_info)
    return ()
end
