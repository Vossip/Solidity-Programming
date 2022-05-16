//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.7;

abstract contract BaseContract{ //can not be deployed on its own
    int public x;
    address public owner;

    constructor(){
        x = 5;
        owner = msg.sender;
    }

    function setX(int _x) public{
        x = _x;
    }
}

contract A is BaseContract{ //can be deployed and inherits BaseContract parameters
    int public y = 3;
}