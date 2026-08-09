// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FORGEToken.sol";

contract StakingPool {
    FORGEToken public rewardToken;
    uint256 public rewardRate = 125; // Base rate
    
    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }
    
    mapping(address => Stake) public stakes;
    uint256 public totalStaked;

    constructor(address _rewardToken) {
        rewardToken = FORGEToken(_rewardToken);
    }

    function stake() external payable {
        require(msg.value > 0, "Cannot stake 0");
        
        if (stakes[msg.sender].amount > 0) {
            claimRewards();
        }
        
        stakes[msg.sender].amount += msg.value;
        stakes[msg.sender].timestamp = block.timestamp;
        totalStaked += msg.value;
    }

    function unstake() external {
        uint256 amount = stakes[msg.sender].amount;
        require(amount > 0, "No active stake");
        
        claimRewards();
        
        stakes[msg.sender].amount = 0;
        totalStaked -= amount;
        
        payable(msg.sender).transfer(amount);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        if (userStake.amount == 0) return 0;
        
        uint256 timeStaked = block.timestamp - userStake.timestamp;
        // Simple mock calculation for MVP 
        return (userStake.amount * rewardRate * timeStaked) / (1 days * 100);
    }

    function claimRewards() public {
        uint256 reward = calculateReward(msg.sender);
        if (reward > 0) {
            stakes[msg.sender].timestamp = block.timestamp;
            rewardToken.mint(msg.sender, reward);
        }
    }
}
