const PetHealthRegistry = artifacts.require("PetHealthRegistry");

module.exports = function(deployer) {
    // Desplegar el contrato
    deployer.deploy(PetHealthRegistry);
};
