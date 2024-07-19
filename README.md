# EVM Contracts for Defx

## Depositing & Withdrawing Collateral

> Currently, the contract supports only USDC token for deposits and withdrawals.

Deposit and withdrawal transactions are handled by the `submitTransaction` function.

To perform a transaction, the user needs to get their nonce first using:

```
getNonce(address)
```

Then, they can deposit ERC20 tokens into the contract by calling the `submitTransaction` function with the following parameters:

#### Deposit Collateral

Depositing via contract involves a one time step where the user have to set allowance for the contract to spend ERC20 Token via the contract

```
approve(<contract address>, <amount>)
```

---

```
submitTransaction(1, <amount>, nonce)
```

> The value of nonce should be the next nonce returned from the getNonce address. The nonce should be unique for each transaction.

Once the transaction goes through, the contract will transfer the specified amount of ERC20 tokens from the user's wallet to the Defx

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
