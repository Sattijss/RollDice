// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {RollDice} from "../src/RollDice.sol";
import {HelperConfig} from "Script/HelperConfig.s.sol";
import {AddConsumer, CreateSubscription} from "./Interactions.s.sol";


contract DeployRollDice is Script {
    //RollDice rollDice;
   
    function run() external returns (RollDice) {
        HelperConfig helperConfig = new HelperConfig();
        AddConsumer addConsumer = new AddConsumer();
        (
            address vrfCordinatoraddress,
            bytes32 keyHash,
            uint64 subscriptionId,
            uint32 callbackGasLimit
            ) = helperConfig.activeNetworkConfig();

        //If subscription is 0, yhen create subscription
        if (subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();
            subscriptionId = createSubscription.createSubscription(
                vrfCordinatoraddress
            );
        }
        vm.startBroadcast();
        RollDice rollDice = new RollDice(
            vrfCordinatoraddress,
            keyHash,
            subscriptionId,
            callbackGasLimit
        ); //Constructor values should be passed as arguments
        vm.stopBroadcast();
                // We already have a broadcast in here
        addConsumer.addConsumer(
            address(rollDice),
            vrfCordinatoraddress,
            subscriptionId
        );
        return rollDice;
    }
}
