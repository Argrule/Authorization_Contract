const Auth = artifacts.require("./Auth.sol");

contract("Auth", accounts => {
  it("...should store the value 0.", async () => {
    const AuthInstance = await Auth.deployed();

    // Set value of 89
    // await AuthInstance.set(89, { from: accounts[0] });

    // Get number of users
    const userNums = await AuthInstance.test.call();

    assert.equal(userNums, 0, "The initial number was not right.");
  });
});
