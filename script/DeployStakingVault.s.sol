// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {StakingVault} from "../src/StakingVault.sol";

contract DeployStakingVault is Script {
    function run() external {
        vm.startBroadcast();
        StakingVault vault = new StakingVault();
        vm.stopBroadcast();
    }
}
