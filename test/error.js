const Auth = artifacts.require("./Auth.sol");

contract("Auth", accounts => {
  it("should revert when destroy is called with wrong address", async () => {
    const AuthInstance = await Auth.deployed();

    const user = {
      ID: "刘荣",
      Address: "0x29b108670b4fc9ebe22c8cc50d5fa54e85a5f356",
      Signature: "0x1234567890abcdef1234567890abcdef12345678", // 错误签名
    };

    // 尝试用错误的地址调用 destroy，应该 revert
    let reverted = false;
    try {
      await AuthInstance.destroy(user.ID, user.Signature, { from: accounts[0] });
    } catch (error) {
      reverted = true;
    }
    assert.equal(reverted, true, "Contract did not revert on wrong address input");    
  });
});
