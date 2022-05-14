// SPDX-License-Identifier: MIT

//pragma solidity >=0.8.0 <=0.8.7;

contract fixedSizeArrays{
    // declaring a fixed-size array of type uint with 3 elements
    uint[3] public numbers = [2,3,4];

    // declaring fixed-size arrays of type bytes
    bytes1 public b1;
    bytes2 public b2;
    bytes3 public b3;
    //.. up to bytes32

    function setElement(uint index, uint value) public{
        numbers[index] = value;
    }

    function getLength() public view returns(uint) {
        return numbers.length;
    }

    function setBytesArray() public {
        b1 = 'a';
        b2 = 'ab';
        b3 = 'abd';
        // b3[0] = 'a'; not allowed ERROR => can not change individual bytes

        // byte is an alias for bytes1 on older code
    }
}