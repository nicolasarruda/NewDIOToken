// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

//ERC-20 Token Standard Interface
interface ERC20Interface{

    // getters: returns values related to token state
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    // functions: logic for transferring and approving tokens
    function transfer(address to, uint256 tokens) external returns (bool);
    function approve(address spender, uint256 tokens) external returns (bool);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool);
 
    // events: emit notifications for token transfers and approvals
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);
}
 
// Token contract
contract NewDIOToken is ERC20Interface{

    string public constant insufficient_balance = "Insufficient balance";
    string public constant allowance_exceeded = "Allowance exceeded";

    string public constant symbol = "NewDIO";
    string public constant name = "NewDIO Token";
    uint8 public constant decimals = 18;
    uint256 public _totalSupply = 10 ether;
 
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
 
    constructor() {
        balances[msg.sender] = _totalSupply;
    }
 
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }
 
    function balanceOf(address owner) public override view returns (uint256) {
        return balances[owner];
    }
 
    function transfer(address to, uint256 tokens) public override returns (bool) {
        require(tokens <= balances[msg.sender], insufficient_balance);

        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint256 tokens) public override returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint256) {
        return allowed[owner][spender];
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns (bool) {
        require(tokens <= balances[from], insufficient_balance);
        require(tokens <= allowed[from][msg.sender], allowance_exceeded);

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
} 