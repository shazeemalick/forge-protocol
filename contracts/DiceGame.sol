// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FORGEToken.sol";

contract DiceGame {
    FORGEToken public token;

    event DiceRolled(address indexed player, uint256 betAmount, uint8 targetNumber, uint8 rolledNumber, bool won, uint256 payout);

    constructor(address _token) {
        token = FORGEToken(_token);
    }

    function rollDice(uint256 betAmount, uint8 targetNumber) external {
        require(betAmount > 0, "Bet must be > 0");
        require(targetNumber >= 1 && targetNumber <= 6, "Invalid target number");
        require(token.balanceOf(msg.sender) >= betAmount, "Insufficient balance");

        // Transfer bet from user to contract (User must have approved first)
        token.transferFrom(msg.sender, address(this), betAmount);

        // Pseudo-randomness for local MVP
        uint8 rolledNumber = uint8((uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.prevrandao))) % 6) + 1);
        
        bool won = (rolledNumber == targetNumber);
        uint256 payout = 0;

        if (won) {
            payout = betAmount * 5; // 5x multiplier
            require(token.balanceOf(address(this)) >= payout, "House bank empty");
            token.transfer(msg.sender, payout);
        }

        emit DiceRolled(msg.sender, betAmount, targetNumber, rolledNumber, won, payout);
    }
}
