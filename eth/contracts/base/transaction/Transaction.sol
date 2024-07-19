// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "./DepositTransaction.sol";
import "./WithdrawTransaction.sol";
import "../..//interfaces/ITransaction.sol";
import "../../common/Errors.sol";

contract Transaction is ITransaction, DepositTransaction, WithdrawTransaction {
    function validateTransaction(
        uint8 transactionType,
        uint256 amount
    ) internal pure {
        if (amount <= 0) {
            revert TransactionAmountShouldBeGreaterThanZero();
        }

        // TODO: is there a better way to validate enum values?
        if (transactionType != 1 && transactionType != 2) {
            revert InvalidTransactionType();
        }
    }

    function getTransactionTypeFromUInt(
        uint8 transactionType
    ) internal pure returns (TransactionType) {
        // TODO: is there a better way to validate enum values?
        if (transactionType == 1) {
            return TransactionType.DepositCollateral;
        } else if (transactionType == 2) {
            return TransactionType.WithdrawCollateral;
        }
        revert InvalidTransactionType();
    }

    function submitDefxTransaction(
        IERC20 token,
        address sender,
        address receiver,
        uint8 transactionType,
        uint256 amount,
        uint64 nonce
    ) internal {
        validateTransaction(transactionType, amount);

        TransactionType txnType = getTransactionTypeFromUInt(transactionType);

        if (txnType == TransactionType.DepositCollateral) {
            handleDeposit(token, sender, receiver, amount);
        } else if (txnType == TransactionType.WithdrawCollateral) {
            handleWithdraw(sender, amount);
        }

        emit TransactionSubmitted(sender, txnType, amount, nonce);
    }
}
