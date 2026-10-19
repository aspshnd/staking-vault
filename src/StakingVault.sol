 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract StakingVault {

     // State variables
    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public stakeTimestamp;

    address public owner;
    bool public paused;

    uint256 public totalStaked;
    uint256 public totalRewardsFunded;
    uint256 public totalRewardsPaid;

    // Events
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(
        address indexed user,
        uint256 principal,
        uint256 reward
    );
    event Paused(address indexed account);
    event Unpaused(address indexed account);
    event RewardsFunded(address indexed owner, uint256 amount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
        paused = false;
    }

    // Stake ETH
    function stake() external payable whenNotPaused {
        require(msg.value > 0, "Amount must be greater then zero");

        stakedAmount[msg.sender] += msg.value;
        stakeTimestamp[msg.sender] = block.timestamp;
        totalStaked += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    // Fund reward ETH
    function fundRewards() external payable onlyOwner {
        require(msg.value > 0, "Funding must be greater than zero");

        totalRewardsFunded += msg.value;

        emit RewardsFunded(msg.sender, msg.value);
    }

    function availableRewardPool() public view returns (uint256) {
        uint256 contractBalance = address(this).balance;

        if (contractBalance <= totalStaked) {
            return 0;
        }

        return contractBalance - totalStaked;
    }

    // Calculate reward: 1% per day
    function calculateReward(
        address user
    ) public view returns (uint256) {
        if (stakedAmount[user] == 0) {
            return 0;
        }

        uint256 elapsedTime = 
            block.timestamp - stakeTimestamp[user];
        
        return (
            stakedAmount[user] * elapsedTime 
        ) / 1 days / 100;
    }

    // Withdraw principal + reward
    function withdraw() external whenNotPaused {
        uint256 principal = stakedAmount[msg.sender];
        require(principal > 0, "Nothing too Withdraw");

        uint256 reward = calculateReward(msg.sender);
        uint256 totalAmount = principal + reward;

        totalStaked -= principal;
        totalRewardsPaid += reward;

        // Checks: pastikan saldo kontrak mencukupi
        require(
            address(this).balance >= totalAmount,
            "Insufficient contract balance"
        );

        // CEI: checks -> Effects -> Interactions
        stakedAmount[msg.sender] = 0;
        stakeTimestamp[msg.sender] = 0;

        emit Withdrawn(msg.sender, principal, reward);

        (bool success, ) = payable(msg.sender).call{
            value: totalAmount
        }("");

        require(success, "Transfer failed");
    }

    // Pause Contract
    function pause() external onlyOwner {
        require(!paused, "Already paused");

        paused = true;
        emit Paused(msg.sender);
    }

    // Unpause Contract
    function unpause() external onlyOwner {
        require(paused, "Not paused");

        paused = false;

        emit Unpaused(msg.sender);
    }
}