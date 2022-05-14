//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Deposit{

    address public immutable admin;

    constructor(){
        admin = msg.sender;
    }

    receive() external payable{}

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function transferFunds(address payable receiver) public{
        require(msg.sender == admin, "you are not the owner!!!");
        receiver.transfer(getBalance());
    }
    
}

/*
Add a function so that the contract can receive ETH by sending it directly to the contract address.

Return the contract’s balance.

Add a function that transfers the entire balance of the contract to another address.

Add a new immutable state variable called admin and initialize it with the address of the account that deploys the contract;

Add a restriction so that only the admin can transfer the balance of the contract to another address;

Deploy and test the contract on Rinkeby Testnet.
*/