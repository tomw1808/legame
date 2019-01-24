pragma solidity ^0.5.0;

import {FixedSupplyToken, ERC20Interface} from "./Erc20Base.sol";
import {GameResourceInterface} from "./GameResourceBase.sol";
import "./GameCurrency.sol";

contract MergerResource is FixedSupplyToken, GameResourceInterface {
    uint public timeToCollect = 1 hours;
    uint public pricePerToken = 0;
    struct TokensRequest {
        address originOfToken;
        uint amountNecessary;
    }
    TokensRequest[] public tokensNecessary;
    mapping(address => uint) public addressAllowedToGetTokenAfterSeconds;
    mapping(address => uint) public addressAllowedToGetTokenBeforeSeconds;

    uint maxLevel = 5;
    mapping(address => uint) public factoryLevel;
    uint[] public levelUpgradeCost;
    uint[] public levelProductionAmount;
    uint[] public levelProductionTime;
    uint public gameCurrencyProductionAmountOnCollect;
    GameCurrency gameCurrencyContract;
    
    constructor(address[] memory tokenAddresses, uint[] memory amountsNecessary, string memory _symbol, string memory _name, uint _secondsToCollect, uint _pricePerToken, GameCurrency _gameCurrencyAddress, uint _gameCurrencyProductionAmountOnCollect, uint[] memory _levelUpgradeCost, uint[] memory _levelProductionAmount, uint[] memory _levelProductionTime) public {
        assert(tokenAddresses.length == amountsNecessary.length);
        assert(_levelProductionAmount.length == maxLevel);
        assert(_levelProductionTime.length == maxLevel);
        assert(_levelUpgradeCost.length == maxLevel);
        symbol = _symbol;
        name = _name;
        timeToCollect = _secondsToCollect;
        pricePerToken = _pricePerToken;
        levelUpgradeCost = _levelUpgradeCost;
        gameCurrencyContract = _gameCurrencyAddress;
        levelProductionAmount = _levelProductionAmount;
        levelProductionTime = _levelProductionTime;
        gameCurrencyProductionAmountOnCollect = _gameCurrencyProductionAmountOnCollect;

        
        for(uint key = 0; key < tokenAddresses.length; key++) {
            TokensRequest memory tokensRequest = TokensRequest(tokenAddresses[key], amountsNecessary[key]);
            tokensNecessary.push(tokensRequest);
        }
        decimals = 0;
        _totalSupply = 0 * 10**uint(decimals); //will be generated when minted
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    function setPricePerToken(uint _newPrice) public onlyOwner {
        pricePerToken = _newPrice;
    }

    function buyToken() public payable {
        assert(pricePerToken > 0);
        uint tokenAmount = msg.value / pricePerToken;
        require(tokenAmount > 0, "The provided Ether-Amount is not enough to buy one Token");
        _totalSupply = _totalSupply.add(tokenAmount);
        balances[msg.sender] = balances[msg.sender].add(tokenAmount);
    }

    function withdrawEther() onlyOwner public {
        msg.sender.transfer(address(this).balance);
    }

    function getTokenDependency() public view returns(address[] memory, uint[] memory) {
        uint[] memory amounts = new uint[](tokensNecessary.length);
        address[] memory tokensAddresses = new address[](tokensNecessary.length);
        for(uint i = 0; i < tokensNecessary.length; i++) {
            amounts[i] = (tokensNecessary[i].amountNecessary + (tokensNecessary[i].amountNecessary**factoryLevel[msg.sender])-1);
            tokensAddresses[i] = tokensNecessary[i].originOfToken;
        }
        return (tokensAddresses, amounts);
    }
    
    function tokenCollectable() public view returns(bool){
        return (addressAllowedToGetTokenAfterSeconds[msg.sender] > 0 && addressAllowedToGetTokenAfterSeconds[msg.sender] <= now && addressAllowedToGetTokenBeforeSeconds[msg.sender] >= now);
    }
    
    function timeUntilCollectable() public view returns(uint) {
        return addressAllowedToGetTokenAfterSeconds[msg.sender];
    }
    
    function timeUntilCollectionExpires() public view returns(uint) {
        return addressAllowedToGetTokenBeforeSeconds[msg.sender];
    }

    function getTimeToCollectBasedOnLevel() public view returns(uint) {
        return levelProductionTime[factoryLevel[msg.sender]];
    }

    function getCollectionAmountBasedOnLevel() public view returns(uint) {
        return levelProductionAmount[factoryLevel[msg.sender]];
    }

    function getLevelUpgradeCost() public view returns(uint) {
        return levelUpgradeCost[factoryLevel[msg.sender]];
    }
    
    function startProducing() public {
        require(!tokenCollectable(), "Token mintable, wait a bit and collect it first");
        for(uint key = 0; key < tokensNecessary.length; key++) {
            require(ERC20Interface(tokensNecessary[key].originOfToken).transferFrom(msg.sender, address(0x0), (tokensNecessary[key].amountNecessary + (tokensNecessary[key].amountNecessary**factoryLevel[msg.sender]))), "Transfer did not succeed");
        }

       
        addressAllowedToGetTokenAfterSeconds[msg.sender] = now + getTimeToCollectBasedOnLevel();
        addressAllowedToGetTokenBeforeSeconds[msg.sender] = now + getTimeToCollectBasedOnLevel() + timeToCollect;
    }

    function levelUp() public {
        assert(factoryLevel[msg.sender] < maxLevel);
        gameCurrencyContract.destroyTokenFor(msg.sender,levelUpgradeCost[factoryLevel[msg.sender]]); //going to throw an exception if not enough game tokens are available. No need to double check here.
        factoryLevel[msg.sender] = factoryLevel[msg.sender].add(1);
    }
    
    function collectToken() public {
        require(tokenCollectable(), "Token not yet mintable, wait a bit");
        addressAllowedToGetTokenAfterSeconds[msg.sender] = 0;
        addressAllowedToGetTokenBeforeSeconds[msg.sender] = 0;
        _totalSupply = _totalSupply.add(getCollectionAmountBasedOnLevel());
        balances[msg.sender] = balances[msg.sender].add(getCollectionAmountBasedOnLevel());
        gameCurrencyContract.createToken(msg.sender, gameCurrencyProductionAmountOnCollect);
    }
    
}