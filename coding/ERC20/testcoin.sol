//SPDX-License-Identifier: MIT

//https://eips.ethereum.org/EIPS/eip-20
 
pragma solidity ^0.8.7;

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _tokenOwner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);

    //Commented out functions are not mamandtory for a erc20 token
    //function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    //function approve(address _spender, uint256 _value) external returns (bool success);
    //function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    //event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract TestCoin is ERC20Interface{
    string public name = "TestCoin";
    string public symbol = "TC";
    uint8 public decimals = 0; //18 is most used value
    uint public override totalSupply ;

    address public founder;
    mapping(address => uint) public balances;

    constructor(uint _totalSupply){
        totalSupply = _totalSupply;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address _tokenOwner) public view override returns (uint256 balance){
        return balances[_tokenOwner];
    }

    function transfer(address to, uint256 tokens) public override returns(bool success){
        require(balances[msg.sender] >= tokens);

        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        
        return true;
    }

}