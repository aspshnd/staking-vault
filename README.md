# StakingVault

Kontrak staking ETH dengan reward 1% per hari, dibangun dan diaudit mandiri menggunakan Foundry.

## Deployed Contract (Sepolia Testnet)
- Address: `0xFEc01fc30D292bF1178f9Ca078Ba96f95DBD600f`
- [Lihat di Etherscan](https://sepolia.etherscan.io/address/0xFEc01fc30D292bF1178f9Ca078Ba96f95DBD600f)

## Fitur
- Stake/withdraw ETH dengan reward berjalan seiring waktu
- Pola Checks-Effects-Interactions untuk mencegah reentrancy
- Access control dengan modifier `onlyOwner`
- Reward pool terpisah dari pokok staker (`totalStaked` vs `availableRewardPool()`)

## Test
```bash
forge test -vv
```

5 test mencakup: staking, perhitungan reward berbasis waktu, dan validasi reward pool.

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

### Build
```bash
forge build
```

### Test
```bash
forge test
```
