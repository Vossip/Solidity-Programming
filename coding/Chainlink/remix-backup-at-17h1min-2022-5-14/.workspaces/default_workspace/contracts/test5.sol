// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract DynamicArrays{
    uint[] public numbers;

    function getLength() public view returns(uint) {
        return numbers.length;
    }

    function addEelement(uint item) public {
        numbers.push(item);
    }

    function getElement(uint i) public view returns(uint) {
        if(i < numbers.length) {
            return numbers[i];
        } else {
            return 0;
        }
    }

    function popElement() public{
        numbers.pop();
    }

    function f() public{
        uint[] memory y = new uint[](3);
        y[0] = 1;
        y[1] = 44;
        y[2] = 32;
        numbers = y;
    }
}