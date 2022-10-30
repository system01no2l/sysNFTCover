const { ethers } = require("hardhat");

async function main() {
  const ItachiIT=  await ethers.getContractFactory('ItachiIT');
  const itachiIT = await ItachiIT.deploy('Itachi', 'ITC');
  await itachiIT.deployed();
  console.log('Successfully deployed smart contract to: ', itachiIT.address);

  await itachiIT.mint('http://ipfs.io/ipfs/QmSLq9NjFjNVhxvG2UJE4yJjNkndVU4CCYCo11waTdBwx8');
  console.log('Minted smart contract.');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
