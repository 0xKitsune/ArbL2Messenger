// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "../../lib/ds-test/src/test.sol";
import "../ArbL2Messenger.sol";

contract ArbL2MessengerTest is DSTest {

    arbL2Messenger ArbL2Messenger;


    function setUp() public {
        //create a new ArbL2Messenger
        arbL2Messenger = new ArbL2Messenger();
    }


    function testSendMessageToL2() public {
        

        //define a target L2 address
        address targetL2Address=0xE592427A0AEce92De3Edee1F18E0157C05861564;
        //create data and encode into bytes
        //set max submission cost

        //set max gas

        //set gas price bid

        retryableTicket =arbL2Messenger.sendMessageToL2(targetL2Address, data, l2CallValue, maxSubmissionCost, maxGas, gasPriceBid);

    }
}
