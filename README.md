# ⛓️ Forge Protocol

> The decentralized, immutable core powering the StakeForge Web3 ecosystem.

**Forge Protocol** represents the on-chain infrastructure of the StakeForge platform. It is a suite of Ethereum-based smart contracts designed for secure DeFi staking, continuous yield generation, and provably fair cybernetic gaming.

![Hardhat](https://img.shields.io/badge/Framework-Hardhat-yellow)
![Solidity](https://img.shields.io/badge/Solidity-0.8.20-363636)
![Ethers](https://img.shields.io/badge/Ethers.js-v6-blue)
![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-Contracts-blue)

---

## 🏛️ Smart Contract Architecture

The protocol is split into three tightly integrated contracts:

### 1. `FORGEToken.sol` (FRX)
The native ERC-20 utility token of the ecosystem.
- Mints an initial supply of `100,000,000 FRX` to the deployer.
- Uses OpenZeppelin's `Ownable` module to restrict minting privileges.
- Ownership is transferred to the `StakingPool` post-deployment to allow for dynamic block-reward generation.

### 2. `StakingPool.sol`
A secure DeFi vault for locking native Ethereum to generate passive yield.
- **Deposit & Lock:** Users deposit `msg.value` (ETH) to immediately begin generating yield.
- **Yield Calculation:** Dynamically calculates yield strictly based on `block.timestamp` and the user's active stake duration.
- **Claiming:** Triggers the `FORGEToken` contract to mint newly created FRX directly to the user's wallet.

### 3. `DiceGame.sol`
A provably fair, on-chain casino module.
- **Wagering:** Users must `approve()` the contract to spend their FRX.
- **Pseudo-Randomness:** Uses a hashing combination of `block.timestamp`, `msg.sender`, and `block.prevrandao` to securely generate the outcome.
- **Payout:** Pays out a `5x` multiplier for correct target guesses directly from the House Bank.

---

## 🚀 Local Development & Testing

### 1. Installation
Install the necessary dependencies (Hardhat & OpenZeppelin):
```bash
npm install
```

### 2. Start the Local Blockchain
Boot up the Hardhat node. This will give you 20 test accounts, each loaded with 10,000 test ETH.
```bash
npx hardhat node
```

### 3. Deploy the Protocol
Open a separate terminal and run the deployment script. 
*Note: This script automatically deploys the contracts, transfers ownerships, funds the casino, and exports the ABIs to the frontend.*
```bash
npx hardhat run scripts/deploy.js --network localhost
```

---

## 🔒 Security & Standards
These contracts heavily rely on the industry-standard [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) library for security and compliance with ERC-20 standards.

*Disclaimer: This protocol uses `block.prevrandao` for local pseudo-randomness for MVP purposes. For mainnet deployments, integration with Chainlink VRF is required.*
