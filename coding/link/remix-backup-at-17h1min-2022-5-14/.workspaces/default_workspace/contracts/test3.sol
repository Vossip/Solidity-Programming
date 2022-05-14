pragma solidity >=0.5.0 <0.9.0;
 
contract Property{
  string public location = "Paris";
  
  function f1 (uint x) public{ 
     string memory _location = "Berlin";
     _location = location;
     
     x = 10;
     uint y = 20;
     
  }
}