var Artifact = artifacts.require("Milk");

module.exports = function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [], //required tokens
     [], //required token-amounts,
     "Milk", //name
     "Cow Farm", //description
     2*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     1, //upon collection this amount of "Game Currency" will be produced
     [1,3,35,150,500], //price of "GameCurrency" for upgrading
     [2,10,100,500,10000], //amount of collection items per factory level
     [45,2*60,5*60,30*60,2*60*60] //time for collection
     ).then(ContractDeployed => {
        return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
     });
};
