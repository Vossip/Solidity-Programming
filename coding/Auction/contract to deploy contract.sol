//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.7;

contract A{
    address public ownerA;
    constructor(address eoa){
        ownerA = eoa;
    }
}

contract Creator{
    address public ownerCreator;
    A[] public deplyedA;

    constructor(){
        ownerCreator = msg.sender;
    }

    function deployA() public{
        A new_A_aadress = new A(msg.sender);
        deplyedA.push(new_A_aadress);
    }
}