// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract Auction{
    // declaring a variable of type mapping
    // keys are of type address and values of type uint
    mapping(address => uint) public bids;

    // initializing the mapping variable
    // the key is the address of the account that calles the function
    // and the value the value of wei sent when calling the function
    function bid() payable public{
        bids[msg.sender] = msg.value;
    }
}