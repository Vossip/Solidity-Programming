//SPDX-License-Identifier: MIT

// ----------------------------------------------------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// -----------------------------------------

 
pragma solidity ^0.8.7;

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _tokenOwner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);

    //Following functions are not mamandtory for a erc20 token
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    //Following function are not mamandtory for a erc20 token
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract TestCoin is ERC20Interface{
    string public name = "TestCoin";
    string public symbol = "TC";
    uint8 public decimals = 0; //18 is most used value
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    mapping(address => mapping(address => uint)) allowed;

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

    function allowance(address tokenOwner, address spender) view public override returns (uint256 remaining){
        return allowed[tokenOwner][spender];
    }

    //called by token owner to set the allowance - the amount which can be spent by the spender
    function approve(address spender, uint256 tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    //allows spender to withdraw or transfer from owners account multiple times multiple times.
    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success){
        require(allowed[from][msg.sender] >= tokens);
        require(balances[from] >= tokens);
        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);
        return true;
    }

}