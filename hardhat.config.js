require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.2",
  networks: {
    munbai: {
      url: process.env.MUNBAI_RPC_URL,
      accounts: [process.env.MUNBAI_PRIVATE_KEY],

    }
  }
};
