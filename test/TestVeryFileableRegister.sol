pragma solidity ^0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VeryFileableRegister.sol";

contract TestVeryFileableRegister {

  function testInitialFeePerKb() public {
    VeryFileableRegister reg = VeryFileableRegister(DeployedAddresses.VeryFileableRegister());

    uint expected = 1000000000000;

    Assert.equal(reg.weiPerKb(), expected, "Initial contract storage fee should be 1 szabo");
  }

  function testInitialBaseFee() public {
    VeryFileableRegister reg = VeryFileableRegister(DeployedAddresses.VeryFileableRegister());

    uint expected = 1000000000000000;

    Assert.equal(reg.weiPerKb(), expected, "Initial contract base fee should be 1 finney");
  }

}
