// SPDX-License-Identifier: MIT

//pragma solidity >=0.8.0 <=0.8.7;

contract Property {
    int private price;
    string constant public location = "London";


    function f1() public pure returns(int) {
        //local variable
        int x = 5;
        x = x * 2;

        //string s1 = "abc"; Doesn't work 
        string memory s1 = "abc";

        return x;
    }
}