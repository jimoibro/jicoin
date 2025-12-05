# jicoin

A minimal [Clarinet](https://docs.hiro.so/clarinet) project that defines a simple fungible token smart contract called **JICoin** on the Stacks blockchain.

## Project structure

- `Clarinet.toml` – Clarinet project configuration.
- `contracts/jicoin.clar` – JICoin fungible token contract written in Clarity.
- `README.md` – This documentation.

## Smart contract overview

The `jicoin.clar` contract implements a basic fungible token backed by Clarinet’s built-in fungible-token primitives:

- `(define-fungible-token jicoin)` – Declares the JICoin token.
- A single optional `contract-owner` variable that can be set exactly once.
- Restricted minting so only the owner can mint tokens.
- Standard transfer and burn operations.
- Read-only helpers for balances, total supply, and owner.

### State

- `contract-owner : (optional principal)` – The principal that is allowed to mint new JICoin tokens.

### Public functions

- `set-owner (owner principal)` → `(response bool uint)`  
  One-time initializer for the contract owner. Can only be called if no owner is set yet, and the `tx-sender` must equal `owner`.

- `mint (recipient principal) (amount uint)` → `(response bool uint)`  
  Mints `amount` of JICoin to `recipient`. Only callable by the current owner.

- `transfer (sender principal) (recipient principal) (amount uint)` → `(response bool uint)`  
  Transfers `amount` of JICoin from `sender` to `recipient`. The `tx-sender` must match `sender`.

- `burn (owner principal) (amount uint)` → `(response bool uint)`  
  Burns `amount` of JICoin from `owner`’s balance. The `tx-sender` must match `owner` and must have at least `amount` tokens.

### Read-only functions

- `get-owner ()` → `(response (optional principal) uint)`  
  Returns the current `contract-owner` value.

- `is-owner (sender principal)` → `bool`  
  Convenience helper that returns `true` if `sender` is the current owner.

- `get-balance (owner principal)` → `(response uint uint)`  
  Returns the JICoin balance for `owner`.

- `get-total-supply ()` → `(response uint uint)`  
  Returns the total supply of JICoin.

## Getting started

### Prerequisites

- [Clarinet](https://docs.hiro.so/clarinet/getting-started/installation) installed and available on your `PATH`.

You can verify your installation with:

```bash
clarinet --version
```

### Clone and inspect the project

```bash
git clone https://github.com/your-username/jicoin.git
cd jicoin
ls
```

You should see `Clarinet.toml`, `README.md`, and the `contracts/` directory.

## Running checks

From the project root, run:

```bash
clarinet check
```

This will type-check the `jicoin` contract and ensure it compiles successfully with the configured Clarity version.

## Local development tips

- Use `clarinet console` to interactively call contract functions in a REPL-like environment.
- Use `clarinet test` with JavaScript/TypeScript tests under `tests/` if you later add an automated test suite.
- For more advanced deployments and network interactions, refer to the official Clarinet and Stacks documentation.
