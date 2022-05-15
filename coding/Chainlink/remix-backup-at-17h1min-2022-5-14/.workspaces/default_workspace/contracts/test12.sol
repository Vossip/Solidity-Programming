// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract Deposite{
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable{
    }

    fallback() external payable{
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendEther() public payable{
        uint x;
        x++;
    }

    function transferEther(address payable recipient, uint amount) public returns(bool){
        require(owner == msg.sender, "transfer failed");
        if(amount <= getBalance()){
            recipient.transfer(amount);
            return true;
        }else{
            return false;
        }
    }
}