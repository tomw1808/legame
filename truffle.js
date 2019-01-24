/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "scrap spirit strategy tree appear sure thing buffalo leave odor wheel novel";
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!

    networks: {
      development: {
        host: "127.0.0.1",
        port: 8545,
        network_id: "*" // Match any network id
      },
      ropsten: {
        // must be a thunk, otherwise truffle commands may hang in CI
        provider: function() {
         return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/cc89dfe9dad94c1cb20f3eb2d1e31be9")
        },
        network_id: '3',
        gas:7000000
      }
    }
};
