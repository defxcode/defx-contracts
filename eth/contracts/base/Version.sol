// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "../common/Constants.sol";
import "../interfaces/IVersion.sol";

contract Version is IVersion {
    function getVersion() external pure returns (uint64) {
        return VERSION;
    }
}
