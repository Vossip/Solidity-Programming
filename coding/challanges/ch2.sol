//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract MyTokens{
    /*
    Modify the changeTokens() function in such a way that it changes the state variable called tokens.
    */
    string[] public tokens = ['BTC', 'ETH'];
    
    function changeTokens() public{
        string[] storage t = tokens;
        t[0] = 'VET';
    }
    
}