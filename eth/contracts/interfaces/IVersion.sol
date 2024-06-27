// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IVersion {
    function getVersion() external view returns (uint64);
}
