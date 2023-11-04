// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract KARMMToken is ERC20Burnable, Ownable {
    // Constants
    uint256 public constant INITIAL_SUPPLY = 3_000_000_000 * 10**18; // Total supply of 3 billion tokens
    uint8 public constant DECIMALS = 18;
    
    // Addresses to be blacklisted
    mapping(address => bool) public isBlacklisted;

    constructor() ERC20("KARMM", "KARMM") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    // Function to withdraw tokens from the smart contract address
    function withdrawTokens(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(address(this)) >= amount, "Insufficient balance in the contract");
        
        _transfer(address(this), to, amount);
    }

    // Function to blacklist an account/address
    function blacklistAddress(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(!isBlacklisted[account], "Address is already blacklisted");
        
        isBlacklisted[account] = true;
    }

    // Function to remove an address from the blacklist
    function removeAddressFromBlacklist(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(isBlacklisted[account], "Address is not blacklisted");
        
        isBlacklisted[account] = false;
    }

    // Check if an address is blacklisted
    function isAddressBlacklisted(address account) external view returns (bool) {
        return isBlacklisted[account];
    }

    // Override the transfer function to check for blacklisted addresses
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);

        require(!isBlacklisted[from], "Sender is blacklisted");
        require(!isBlacklisted[to], "Recipient is blacklisted");
    }
}
