// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";

import {console} from "forge-std/Test.sol";

contract RollDice is VRFConsumerBaseV2 {
    uint8 public s_pridictionNumber;
    uint256 public s_AmountReceivedfromplayer;
   // uint256[] RandomWords = new uint256[](0);

    //VRF chainlink
    VRFCoordinatorV2Interface public immutable COORDINATOR;
    bytes32 public immutable i_keyHash;
    uint64 public immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint32 public immutable i_callbackGasLimit;

    constructor(
        address vrfCordinatoraddress,
        bytes32 keyHash,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCordinatoraddress) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCordinatoraddress);
        i_keyHash = keyHash;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function getpredictionNumberAndEth(uint8 _predictionNumber) public payable {
        require(
            _predictionNumber > 0 && _predictionNumber < 7,
            "incorrect prediction number"
        );
        require(msg.value > 0.1 ether, "You need to spend minimum 0.1 ETH");
        s_pridictionNumber = _predictionNumber;
        s_AmountReceivedfromplayer = msg.value;
    }

    function rollTheDice() public {
        //Call the VRF function
        //console.log("requestId from rollTheDiceeeee: ");
        uint256 requestId = COORDINATOR.requestRandomWords(
            i_keyHash,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
       console.log("requestId from rollTheDice: ",requestId);
       console.log("requestId from rollTheDiceid: ",i_subscriptionId);
       // fulfillRandomWords(requestId,RandomWords);
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override view {
        uint256 randomNumber = randomWords[0];
        console.log("randomNumber from fulfillRandomWords: ", randomNumber);
        console.log("requestId from fulfillRandomWords: ", requestId);
    }

    //Getter functions
    function getAddressOfContract() external view returns (address) {
        return address(this);
    }
}
