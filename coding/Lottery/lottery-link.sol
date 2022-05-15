//SPDX-License-Identifier: GPL-3.0
 
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

abstract contract VRFConsumer is VRFConsumerBaseV2{
    VRFCoordinatorV2Interface COORDINATOR;

    // Subscription ID.
    uint64 s_subscriptionId;

    // Rinkeby coordinator. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

    // Rinkeby LINK token contract. For other networks, see
    // https://docs.chain.link/docs/vrf-contracts/#configurations
    address link_token_contract = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 200000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords =  2;


    uint256[] internal s_randomWords;
    uint256 internal s_requestId;
    address s_owner;

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() public onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
        keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
        );
    }
    
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;
        //If randomness is received proceed to finishing the lottery
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner, "You're not the owner!");
        _;
    }
}

contract Lottery is VRFConsumer {
    uint public round;
    address private lastRoundsWinner;
    address payable[] public players;
    uint256[] private previousWords;
    uint public ownersCut;
    uint public minPlayerAmount;

    constructor(uint64 subscriptionId, uint _ownersCut, uint _minPlayerAmount) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;

        round = 0;
        ownersCut = _ownersCut;
        minPlayerAmount = _minPlayerAmount;
    }


    modifier checkPurchase() {
        require(msg.sender != s_owner);
        require(msg.value == 0.01 ether, "Not the correct amount!");
        _;
    }

    modifier toContinue() {
        require(s_randomWords.length > 0, "There is no randomness yet generated");
        _;
    }

    receive() external payable checkPurchase{
        players.push(payable(msg.sender));
    }

    function buyTicket() public payable checkPurchase{
        players.push(payable(msg.sender));
    }

    function getBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }

    //LINK randomness
    function random() public view onlyOwner returns(uint){
        return uint(keccak256(abi.encodePacked(s_randomWords)));
    }

    //backup
    function random2() public view onlyOwner returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public onlyOwner{
        require(players.length >= minPlayerAmount, "Lottery needs at least 3 players!!!");
        requestRandomWords();
    }

    function finalizeWinner() public onlyOwner toContinue{
        uint r = random();
        address payable winner;
        

        uint index = r % players.length;
        winner = players[index];
        
        uint ownerFee = (getBalance() * 10 ) / 100;
        uint winnerPrize = (getBalance() * 90 ) / 100;
        winner.transfer(winnerPrize);
        payable(s_owner).transfer(ownerFee);
        players = new address payable[](0); //will reset the lottery

        round += 1;
        lastRoundsWinner = winner;
    }

    function getAmountOfPlayers() public view returns(uint){
        return players.length;
    }

    function getLastRoundsWinner() public view returns(address){
        require(round > 0, "There hasn't been any previous rounds jet");
        return lastRoundsWinner;
    }

    function getLinkRequestId() public view onlyOwner returns(uint256){
        return s_requestId;
    }

    function getRandomWords(uint index) public view onlyOwner returns(uint256){
        return s_randomWords[index];
    }

    function setMinPlayerAmount(uint _minPlayerAmount) public onlyOwner{
        minPlayerAmount = _minPlayerAmount;
    }

    function setOwnersCut(uint _ownersCut) public onlyOwner{
        ownersCut = _ownersCut;
    }

    function setCallbackGasLimit(uint32 _callbackGasLimit) public onlyOwner{
        callbackGasLimit = _callbackGasLimit;
    }

    function setRequestConfirmations(uint16 _requestConfirmations) public onlyOwner{
        requestConfirmations = _requestConfirmations;
    }

    function setNumWords(uint32 _numWords) public onlyOwner{
        numWords = _numWords;
    }
}