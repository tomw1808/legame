var Artifact = artifacts.require("Cupcakes");

module.exports = async function(deployer) {
  deployer.deploy(
    Artifact, //Artifact
     [artifacts.require("Dough").address], //required tokens
     [1], //required token-amounts,
     "Cupcakes", //name
     "Cupcake Bakery", //description
     5*60*60, //seconds to collect the item until it gets bad (default=2 hours)
     0, //price in Wei per token,
     artifacts.require("GameCurrency").address, //address of the currency
     25, //upon collection this amount of game currency will be produced
     [3,	9,	45,	300,	2000], //price of "GameCurrency" for upgrading
     [3,  9,  63, 300,  500], //amount of collection items per factory level
     [4*60,15*60,45*60,3*60*60,6*60*60] //time for collection
     ).then(ContractDeployed => {
      return artifacts.require("GameCurrency").deployed().then((instance) => { return instance.allowContractToModifyBalance(ContractDeployed.address)});
   });
};
