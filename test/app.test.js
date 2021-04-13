const Assets = artifacts.require("../contract/Assets");

contract("Asset", accounts => {
  it("Create an asset", () =>
    Assets.deployed()
      .then(instance => {
        instance.name.call().then((res) => {
          console.log('name is' + res);
        })

        instance.owner.call().then((res) => {
          console.log('owner is' + res);
        })

        instance.symbol.call().then((res) => {
          console.log('owner is' + res);
        })
    }));
});