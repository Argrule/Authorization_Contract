# 毕业设计区块链认证系统

本项目包含三个主要部分：
- `server/`：后端服务，基于 NestJS，负责业务逻辑与区块链交互。
- `auth/`：智能合约及其测试，基于 Truffle。
- `auth_dapp/`：前端 DApp，基于 React + Vite。

---

## 目录结构说明

```
server/           # NestJS 后端服务
  src/            # 主要业务代码
  contract/       # 编译后的合约 ABI
  utils/          # 工具函数
  web3/           # 区块链交互模块
  test/           # 后端测试

auth/             # 智能合约与测试
  contracts/      # Solidity 合约源码
  migrations/     # Truffle 部署脚本
  test/           # 合约测试（JS & Solidity）
  target/         # 编译输出
  truffle-config.js # Truffle 配置

auth_dapp/        # 前端 DApp
  src/            # 前端源码
  contract/       # 前端用 ABI
  component/      # 组件
  view/           # 页面
  utils/          # 工具
  web3/           # 区块链交互
```

---

## 快速开始

### 1. 安装依赖

分别进入各目录安装依赖：

```bash
cd server && pnpm install
cd ../auth && pnpm install
cd ../auth_dapp && pnpm install
```

### 2. 编译与部署智能合约

```bash
cd auth
pnpm truffle compile
pnpm truffle migrate --network <your_network>
```

### 3. 运行后端服务

```bash
cd server
pnpm start
```

### 4. 启动前端 DApp

```bash
cd auth_dapp
pnpm dev
```

---

## 测试

- 合约测试：
  ```bash
  cd auth
  pnpm truffle test
  ```
- 后端测试：
  ```bash
  cd server
  pnpm test
  ```

---

## 主要功能简介

- 智能合约（`auth/contracts/Auth.sol`）：实现用户注册、验证、注销等功能。
- 后端服务（`server/`）：提供 RESTful API，负责与区块链交互。
- 前端 DApp（`auth_dapp/`）：用户注册、登录、信息查询等操作界面。

---

## 其他说明

- 请根据实际区块链网络配置 `.env` 或 `truffle-config.js`。
- 推荐使用 Node.js 16+，pnpm 8+。
- 如遇问题请先检查依赖和网络配置。

---

如需详细开发文档或遇到问题，欢迎联系作者或提交 issue。
