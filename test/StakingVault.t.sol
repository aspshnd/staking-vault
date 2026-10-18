// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {StakingVault} from "../src/StakingVault.sol";
import {console} from "forge-std/Console.sol";

contract StakingVaultTest is Test {
    StakingVault vault;
    address staker = makeAddr("staker");

    function setUp() public {
        vault = new StakingVault();
        vm.deal(staker, 10 ether);
    }

    function test_AvailableRewardPool() public {
        vm.prank(staker);
        vault.stake{value: 5 ether}();

        vault.fundRewards{value: 1 ether}();

        console.log("Available reward pool:", vault.availableRewardPool());
        assertEq(vault.availableRewardPool(), 1 ether);
    }

    function test_RewardAccruesOverTime() public {
        vm.prank(staker);
        vault.stake{value: 10 ether}();

        vault.fundRewards{value: 1 ether}();

        // Majukan waktu 10 hari
        vm.warp(block.timestamp + 10 days);

        uint256 reward = vault.calculateReward(staker);
        console.log("Reward after 10 days:", reward);

        // 1% per hari dari 10 ETH selama 10 hari = 1 ETH
        assertEq(reward, 1 ether);
    }

    function test_WithdrawFailsIfRewardPoolInsufficient() public {
        vm.prank(staker);
        vault.stake{value: 10 ether}();

        // TIDAK fundRewards sama sekali

        vm.warp(block.timestamp + 10 days);

        vm.prank(staker);
        vm.expectRevert("Insufficient contract balance");
        vault.withdraw();
    }
}