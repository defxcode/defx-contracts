// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./IVersion.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

interface IDefx {
    function submitTransaction(
        uint8 transactionType,
        uint256 amount,
        uint64 nonce
    ) external;

    function updateTransactionToken(address erc20Contract) external;
    function getTransactionToken() external view returns (address);

    function updateHotWallet(address hotWalletAddress) external;
    function getHotWallet() external view returns (address);

    function getNonce(address account) external view returns (uint64);
}
