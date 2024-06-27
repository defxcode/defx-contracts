// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface ITransaction {
    event TransactionSubmitted(
        address indexed account,
        TransactionType transactionType,
        uint256 amount,
        uint64 nonce
    );

    // TODO: figure out if we can upgrade this later
    enum TransactionType {
        Undefined, // A transaction type that is not defined. This is to make sure that default uint value is not used by default
        Deposit,
        Withdraw
    }
}
