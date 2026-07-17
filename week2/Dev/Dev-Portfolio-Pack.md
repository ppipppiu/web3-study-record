# Dev Portfolio Pack

## 1. 项目简介

本周完成了一个基于 Solidity 和 Monad Testnet 的最小链上每日签到原型。

用户通过钱包地址调用 `checkIn()` 完成签到，智能合约会记录累计签到次数、连续签到天数和最近一次签到日期，并限制同一个地址每天只能签到一次。

该项目主要用于完成 Week 2 的 Dev 技术验证，目前不代表最终黑客松项目方向。

---

## 2. 我想做什么

我希望实现一个最小可运行的链上签到功能，验证以下核心逻辑：

- 每个钱包地址拥有独立的签到记录；
- 用户每天只能签到一次；
- 合约记录累计签到次数；
- 合约记录连续签到天数；
- 用户可以查询当天是否已经签到；
- 签到交易可以在 Monad Testnet 上被公开验证。

当前优先完成智能合约和测试网交互，前端、后端和数据看板暂时不作为 Week 2 的重点。

---

## 3. 我实际做到了哪一步

目前已经完成：

- 编写 `CheckIn.sol` 智能合约；
- 在 Remix 中完成编译；
- 在 Remix VM 中完成基础测试；
- 完成第一次签到测试；
- 完成重复签到失败测试；
- 完成多账户数据隔离测试；
- 将合约部署到 Monad Testnet；
- 在 Monad Testnet 上成功调用 `checkIn()`；
- 使用 `hasCheckedInToday(address)` 查询到 `true`；
- 验证同一地址当天再次签到会失败；
- 整理 AI Collaboration Log；
- 整理 Prototype Evidence。

当前原型已经完成以下验证流程：

```text
合约部署成功
→ checkIn() 调用成功
→ hasCheckedInToday(address) 返回 true
→ 重复签到交易失败
```

---

## 4. 核心功能

### `checkIn()`

用户调用该函数完成当天签到。

签到成功后，合约会更新：

- 累计签到次数；
- 当前连续签到天数；
- 最近一次签到日期。

### `hasCheckedInToday(address)`

查询指定钱包地址当天是否已经完成签到。

签到成功后，查询结果为：

```text
true
```

### 重复签到限制

同一个钱包地址当天再次调用 `checkIn()` 时，交易会失败。

这说明“一天只能签到一次”的限制已经正常生效。

---

## 5. 技术方案

本项目采用以下技术方案：

```text
Solidity
  ↓
Remix 编译与测试
  ↓
MetaMask 连接 Monad Testnet
  ↓
部署 CheckIn 合约
  ↓
调用 checkIn()
  ↓
通过 MonadVision 验证交易
```

使用的主要工具包括：

- Solidity `0.8.20`
- Remix IDE
- MetaMask
- Monad Testnet
- MonadVision
- GitHub
- AI 辅助开发工具

---

## 6. Monad Testnet 运行证据

- 网络：Monad Testnet
- 合约地址：`0xc20A67bD4e6413e6c06E7248BDdb3bdF3dD3FBe1`
- 部署交易 Hash：`0x51bf6997e301f4aeaafd8a74ecd1f28b77e08ce7ea6eab39331a4fa6ac5adff2`
- 签到交易 Hash：`0x0d8602e2c5bf5fc15a85c7f603a42138fadcd41b6bac9ee320dddb4e6e7d96ad`

测试结果：

1. `checkIn()` 调用成功；
2. `hasCheckedInToday(address)` 返回 `true`；
3. 同一地址再次签到时交易失败；
4. 重复签到限制正常生效。

---

## 7. AI Collaboration

AI 在本项目中主要用于：

- 帮助拆解签到合约需求；
- 解释 `struct`、`mapping`、`msg.sender`、`require` 和 `event`；
- 生成最小代码骨架；
- 检查重复签到和连续签到逻辑；
- 提供 Remix 测试步骤；
- 协助分析部署和交互问题；
- 整理开发文档。

我人工完成了：

- 检查代码逻辑；
- 在 Remix 中编译和部署；
- 切换不同测试账户；
- 调用合约函数；
- 验证查询结果；
- 完成 Monad Testnet 部署；
- 保存合约地址和交易 Hash；
- 判断测试结果是否符合需求。

---

## 8. 当前 Mock 内容

为了控制 Week 2 原型范围，以下内容暂未实现：

- React 前端页面；
- MetaMask 一键连接界面；
- 签到排行榜；
- 用户头像和昵称；
- Spring Boot 后端；
- MySQL 数据库；
- 链上数据分析看板；
- NFT 或 Token 奖励。

当前重点是验证智能合约核心逻辑和 Monad Testnet 运行结果。

---

## 9. Known Issues

当前版本存在以下限制：

- 用户目前需要通过 Remix 与合约交互；
- 暂时没有可供普通用户使用的前端页面；
- 日期通过 `block.timestamp / 1 days` 计算，按照 UTC 时间划分；
- 当前没有直接返回完整签到信息的查询函数；
- 当前没有自动化测试；
- 排行榜和数据看板尚未实现；
- 当前项目不一定作为最终黑客松项目。

---

## 10. Week 3 可承担的开发角色

Week 3 我可以继续承担 Dev 方向的开发工作，主要包括：

- Solidity 智能合约开发；
- 合约逻辑测试；
- Remix 部署和调试；
- Monad Testnet 部署；
- MetaMask 钱包连接；
- 合约读写交互；
- 交易 Hash 和区块浏览器验证；
- 链上事件读取；
- 配合前端接入智能合约；
- 配合后端或数据看板读取链上数据；
- GitHub 项目文档和运行证据整理。

如果小组更换最终项目方向，我也可以将本周积累的合约开发、部署和交互经验迁移到新的 Prototype 中。

---

## 11. 总结

本周我完成了一个可以在 Monad Testnet 上运行的链上签到原型。

目前已经证明：

- 我能够将需求拆解为 Solidity 合约；
- 能够使用 AI 辅助生成和理解代码；
- 能够人工检查和测试合约逻辑；
- 能够完成测试网部署；
- 能够完成真实链上交互；
- 能够通过交易 Hash 和查询结果验证功能；
- 能够整理代码、文档和运行证据。

Week 3 我可以继续承担智能合约开发、测试网部署、钱包交互和链上数据读取等 Dev 工作。
