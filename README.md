<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/github_username/repo_name">
    <img src="assets/ArbitrumArt.png" alt="Logo" width="585" height="329">
  </a>
  <h1 align="center">ArbL2Messenger</h1>
  <p align="center">
 A simple contract for L1 contracts to inherit to easily send generic data from Ethereum to Arbitrum.
<br />
<br />


## Overview

The ArbL2Messenger is a simple interface for Ethereum Layer 1 contracts to inherit, allowing them to easily send generic data to Arbitrum. The goal of this project is to help developers easily integrate functionality to send data to Arbitrum, all while reducing development time and complexity. This contract is still being developed and further functionality will be implemented to support common usecases when interacting with Arbitrum from Layer 1.

<br />

## Functions

### sendMessageToL2
Send a message to a specified contract on L2. The target contract on L2 will execute the _txData passed into the function.

```js
function sendMessageToL2(
        address calldata _targetL2Address,
        bytes calldata _data,
        uint256 _l2CallValue,
        uint256 _maxSubmissionCost,
        uint256 _maxGas,
        uint256 _gasPriceBid
    ) public payable returns (uint256)
```

`_targetL2Address`: The targeted smart contract on L2 that will execute the passed in _txData
`_data`: ABI encoded data of L2 message that will be passed to the target L2 address.
`_l2CallValue`: Call value for retryable L2 message. Callvalue is deducted from sender’s L2 account and a Retryable Ticket is successfully created.
`_maxSubmissionCost`: Max gas deducted from user's L2 balance to cover base submission fee
`_maxGas`: Max gas deducted from user's L2 balance to cover L2 execution
`_gasPriceBid`: Price bid for L2 execution

returns a unique id for retryable transaction `(keccak256(requestID, uint(0))`

<br />

### sendMessageToL2WithSenderAttached
Send a message to a specified contract on L2 with the sender attached. The target contract on L2 will execute the `_txData` passed into the function. Parameters are exactly the same as sendMessageToL2 but the msg.sender is encoded with the data. This will allow for the L2 contract to verify who the msg.sender is, enabling further functionality between L1 and L2.

```js
function sendMessageToL2WithSenderAttached(
        address calldata _targetL2Address,
        bytes calldata _data,
        uint256 _l2CallValue,
        uint256 _maxSubmissionCost,
        uint256 _maxGas,
        uint256 _gasPriceBid
    ) public payable returns (uint256)
```

<br />

### sendTxToArbitrumWithManualInputs
Send a message to a specified contract on L2, explicitly specifying the `_excessFeeRefundAddress` and `_callValueRefundAddress`. The target contract on L2 will execute the `_txData` passed into the function. Parameters are exactly the same as sendMessageToL2 but the `_excessFeeRefundAddress` and `_callValueRefundAddress` are manually specified. 
```js
function sendTxToArbitrumWithManualInputs(
        address calldata _targetL2Address,
        bytes calldata _txData,
        uint256 _l2CallValue,
        uint256 _maxSubmissionCost,
        address _excessFeeRefundAddress,
        address _callValueRefundAddress,
        uint256 _maxGas,
        uint256 _gasPriceBid
    ) public payable returns (uint256) 
```

`_excessFeeRefundAddress `: Excess fee return address, maxgas x gasprice - execution cost gets credited here on L2 balance
`_callValueRefundAddress `: Call value refund address, l2Callvalue gets credited here on L2 if retryable txn times out or gets cancelled
