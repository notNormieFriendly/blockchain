var GradientCoin = artifacts.require("./GradientCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(GradientCoin);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);
};
