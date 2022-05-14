//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CryptosToken{
    string public constant name = "Cryptos";
    uint supply;
    address public owner;

    constructor(uint _supply){
        supply = _supply;
        owner = msg.sender;
    }

    function getSupply() public view returns(uint){
        return supply;
    }

    function setSupply(uint _supply) public{
        supply = _supply;
    }
}

/*
Change the state variable name to be declared as a public constant.

Declare a setter and a getter function for the supply state variable.

Add a public state variable of type address called owner.

Declare the constructor and initialize all the state variables in the constructor. The owner should be initialized with the address of the account that deploys the contract.
*/