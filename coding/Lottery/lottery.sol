//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

/*
Lottery algorithm:
1. The lottery starts by accepting ETH transactions. Anyone having an Ethereum wallet can
send a fixed amount of 0.1 ETH to the contract’s address.
2. The players send ETH directly to the contract address and their Ethereum address is
registered. A user can send more transactions having more chances to win.
3. There is a manager, the account that deploys and controls the contract.
4. At some point, if there are at least 3 playesrs, he can pick a random winner from the
players list. Only the manager is allowed to see the contract balance and to randomly
select the winner.
5. The contract will transfer the entire balance to the winner’s address and the lottery is
reset and ready for the next round.
*/

contract Lottery{
    address payable[] public players;
    address public manager;

    constructor(){
        manager = msg.sender;
        players.push(payable(manager));
    }

    receive() external payable{
        //require(msg.value == 10000000000000000) //wei
        require(msg.sender != manager);
        require(msg.value == 0.1 ether, "Not the correct amount!");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager, "You're not the manager!");
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public{
        if(players.length >= 10) {
            pickWinner2();
        } else {
            require(msg.sender == manager, "You're not the manager!!!");
            require(players.length >= 3, "Lottery needs at least 3 players!!!");
            pickWinner2();
        }
    
    }

    function pickWinner2() private{
        uint r = random();
        address payable winner;

        uint index = r % players.length;
        winner = players[index];
        
        uint managerFee = (getBalance() * 10 ) / 100; // manager fee is 10%
        uint winnerPrize = (getBalance() * 90 ) / 100;     // winner prize is 90%
        
        // transferring 90% of contract's balance to the winner
        winner.transfer(winnerPrize);
        
        // transferring 10% of contract's balance to the manager
        payable(manager).transfer(managerFee);

        players = new address payable[](0); //will reset the lottery
    }

}
