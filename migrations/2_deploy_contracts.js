var GradientCoin = artifacts.require("./GradientCoin.sol");
var Invest = artifacts.require("./Invest.sol");

module.exports = function(deployer) {
  deployer.deploy(GradientCoin);
  deployer.deploy(Invest);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);
};
