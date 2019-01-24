var GameCurrency = artifacts.require("GameCurrency");

module.exports = function(deployer) {
  deployer.deploy(GameCurrency,"DT", "Dolce Token");
};
