const Migrations = artifacts.require("Capsule");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
