// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FORGEToken is ERC20, Ownable {
    constructor() ERC20("Forge Token", "FRX") Ownable(msg.sender) {
        _mint(msg.sender, 100000000 * 10 ** decimals()); // Mint 100M tokens to deployer
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
