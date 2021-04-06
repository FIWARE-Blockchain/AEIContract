const AssetContract = artifacts.require("../contracts/Assets.sol");
module.exports = function(deployer) {
  deployer.deploy(AssetContract);
};