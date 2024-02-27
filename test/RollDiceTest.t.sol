// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployRollDice} from "../script/DeployRollDice.s.sol";
import {RollDice} from "../src/RollDice.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract RollDiceTest is Test {
    RollDice rollDice;
    HelperConfig helperConfig;
   // HelperConfig helperConfig = new HelperConfig();
    //uint64 somevalue = helperConfig.getOrCreateAnvilEthConfig().subscriptionId;
    
    uint256 public SEND_VALUE = 0.2 ether;
    //VRF variables
    address vrfCordinatoraddress;
    bytes32 keyHash;
    uint64 subscriptionId;
    uint32 callbackGasLimit;

    function setUp() public {
        DeployRollDice deployRollDice = new DeployRollDice();
        rollDice = deployRollDice.run();
        // helperConfig = new HelperConfig();
        // (
        // vrfCordinatoraddress,
        // keyHash,
        // subscriptionId,
        // callbackGasLimit
        // )  = helperConfig.activeNetworkConfig();
        // console.log("vrfCordinatoraddress:",vrfCordinatoraddress);
        // console.log("vrfCordinatoraddress:",helperConfig.getOrCreateAnvilEthConfig().vrfCordinatoraddress);
       
    }

    function testminumumETH() public {
        rollDice.getpredictionNumberAndEth{value: SEND_VALUE}(2);
    }

    function testrollTheDice() public{
        rollDice.rollTheDice();
       // rollDice.fulfillRandomWords("1",);
    }

    // function testfulfillRandomWords() public{
    //     rollDice.fulfillRandomWords('1',);
    // }
}
