require("hardhat/config");
require("@nomicfoundation/hardhat-toolbox");

require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */

const HARDHAT_URL = process.env.HARDHAT_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports =  {
  solidity: "0.8.19",
  networks: {
    localhost: {
      url: HARDHAT_URL,
      accounts:  [PRIVATE_KEY],
    }
  }
};

//0xc5a5C42992dECbae36851359345FE25997F5C42d
