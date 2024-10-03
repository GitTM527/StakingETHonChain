// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract StakingETH is ReentrancyGuard {
    uint256 public constant maxDuration = 60; // in seconds
    uint256 public constant DaysInYears = 365; // days
    uint256 public constant Rate = 10; // in percentage

    struct Staker {
        string name;
        uint256 accountBalance;
        uint256 stakeTime;
        bool isCreated;
    }

    // Mapping staker's address to their staker info
    mapping(address => Staker) public stakers;

    // Function to stake Ether
    function stakeEther(string memory _name) external payable {
        require(msg.sender != address(0), "Address zero detected");
        require(msg.value > 0, "Cannot stake 0 ether");

        Staker storage staker = stakers[msg.sender];

        // If it's the first time staking, set the name
        if (!staker.isCreated) {
            staker.name = _name;
            staker.isCreated = true;
        }

        staker.accountBalance += msg.value;
        staker.stakeTime = block.timestamp;
    }

    // Function to calculate staking rewards
    function calculateRewards(address _staker) public view returns (uint256) {
        Staker storage staker = stakers[_staker];
        require(staker.isCreated, "Staker does not exist");

        uint256 stakedTime = block.timestamp - staker.stakeTime;
        uint256 stakedAmount = staker.accountBalance;

        // Assuming Rate is the annual percentage rate (APR)
        uint256 rewards = (stakedTime * stakedAmount * Rate) / (DaysInYears * 1 days * 100);
        return rewards;
    }

    // Function to withdraw staked Ether and rewards
    function withdrawRewards() external nonReentrant {
        Staker storage staker = stakers[msg.sender];
        require(staker.accountBalance > 0, "No Ether staked");

        // Calculate the rewards
        uint256 rewards = calculateRewards(msg.sender);

        // Store the amount to transfer
        uint256 amountToTransfer = staker.accountBalance + rewards;

        // Reset staker's balance and staking time
        staker.accountBalance = 0;
        staker.stakeTime = 0;

        // Transfer the staked Ether and rewards to the staker
        payable(msg.sender).transfer(amountToTransfer);
    }

    // Function to check the contract's balance (for demonstration/testing purposes)
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}