// SPDX-License-Identifier: MIT

//pragma solidity >=0.8.0 <=0.8.7;

    // either receive() or fallback() is mandatory for the contract to receive ETH by 
    // sending ETH to the contract's address
    
    // declaring the receive() function that is executed when sending ETH to the contract address
    // it was introduced in Solidity 0.6 and a contract can have only one receive function, 
    // declared with this syntax (without the function keyword and without arguments). 
contract Deposite{

    address public owner;

    constructor(){
        owner = msg.sender;
    }
    receive() external payable{
    }

    // declaring a fallback payable function that is called when msg.data is not empty or
    // when no other function matches
    fallback() external payable{
    }

    // ether can be send and received by the contract in the trasaction that calls this function as well
    function sendEther() public payable{
        uint x;
        x++;
    }

    function getBalance() public view returns(uint){
        // this is the current contract, explicitly convertible to address, 
        // and balance is a member of any variable of type address. 
        return address(this).balance;
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

    /*
        Address is a variable type and has the following members:
        ○ balance
        ○ If the address is declared payable it has two additional members:
        ■ transfer(): should be used in most cases as it's the safest way to send
        ether
        ■ send(): is like a low-level transfer(). If execution fails the contract will not
        stop and send() returns false;
        ○ call(), delegatecall(), staticcall()
    */
}
