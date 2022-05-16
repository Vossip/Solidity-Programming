//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.7;

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);

    //Following functions are not mamandtory for a erc20 token
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    //Following function are not mamandtory for a erc20 token
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract VICoin is ERC20Interface{
    string public name = "VICoin";
    string public symbol = "VIC";
    uint8 public decimals = 0; //18 is most used value
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    mapping(address => mapping(address => uint)) allowed;

    //Can't add constructor input parameters as this contract is inherited
    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance){
        return balances[tokenOwner];
    }

    //called by the owner to transfer his tokens to another account
    //virtual - function can change its behavior in derived contracts by overriding
    function transfer(address to, uint tokens) public virtual override returns(bool success){
        require(balances[msg.sender] >= tokens);
        
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        
        return true;
    }

    function allowance(address tokenOwner, address spender) public view override returns(uint){
        return allowed[tokenOwner][spender];
    }

    //called by token owner to set the allowance - the amount which can be spent by the spender
    function approve(address spender, uint tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        
        allowed[msg.sender][spender] = tokens;
        
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    //called on behalf of the tokens owner after the owner has approve another address to spend the tokens he posesses
    //allows spender to withdraw or transfer from owners account multiple times.
    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success){
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        
        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;
        
        return true;
     }

}

contract VICoinICO is VICoin{
    address public admin;
    address payable public deposite;
    uint public tokenPrice = 0.001 ether; // 1ETH = 1000 VIC, 1VIC = 0.001ETH
    uint public hardCap = 300 ether;
    uint public raisedAmount; //wei
    uint public saleStart = block.timestamp; //add seconds to postpone the starting time (e.g. 1h = 3600)
    uint public saleEnd = block.timestamp + 604800; //ends in one week
    uint public tokenTradeStart = saleEnd + 604800; //transferable in a week after sale ends
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;
    
    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;

    constructor(address payable _deposite) {
        deposite = _deposite;
        admin = msg.sender;
        icoState = State.beforeStart; //ico will start after deployment
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin can do that!");
        _;
    }

    function halt() public onlyAdmin{
        icoState = State.halted;
    }

    function resume() public onlyAdmin{
        icoState = State.running;
    }

    function changeDepositeAddress(address payable newDeposite) public onlyAdmin{
        deposite = newDeposite;
    }

    function getCurrentState() public view returns(State){
        if(icoState == State.halted){
            return State.halted;
        } else if(block.timestamp < saleStart){
            return State.beforeStart;
        } else if(block.timestamp >= saleStart && block.timestamp <= saleEnd) {
            return State.running;
        } else{
            return State.afterEnd;
        }
    }

    event Invest(address investor, uint value, uint tokens);

    function invest() payable public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.running, "ICO isn't active!");
        require(msg.value >= minInvestment, "Investment lower then the allowed minimum!");
        require(msg.value <= maxInvestment, "Investment higher than the allowed maximum!");
        raisedAmount += msg.value;
        require(raisedAmount <= hardCap, "Raused amount is larger than the ICO hard cap");

        uint tokens = msg.value / tokenPrice;

        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        deposite.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokens);

        return true;
    }

    receive() payable external{
        invest();
    }
  
    function burn() public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.afterEnd, "ICO hasn't ended yet!");
        balances[founder] = 0;
        return true;
    }

    function transfer(address to, uint tokens) public override returns(bool success){
        require(block.timestamp > tokenTradeStart, "Can't trasfer tokens at the moment!");
        //VICoin.transfer(to, tokens); -> same as super
        super.transfer(to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        require(block.timestamp > tokenTradeStart); // the token will be transferable only after tokenTradeStart
        VICoin.transferFrom(from, to, tokens);  // same as super.transferFrom(to, tokens);
        return true;
    }
}