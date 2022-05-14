// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract BytesAndStrings{
    bytes public b1 = 'abc';
    string public s1 = 'abc';

    function addElement() public{
        b1.push('x');
    }

    function getElement(uint i) public view returns(bytes1){
        return b1[i];
    }

    function getLength() public view returns(uint){
        return b1.length;
    }
}