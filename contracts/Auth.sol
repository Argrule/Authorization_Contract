// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Auth {
    uint public userNums; // 系统用户数量
    mapping(address => uint8) private signTimes; // msg.sender -> 注册次数
    mapping(string => address) private id2PubAddr; // 用户id -> 签名恢复的地址

    event Register(address _add, string _id);
    event Modify(address _add, string _id);
    event Destroy(address _add, string _id);

    constructor() {
        userNums = 0;
    }

    // ECDSA 签名验证，从 signature 中解析 v, r, s
    function recoverSign(
        string memory _msg,
        bytes memory _signature
    ) public pure returns (address) {
        require(_signature.length == 65, "Invalid signature length");
     
        bytes32 _hash = getEthSignedMessageHash(_msg);
        bytes32 r;
        bytes32 s;
        uint8 v;

        // 使用 assembly 从 _signature 中提取 r, s, v
        assembly {
            r := mload(add(_signature, 32)) // 前 32 字节是 r
            s := mload(add(_signature, 64)) // 接下来 32 字节是 s
            v := byte(0, mload(add(_signature, 96))) // 最后 1 字节是 v
        }

        // 如果 v 是 0 或 1，转换为 27 或 28（以太坊标准）
        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid v value");

        return ecrecover(_hash, v, r, s);
    }
    /**
     * ! 注意：合约调用可能会暴露参数，应该避免重放攻击，所以下面只在更换/销毁时使用签名验证
     * ? 服务端验证时，也会泄漏签名，所以要求合约只对id签名，server方面对uuid签名，从而避开重放攻击
     */
    // 抢占式注册
    function register(
        string memory _id,
        address _pubAddr
        // string memory _msg,
        // bytes memory _signature
    ) public {
        require(signTimes[msg.sender] < 5, "Registration limit exceeded");
        require(id2PubAddr[_id] == address(0), "ID already registered");
        // id2PubAddr[_id] = recoverSign(_msg, _signature);// 根据签名恢复地址，证明注册者拥有私钥
        id2PubAddr[_id] = _pubAddr;
        signTimes[msg.sender]++;
        userNums++;
        emit Register(msg.sender, _id);
    }

    // 验证用户(获取pubAddr用于验证)
    function verify(string memory _id) public view returns (address) {        
        return id2PubAddr[_id];
    }

    // 修改用户信息
    function modify(
        string memory _id,
        address _newPubAddr,
        // string memory _msg,
        bytes memory _signature
    ) public {
        require(id2PubAddr[_id] != address(0), "User does not exist");
        require(
            recoverSign(_id, _signature) == id2PubAddr[_id],
            "Invalid signature"
        );

        id2PubAddr[_id] = _newPubAddr;
        emit Modify(msg.sender, _id);
    }

    // 销毁用户
    function destroy(
        string memory _id,
        // string memory _msg,
        bytes memory _signature
    ) public {
        require(id2PubAddr[_id] != address(0), "User does not exist");
        require(
            recoverSign(_id, _signature) == id2PubAddr[_id],
            "Invalid signature"
        );

        delete id2PubAddr[_id];
        // 注意：需确保 msg.sender 是注册者, 否则原注册者的名额永久减少
        if (signTimes[msg.sender] > 0) signTimes[msg.sender]--;
        userNums--;
        emit Destroy(msg.sender, _id);
    }

    function test() public view returns (uint) {
        return userNums;
    }

    function getEthSignedMessageHash(string memory _message) public pure returns (bytes32) {
        bytes memory msgBytes = bytes(_message);
        uint256 msgLength = msgBytes.length;
        bytes memory prefix = "\x19Ethereum Signed Message:\n";
        bytes memory lengthStr = uintToString(msgLength);

        return keccak256(abi.encodePacked(prefix, lengthStr, msgBytes));
    }

    // 将 uint 转为 string
    function uintToString(uint256 v) internal pure returns (bytes memory) {
        if (v == 0) return "0";
        uint256 maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint256 i = 0;
        while (v != 0) {
            uint256 remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i);
        for (uint256 j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        return s;
    }
}
