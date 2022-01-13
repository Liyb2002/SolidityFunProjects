var Adoption = artifacts.require("Adoption");
var IDRegistration = artifacts.require("IDRegistration");

module.exports = function(deployer) {
  deployer.deploy(Adoption);
  deployer.deploy(IDRegistration);
};