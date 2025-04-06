// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Auth.sol";

contract TestAuth {
    function testItReadsAValue() public {
        Auth auth = Auth(DeployedAddresses.Auth());

        uint expected = 0;

        Assert.equal(auth.test(), expected, "It should store the value 0.");
    }
}
