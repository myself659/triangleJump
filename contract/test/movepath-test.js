const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MovePath", function () {
  it("Should return true", async function () {
    const ContractFactoryVerifier = await hre.ethers.getContractFactory("Verifier");
    const Verifier = await ContractFactoryVerifier.deploy();

    await Verifier.deployed();

    console.log("Verifier deployed to:", Verifier.address);

    const ContractFactoryMovePath = await hre.ethers.getContractFactory("MovePath");
    const MovePath = await ContractFactoryMovePath.deploy(Verifier.address);

    await MovePath.deployed();

    console.log("MovePath deployed to:", MovePath.address);

    expect(
      await MovePath.verifyMovePath(
        ["0x2b56d1577f6ea59e156056d9800d551851fa9c7b6d2a66a8edf59b1eeaee478d", "0x30220d0d1bdc5d90407d3663360809c254e6228c47defd13dbc8f4a98a71e5d6"],
        [
          ["0x026bc113a6d0620c2a928df4ec2f4a2080dd1f7c9dce85ce6ed7c460669bdd7c",
            "0x24237c6531c24ab6c4ad44e13912235e3a107c8dcbb18760d43a815f1e7341f1"],
          ["0x2f38d7de27609bdc8388811048e1dcaa7111fa00039c9ffa02085a590c2d7d40",
            "0x26243c6f0a9a1e88bcc3e5af85b7ddd2b7c25809123ca17aac954f8547bd9b23"]
        ],
        ["0x1b269ab5ed66a9c807069613775a57ffd1d4dd4e45e4a22d6e0e77306d5c1c2d",
          "0x1a47f60b19b9ec14de18a3576f04dc65b6ff5d5fc8a0fc4569b2af90c4719799"],
        ["0x007bad9fe7f829e399815d21804f8e7922aa3251fec01fe273f4929199cda5e2",
          "0x21dfcd4db526f94871f53b3ec272c23a6e557750a56e4e88ce98a2e8c993a51f"]
      )
    ).to.equal(true);
  });
});
