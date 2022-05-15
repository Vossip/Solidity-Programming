//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.7;

contract Token{
    event Transfer(address _to, uint _value);

    function transfer(address payable _to, uint _value) public{
        // The function's body;
        //...

        emit Transfer(_to, _value);
    }
}