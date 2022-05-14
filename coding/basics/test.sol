// SPDX-License-Identifier: MIT

//pragma solidity >=0.8.0 <=0.8.7;

contract Property {
    uint private price;
    address public owner;

    constructor() {
        price = 0;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /*
    Kaka puuks
    */
    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function setPrice(uint _price) public {
        price = _price;
    }

    /// @notice Returns the price of the Property
    function getPrice() view public returns (uint) {
        return price;
    }

    event OwnerChanged(address owner);
}