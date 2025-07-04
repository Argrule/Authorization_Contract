const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  compilers: {
    solc: {
      version: "0.8.0"
    }
  },
  contracts_build_directory: path.join(__dirname, "target"),
  networks: {
    develop: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' //Match any network id
    }, 
    test: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' //Match any network id
    }
  }
};
