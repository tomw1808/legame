var Artifact = artifacts.require("Sugar");

module.exports = function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [], //required tokens
     [], //required token-amounts,
     "Sugar", //name
     "Sugar Cane Factory", //description
     5*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     2, //upon collection this amount of game currency will be produced
     [2,6,30,200,2000], //price of "GameCurrency" for upgrading
     [2,6,50,180,360], //amount of collection items per factory level
     [60,2*60,15*60,30*60,2*60*60] //time for collection
     ).then(ContractDeployed => {
      return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
   });
};
