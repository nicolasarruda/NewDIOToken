# NewDIO Token

Bem-vindo ao repositório do **NewDIO Token**, um token ERC-20 criado na blockchain Ethereum. Este projeto serve como um exemplo de implementação de um token que segue o padrão ERC-20.

## Descrição

O NewDIO Token é um token digital que permite transferências entre endereços Ethereum, aprovações e verificações de saldo. O código foi atualizado para melhorar a legibilidade, precisão e eficiência. O código inicial foi retirado de [Veja o código do contrato Token](https://github.com/relsi/web3-blockchain-classes/blob/main/token.sol).

## Refatoração do contrato de token para melhorar legibilidade e precisão

- Atualizado o nome do token de "DIO Coin" para "NewDIO Token"
- Alterado o símbolo do token de "DIO" para "NewDIO"
- Aumentada a precisão do token, definindo `decimals` para 18
- Adicionadas mensagens de erro constantes para verificações de saldo e permissão (`insufficient_balance` e `allowance_exceeded`)
- Atualizado o total supply para 10 Ether (1.000.000.000.000.000.000 unidades)
- Melhorada a legibilidade do código com comentários e renomeação de variáveis para maior clareza

## Como Funciona?

O contrato do token implementa as seguintes funcionalidades:

- **Transferência de Tokens**: Usuários podem transferir tokens entre si.
- **Aprovação de Tokens**: Usuários podem aprovar que outros gastem seus tokens.
- **Verificação de Saldo**: Usuários podem verificar seu saldo de tokens.

## Código Inicial vs Código Atualizado

### Código Inicial

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

//ERC Token Standard #20 Interface
interface ERC20Interface{

    // getters
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);

    // functions
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    // events
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

//Actual token contract
contract DIOToken is ERC20Interface{
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        symbol = "DIO" ;
        name = "DIO Coin";
        decimals = 2;
        _totalSupply = 1000000;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        require(tokens <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender] - tokens;
        balances[to] = balances[to] + tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint256 tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        require(tokens <= balances[msg.sender]);
        require(tokens <= allowed[from][msg.sender]);

        balances[from] = balances[from] - tokens;
        allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
        balances[to] = balances[to] + tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
}
```

### Código Atual

```solidity
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
```
