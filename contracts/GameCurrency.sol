pragma solidity ^0.5.0;

import {FixedSupplyToken, ERC20Interface} from "./Erc20Base.sol";
import {GameResourceInterface} from "./GameResourceBase.sol";

contract GameCurrency is FixedSupplyToken {
    mapping(address => bool) public allowedToProduceTokens;

 // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(string memory _symbol, string memory _name) public {
        symbol = _symbol;
        name = _name;
        decimals = 0;
        _totalSupply = 0 * 10**uint(decimals); //will be generated when minted
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }
    

    modifier onlyAllowedContract() {
        assert(allowedToProduceTokens[msg.sender] == true);
        _;
    }

    function allowContractToModifyBalance(address contractAddress) public onlyOwner {
        allowedToProduceTokens[contractAddress] = true;
    }
    
    function createToken(address _to, uint _amount) public onlyAllowedContract {
        _totalSupply = _totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
    }

    function destroyTokenFor(address _from, uint _amount) public onlyAllowedContract {
        _totalSupply = _totalSupply.sub(_amount);
        balances[_from] = balances[_from].sub(_amount);
    }

    function createTokenFor(address _to, uint _amount) public onlyOwner {
        _totalSupply = _totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
    }
    
}