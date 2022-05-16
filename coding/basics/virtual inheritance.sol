//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.7;

abstract contract BaseContract{
    int public x;
    address public owner;

    constructor(){
        x = 5;
        owner = msg.sender;
    }

    function setX(int _x) public virtual;
}

contract A is BaseContract{
    //int public x; Can not override state variable
    int public y = 3;

    function setX(int _x) public override{
        x = _x;
    }
}