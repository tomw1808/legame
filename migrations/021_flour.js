var Artifact = artifacts.require("Flour");
module.exports = function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [], //required tokens
     [], //required token-amounts,
     "Flour", //name
     "Mill produces Flour", //description
     2*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     1, //upon collection this amount of game currency will be produced
     [1,5,20,100,500], //price of "GameCurrency" for upgrading
     [2,10,100,500,10000], //amount of collection items per factory level
     [50,90,5*60,30*60,2*60*60] //time for collection
     ).then(ContractDeployed => {
      return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
   });
};
