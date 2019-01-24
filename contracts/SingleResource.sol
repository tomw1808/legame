pragma solidity ^0.5.0;

import {FixedSupplyToken, ERC20Interface} from "./Erc20Base.sol";
import {GameResourceInterface} from "./GameResourceBase.sol";

contract SingleResource is FixedSupplyToken, GameResourceInterface {
    uint public amountMintedAfterTime = 10;
    uint public timeToMint = 10 seconds;
    mapping(address => uint) addressAllowedToGetTokenAfterSeconds;
    
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(string memory _symbol, string memory _name, uint _amountMintedAfterTime, uint _secondsToMint) public {
        symbol = _symbol;
        name = _name;
        amountMintedAfterTime = _amountMintedAfterTime;
        timeToMint = _secondsToMint;
        decimals = 0;
        _totalSupply = 0 * 10**uint(decimals); //will be generated when minted
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }
    
    function tokenCollectable() public view returns(bool){
        return (addressAllowedToGetTokenAfterSeconds[msg.sender] > 0 && addressAllowedToGetTokenAfterSeconds[msg.sender] <= now);
    }

    function timeUntilCollectable() public view returns(uint) {
        return addressAllowedToGetTokenAfterSeconds[msg.sender];
    }
    
    function startProducing() public {
        require(!tokenCollectable());
        addressAllowedToGetTokenAfterSeconds[msg.sender] = now + timeToMint;
    }
    
    function collectToken() public {
        require(tokenCollectable());
        addressAllowedToGetTokenAfterSeconds[msg.sender] = 0;
        _totalSupply = _totalSupply.add(amountMintedAfterTime);
        balances[msg.sender] = balances[msg.sender].add(amountMintedAfterTime);
    }


    
}
