# EVM Contracts for Defx

## Workflow

### Initialization

When the contract is deployed for the first time, the owner can initialize the contract with the following parameters:

1. ERC20 Token Address: The address of the ERC20 token that the contract will be using for deposits and withdrawals.
2. Hot Wallet Address: The address of the hot wallet that will be used to store the funds.

### Deposits & Withdrawals

Deposit and withdrawal transactions are handled by the `submitTransaction` function.

To perform a transaction, the user needs to get their nonce first using:

```
getNonce(address)
```

Then, they can deposit ERC20 tokens into the contract by calling the `submitTransaction` function with the following parameters:

#### Deposit

```
submitTransaction(1, <amount>, nonce)
```

Once the transaction goes through, the contract will transfer the specified amount of ERC20 tokens from the user's wallet to the hot wallet address configured earlier.

In addition to this, the contract will emit an event with the deposit details. This can then be picked up by the off chain sequencer to process the deposit.
Event Format:

```
event TransactionSubmitted(
    address indexed account,
    TransactionType transactionType, // 1 for deposit, 2 for withdrawal
    uint256 amount, // amount of tokens
    unit64 nonce // nonce of the transaction
);
```

#### Withdrawal

```
submitTransaction(2, <amount>, nonce)
```

Once the transaction goes through, the contract will emit an event with the withdrawal details. This can then be picked up by the off chain sequencer to process the withdrawal.
Event Format:

```
event TransactionSubmitted(
    address indexed account,
    TransactionType transactionType, // 1 for deposit, 2 for withdrawal
    uint256 amount, // amount of tokens
    unit64 nonce // nonce of the transaction
);
```

### Other Functions/Metadata

1. `getVersion()`: This function returns the version of the contract.
2. `owner`: This variable returns the address of the contract owner.
3. `paused`: This variable returns the current state of the contract (paused or unpaused). More on pausing/unpausing the contract in the next section.

### Admin Functions

#### Utility Functions

1. `updateHotWallet(address newHotWalletAddress)`: This function allows the owner to update the hot wallet address.
2. `getHotWallet()`: This function allows the owner to get the current hot wallet address.
3. `updateTransactionToken(address newTokenAddress)`: This function allows the owner to update the ERC20 token address.
4. `getTransactionToken()`: This function allows the owner to get the current ERC20 token address.

#### Pausing/Unpausing the Contract

1. `pause()`: This function allows the owner to pause the contract. When the contract is paused, no new deposits or withdrawals can be made while the owner can still update the hot wallet and ERC20 token addresses & perform other functions like upgrading the contract.
2. `unpause()`: This function allows the owner to unpause the contract. When the contract is unpaused, users can make deposits and withdrawals again.

#### Ownership Management

1. `transferOwnership(address newOwner)`: This function allows the current owner to transfer ownership of the contract to a new address.
2. `renounceOwnership()`: This function allows the current owner to renounce ownership of the contract. THIS IS IRREVERSIBLE. Why do we need this? In case the owner wants to give up ownership of the contract and make it fully decentralized.
