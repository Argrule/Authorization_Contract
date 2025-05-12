const Auth = artifacts.require("./Auth.sol");

contract("Auth", accounts => {
  it("...should store the value 0.", async () => {
    const AuthInstance = await Auth.deployed();

    const user = {
      ID: "刘荣",
      Address: "0x29b108670b4fc9ebe22c8cc50d5fa54e85a5f356",
    }
    /**
     * 测试注册用户
     * ID: "刘荣"
     * Address: "0x29b108670b4fc9ebe22c8cc50d5fa54e85a5f356"
     * 私钥："0x096511aeb9f27a2944d987f1e8495f6cc360d31e4851a6fe9de7f9e2765e30b8"
     * 助记词："警 夹 选 耕 道 形 界 违 划 幻 杨 妻"
     */
    await AuthInstance.register(user.ID, user.Address, { from: accounts[0] });
    console.log("register test successful!");
    // Get public address
    const pub_addr = await AuthInstance.verify.call(user.ID);
    console.log("The public address is ",pub_addr);
    assert.equal(pub_addr.toLowerCase(), user.Address, "The public address was not right.");
  });
});
