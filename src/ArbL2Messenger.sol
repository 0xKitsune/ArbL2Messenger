// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "../lib/arb-shared-dependencies/Inbox.sol";

/// @author 0xKitsune
/// @title A simple contract for L1 contracts to inherit to easily send data from L1 to L2
/// @notice This contract contains comments straight out of the Arbitrum docs to make it easy to quickly understand each of the functions and arguments required.
contract ArbL2Messenger {

    IInbox public inbox;

    event RetryableTicketCreated(uint256 indexed ticketId);

    constructor(
    ) {
        /// @notice Arbitrum Inbox address for layer 1
        inbox = IInbox(0x578bade599406a8fe3d24fd7f7211c0911f5b29e);
    }


    /// @notice Send a message to a specified contract on L2. The target contract on L2 will execute the _txData passed into the function.
    /// @param _targetL2Address The targeted smart contract on L2 that will execute the passed in _txData
    /// @param _data ABI encoded data of L2 message that will be passed to the target L2 address.
    /// @param _l2CallValue Call value for retryable L2 message. Callvalue is deducted from sender’s L2 account and a Retryable Ticket is successfully created.
    /// @param _maxSubmissionCost Max gas deducted from user's L2 balance to cover base submission fee
    /// @param _maxGas Max gas deducted from user's L2 balance to cover L2 execution
    /// @param _gasPriceBid Price bid for L2 execution
    /// @return Unique id for retryable transaction (keccak256(requestID, uint(0))
    function sendMessageToL2(
        address calldata _targetL2Address,
        bytes calldata _data,
        uint256 _l2CallValue,
        uint256 _maxSubmissionCost,
        uint256 _maxGas,
        uint256 _gasPriceBid
    ) public payable returns (uint256) {        
        uint256 ticketID = inbox.createRetryableTicket{value: msg.value}(
            _targetL2Address,
            _l2CallValue,
            _maxSubmissionCost,
            /// @notice excess fee return address, maxgas x gasprice - execution cost gets credited here on L2 balance
            msg.sender,
            /// @notice call value refund address, l2Callvalue gets credited here on L2 if retryable txn times out or gets cancelled
            msg.sender,
            _maxGas,
            _gasPriceBid,
            _data
        );

        emit RetryableTicketCreated(ticketID);
        return ticketID;
    }


    /// @notice Send a message to a specified contract on L2 with the sender attached. The target contract on L2 will execute the _txData passed into the function.
    /// @param _ Parameters are exactly the same as sendMessageToL2 but the msg.sender is encoded with the data. This will allow for the L2 contract to verify who the msg.sender is, enabling further functionality between L1 and L2.
    function sendMessageToL2WithSenderAttached(
        address calldata _targetL2Address,
        bytes calldata _data,
        uint256 _l2CallValue,
        uint256 maxSubmissionCost,
        uint256 maxGas,
        uint256 gasPriceBid
    ) public payable returns (uint256) {  

        _dataWithSender = abi.encode(_data, msg.sender); 

        uint256 ticketID = inbox.createRetryableTicket{value: msg.value}(
            _targetL2Address,
            _l2CallValue,
            maxSubmissionCost,
            //excess fee return address
            msg.sender,
            //call value refund address
            msg.sender,
            maxGas,
            gasPriceBid,
            _dataWithSender
        );

        emit RetryableTicketCreated(ticketID);
        return ticketID;
    }


    /// @notice Send a message to a specified contract on L2, explicitly specifying the _excessFeeRefundAddress and _callValueRefundAddress. The target contract on L2 will execute the _txData passed into the function.
    /// @param _ Parameters are exactly the same as sendMessageToL2 the _excessFeeRefundAddress and _callValueRefundAddress are specified.
    /// @param _excessFeeRefundAddress  Excess fee return address, maxgas x gasprice - execution cost gets credited here on L2 balance
    /// @param _callValueRefundAddress Call value refund address, l2Callvalue gets credited here on L2 if retryable txn times out or gets cancelled
      function sendMessageToL2WithManualInputs(
        address calldata _targetL2Address,
        bytes calldata _data,
        uint256 _l2CallValue,
        uint256 _maxSubmissionCost,
        address _excessFeeRefundAddress,
        address _callValueRefundAddress,
        uint256 _maxGas,
        uint256 _gasPriceBid
    ) public payable returns (uint256) {
        bytes memory data = abi.encode(_txData);
        
        uint256 ticketID = inbox.createRetryableTicket{value: msg.value}(
            _targetL2Address,
            _l2CallValue,
            _maxSubmissionCost,
            _excessFeeRefundAddress,
            _callValueRefundAddress,
            _maxGas,
            _gasPriceBid,
            _data
        );

        emit RetryableTicketCreated(ticketID);
        return ticketID;
    }

}
