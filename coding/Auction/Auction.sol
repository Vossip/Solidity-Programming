//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.7;

contract AuctionCreator{
    Auction[] public auctions;

    function createAuction() public {
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;

    enum State {Started, Running, Ended, Canceled}
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;
    uint bidIncrement;


    constructor(address eoa){
        owner = payable(eoa);
        auctionState = State.Running;
        startBlock = block.number; 
        endBlock = startBlock + 3; //604800(seconds in a week)/50 = 40320 blocks generated in a week
        ipfsHash = "";
        bidIncrement = 1000000000000000000;
    }

    modifier notOwner(){
        require(msg.sender != owner, "Owner can't do this!");
        _;
    }

    modifier afterStart(){
        require(block.number >= startBlock, "Auction hasn't started yet!");
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock, "Auction has ended!");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
        if(a <= b) return a;
        else return b;
    }

    function cancelAuction() public onlyOwner{
        auctionState = State.Canceled;
    }

    function placeBid() public payable notOwner afterStart beforeEnd{
        require(auctionState == State.Running, "Auction isn't running!");
        require(msg.value >= 100, "Bid needs to be at least 100 wei"); //wei

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid, "Too small of a bid!");

        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }else{
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    function finalizeAuction() public{
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0, "Only owner or bidder can finalize auction");

        address payable recipient;
        uint value;

        if(auctionState == State.Canceled) {
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }else{ //auction ended
            if(msg.sender == owner){
                recipient = owner;
                value = highestBindingBid;
            }else{ //this is bidder
                if(msg.sender == highestBidder){
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                }else{ //this is not owner or higest bidder
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }
        bids[recipient] = 0;
        recipient.transfer(value);

    }


}