// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract Property {

    
    int public price;
    string public location;
    address immutable public owner; //Immutable nobody can change the value later after deployment
    int immutable area = 100;

    constructor(int _price, string memory _location) {
        price = _price;
        location = _location;
        owner = msg.sender;
    }

    function setPrice(int _price) public {
        price = _price;
    }

    function setLocation(string memory _location) public {
        location = _location;
    }
}