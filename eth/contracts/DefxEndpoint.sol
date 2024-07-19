// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "./interfaces/IDefxEndpoint.sol";
import "./base/transaction/Transaction.sol";
import "./base/Version.sol";

contract DefxEndpoint is
    IDefxEndpoint,
    Transaction,
    Initializable,
    PausableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    Version
{
    IERC20 private transactionToken;
    address private hotWallet;

    mapping(address => uint64) internal nonces;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner,
        address erc20Contract,
        address hotWalletAddress
    ) public initializer {
        __Pausable_init();
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        // initialize the ERC20 token used to deposit/withdraw
        transactionToken = IERC20(erc20Contract);

        // initialize the hot wallet address
        hotWallet = hotWalletAddress;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     *
     * @param transactionType The type of transaction to submit. Can be either 1 (Deposit) or 2 (Withdraw)
     * @param amount The amount to deposit or withdraw. Must be greater than 0
     */
    function submitTransaction(
        uint8 transactionType,
        uint256 amount,
        uint64 nonce
    ) external override whenNotPaused {
        validateNonce(msg.sender, nonce);

        submitDefxTransaction(
            transactionToken,
            msg.sender,
            hotWallet,
            transactionType,
            amount,
            nonce
        );
    }

    /**
     *
     * @param erc20Contract The address of the ERC20 token contract to use for transactions
     */
    function updateTransactionToken(
        address erc20Contract
    ) external override onlyOwner {
        transactionToken = IERC20(erc20Contract);
    }

    /**
     *
     * Get the address of the ERC20 token contract used for transactions
     */
    function getTransactionToken()
        external
        view
        override
        onlyOwner
        returns (address)
    {
        return address(transactionToken);
    }

    /**
     *
     * Update the address of the hot wallet to use for transactions
     *
     * @param hotWalletAddress The address of the hot wallet to use for transactions
     */
    function updateHotWallet(
        address hotWalletAddress
    ) public override onlyOwner {
        hotWallet = hotWalletAddress;
    }

    /**
     *
     * Get the address of the hot wallet used for transactions
     */
    function getHotWallet() public view override onlyOwner returns (address) {
        return hotWallet;
    }

    /**
     *
     * @param account the account for which to validate the nonce
     * @param nonce the nonce to validate
     */
    function validateNonce(address account, uint64 nonce) internal {
        if (++nonces[account] != nonce) {
            revert InvalidNonce();
        }
    }

    /**
     *
     * @param account the account for which to get the nonce
     */
    function getNonce(address account) public view override returns (uint64) {
        return nonces[account];
    }
}
