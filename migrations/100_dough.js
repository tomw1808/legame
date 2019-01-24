var Artifact = artifacts.require("Dough");

module.exports = async function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [artifacts.require("Milk").address, artifacts.require("Flour").address, artifacts.require("Eggs").address], //required tokens
     [3,2,2], //required token-amounts,
     "Dough", //name
     "Bakery Factory", //description
     2*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     7, //upon collection this amount of game currency will be produced
     [1,5,20,100,500], //price of "GameCurrency" for upgrading
     [2,10,100,500,10000], //amount of collection items per factory level
     [30,60,2*60,5*60,30*60] //time for collection
     ).then(ContractDeployed => {
      return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
   });
};
