// SPDX-License-Identifier: MIT

//pragma solidity >=0.8.0 <=0.8.7;

contract A{
    string[] public cities = ['Berlin', 'Tallinn'];

    function f_memory() view public{
        string[] memory s1 = cities;
        //string s2; -> error
        s1[0] = 'Prague';
    }

    function f_storage() public{
        string[] storage s1 = cities;
        //string s2; -> error
        s1[0] = 'Prague';
    }
}