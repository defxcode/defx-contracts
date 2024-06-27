// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
// TODO: does this need to be upgradeable as well?
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract DepositTransaction {
    using SafeERC20 for IERC20;

    function handleDeposit(
        IERC20 token,
        address sender,
        address receiver,
        uint256 amount
    ) internal {
        // TODO: DFX-1054 send to clearing house
        token.safeTransferFrom(sender, receiver, amount);
    }
}
