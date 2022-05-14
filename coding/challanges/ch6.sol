//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Stuff{
    string public str;

    function concatenate2(string memory x, string memory y) public{
        str = string(abi.encodePacked(x, y));
    }
}

/*
Declare a function that concatenates two strings.

Note: Since Solidity does not offer a native way to concatenate strings use abi.encodePacked() to do that. Read the official doc for examples.
https://docs.soliditylang.org/en/latest/abi-spec.html
*/