var Artifact = artifacts.require("Sprinkledcupcakes");

module.exports = async function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [artifacts.require("Cupcakes").address,artifacts.require("Sprinkle").address], //required tokens
     [2,1], //required token-amounts,
     "Sprinkled Cupcakes", //name
     "Sprinkled Cupcake Fairy", //description
     5*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     75, //upon collection this amount of game currency will be produced
     [5,	15,	75,	525,	5000], //price of "GameCurrency" for upgrading
     [1,	3,	21,	84,	168], //amount of collection items per factory level
     [5*60,15*60,60*60,2*60*60,5*60*60] //time for collection
     ).then(ContractDeployed => {
      return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
   });
};
