// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {

       function createSubscriptionUsingConfig() public returns (uint64) {
         HelperConfig helperConfig = new HelperConfig();
        (address vrfCordinatoraddress, , , )  = helperConfig.activeNetworkConfig();
        return createSubscription(vrfCordinatoraddress);
       }

    function createSubscription(
        address vrfCoordinator
    ) public returns (uint64) {
        console.log("Creating subscription on chainId: ", block.chainid);
        vm.startBroadcast();
        uint64 subscriptionId = VRFCoordinatorV2Mock(vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription Id is: ", subscriptionId);
        console.log("Please update the subscriptionId in HelperConfig.s.sol");
        return (subscriptionId);
    }

        function run() external returns (uint64) {
        return createSubscriptionUsingConfig();
    }
}













//** Add Consumer COntract**/
contract AddConsumer is Script {
        function addConsumer(
        address mostRecentlyDeployed,
        address vrfCoordinator,
        uint64 subscriptionId
    ) public {
        console.log("Adding consumer contract: ", mostRecentlyDeployed);
        console.log("Using vrfCoordinator: ", vrfCoordinator);
        console.log("On ChainID: ", block.chainid);
        vm.startBroadcast();
        VRFCoordinatorV2Mock(vrfCoordinator).addConsumer(
            subscriptionId,
            mostRecentlyDeployed
        );
       // console.log("randomwords ", VRFCoordinatorV2Mock(vrfCoordinator).fulfillRandomWords(1,mostRecentlyDeployed));
        //uint256 randomwords = VRFCoordinatorV2Mock(vrfCoordinator).fulfillRandomWords(1,mostRecentlyDeployed);
        vm.stopBroadcast();
    }
    function addConsumerUsingConfig(address mostRecentlyDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        (address vrfCordinatoraddress, , uint64 subscriptionId, ) = helperConfig
            .activeNetworkConfig();
            addConsumer(mostRecentlyDeployed, vrfCordinatoraddress, subscriptionId);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "RollDice",
            block.chainid
        );
        addConsumerUsingConfig(mostRecentlyDeployed);
    }
}
