var GradientCoin = artifacts.require("./GradientCoin.sol");

contract('GradientCoin', function(accounts) {
  it("minting new coins", function() {
    return GradientCoin.deployed().then(function(instance) {
      return instance.totalSupply.call();
    }).then(function(total) {
      assert.equal(total, 2, console.log(total));
    });
  });
});