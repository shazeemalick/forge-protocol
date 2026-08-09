const hre = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
  console.log("Starting deployment...");

  const FORGEToken = await hre.ethers.getContractFactory("FORGEToken");
  const forgeToken = await FORGEToken.deploy();
  await forgeToken.waitForDeployment();
  const tokenAddress = await forgeToken.getAddress();
  console.log("FORGEToken deployed to:", tokenAddress);

  const StakingPool = await hre.ethers.getContractFactory("StakingPool");
  const stakingPool = await StakingPool.deploy(tokenAddress);
  await stakingPool.waitForDeployment();
  const stakingAddress = await stakingPool.getAddress();
  console.log("StakingPool deployed to:", stakingAddress);

  const DiceGame = await hre.ethers.getContractFactory("DiceGame");
  const diceGame = await DiceGame.deploy(tokenAddress);
  await diceGame.waitForDeployment();
  const gameAddress = await diceGame.getAddress();
  console.log("DiceGame deployed to:", gameAddress);

  // Transfer ownership of token so StakingPool can mint rewards
  await forgeToken.transferOwnership(stakingAddress);
  console.log("Transferred FORGEToken ownership to StakingPool for minting");
  
  // Fund the Dice Game House Bank
  const mintAmount = hre.ethers.parseUnits("10000000", 18);
  await forgeToken.transfer(gameAddress, mintAmount);
  console.log("Funded DiceGame House Bank with 10M FRX");

  // Save addresses and ABIs for the React frontend
  const frontendDir = path.join(__dirname, '..', '..', 'frontend', 'src', 'contracts');
  if (!fs.existsSync(frontendDir)) {
    fs.mkdirSync(frontendDir, { recursive: true });
  }

  const addresses = {
    FORGEToken: tokenAddress,
    StakingPool: stakingAddress,
    DiceGame: gameAddress
  };
  fs.writeFileSync(path.join(frontendDir, 'addresses.json'), JSON.stringify(addresses, null, 2));

  // Copy ABIs
  const tokenArtifact = await hre.artifacts.readArtifact("FORGEToken");
  fs.writeFileSync(path.join(frontendDir, 'FORGEToken.json'), JSON.stringify(tokenArtifact, null, 2));

  const stakingArtifact = await hre.artifacts.readArtifact("StakingPool");
  fs.writeFileSync(path.join(frontendDir, 'StakingPool.json'), JSON.stringify(stakingArtifact, null, 2));

  const gameArtifact = await hre.artifacts.readArtifact("DiceGame");
  fs.writeFileSync(path.join(frontendDir, 'DiceGame.json'), JSON.stringify(gameArtifact, null, 2));

  console.log("Deployment complete! Artifacts successfully saved to frontend/src/contracts");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
