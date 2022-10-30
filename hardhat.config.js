require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.2",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
  },
  defaultNetwork: 'matic',
  networks: {
    hardhat: {},
    matic: {
      url: process.env.MUNBAI_RPC_URL,
      accounts: [process.env.MUNBAI_PRIVATE_KEY],
    }
  }
};
