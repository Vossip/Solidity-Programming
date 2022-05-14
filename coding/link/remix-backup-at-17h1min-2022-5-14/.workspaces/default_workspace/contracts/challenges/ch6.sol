//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Stuff{
    string public str;

    function concatenate2(string memory x, string memory y) public{
        str = string(abi.encodePacked(x, y));
    }
}