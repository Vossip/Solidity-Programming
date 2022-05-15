// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract GlobalVars{
    //currnet date and time in the for of unix timestamp
    //running total of seconds since the unix epoch that happened on 01.01.1970
    //https://www.unixtimestamp.com/
    uint public this_moment = block.timestamp;

    uint public block_number = block.number; //Number of the current block
    uint public difficulty = block.difficulty; //POW difficulty
    uint public gaslimit = block.gaslimit; //current block gas limit. defines the maximum block size
}