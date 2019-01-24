var Artifact = artifacts.require("Sprinkle");

module.exports = async function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [artifacts.require("Sugar").address], //required tokens
     [5], //required token-amounts,
     "Sprinkle", //name
     "Sprinkle Generator", //description
     5*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     9, //upon collection this amount of game currency will be produced
     [1,5,20,100,500], //price of "GameCurrency" for upgrading
     [1,3,10,20,100], //amount of collection items per factory level
     [30,60,2*60,5*60,30*60] //time for collection
     ).then(ContractDeployed => {
      return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
   });
};
