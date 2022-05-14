// SPDX-License-Identifier: MIT

//pragma solidity >=0.8.0 <=0.8.7;

contract DynamicArrays{
    // dynamic array of type uint
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
        // declaring a memory dynamic array
        // it's not possible to resize memory arrays (push() and pop() are n
        uint[] memory y = new uint[](3);
        y[0] = 1;
        y[1] = 44;
        y[2] = 32;
        numbers = y;
    }
}