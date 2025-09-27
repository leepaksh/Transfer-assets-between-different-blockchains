
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrossChainAssetTransfer {
    address public owner;

    event AssetLocked(address indexed sender, uint256 amount, string targetChain, string targetAddress);
    event AssetUnlocked(address indexed receiver, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Lock assets on the source chain
    function lockAssets(uint256 amount, string memory targetChain, string memory targetAddress) public payable {
        require(msg.value == amount, "Incorrect amount sent");
        emit AssetLocked(msg.sender, amount, targetChain, targetAddress);
    }

    // Unlock assets on the destination chain (called by bridge operator)
    function unlockAssets(address payable receiver, uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        receiver.transfer(amount);
        emit AssetUnlocked(receiver, amount);
    }

    // View contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
