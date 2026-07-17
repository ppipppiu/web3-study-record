# Prototype Evidence

## 项目介绍

这是一个部署在 Monad Testnet 上的最小链上签到原型。

用户通过钱包地址调用 `checkIn()` 完成每日签到，智能合约会记录累计签到次数、连续签到天数和最近签到日期，并限制同一个地址每天只能签到一次。

---

## 如何运行或查看

1. 在 Remix 中打开 `CheckIn.sol`；
2. 使用 Solidity `0.8.20` 编译合约；
3. 通过 MetaMask 连接 Monad Testnet；
4. 部署 `CheckIn` 合约；
5. 调用 `checkIn()` 完成签到；
6. 使用 `hasCheckedInToday(address)` 查询当天签到状态；
7. 在 MonadVision 中查看合约部署和签到交易。

---

## 当前完成内容

目前已经完成：

- `CheckIn.sol` 智能合约；
- Remix 编译；
- Remix VM 基础测试；
- Monad Testnet 合约部署；
- Monad Testnet 签到交易；
- 签到状态查询；
- 同一账户重复签到失败测试；
- 多账户数据隔离测试。

---

## 核心功能

### `checkIn()`

用户调用该函数完成当天签到。

执行成功后，合约会更新：

- 累计签到次数；
- 当前连续签到天数；
- 最近一次签到日期。

### `hasCheckedInToday(address)`

查询指定钱包地址当天是否已经签到。

签到成功后，查询结果为：

```text
true
```

### 重复签到限制

同一个钱包地址当天再次调用 `checkIn()` 时，交易会失败。

这说明“一天只能签到一次”的限制已经生效。

---

## Monad Testnet 运行证据

- 网络：Monad Testnet
- 合约地址：`0xc20A67bD4e6413e6c06E7248BDdb3bdF3dD3FBe1`
- 部署交易 Hash：`0x51bf6997e301f4aeaafd8a74ecd1f28b77e08ce7ea6eab39331a4fa6ac5adff2`
- 签到交易 Hash：`0x0d8602e2c5bf5fc15a85c7f603a42138fadcd41b6bac9ee320dddb4e6e7d96ad`

---

## 测试结果

### 1. 签到交易成功

`checkIn()` 已在 Monad Testnet 上调用成功，交易状态显示为成功。



### 2. 签到状态查询成功

调用：

```solidity
hasCheckedInToday(address)
```

查询结果为：

```text
0: bool: true
```

说明当前钱包地址当天已经完成签到。



### 3. 重复签到失败

同一个地址当天再次调用 `checkIn()` 时，交易失败。

这是合约预期行为，证明重复签到限制正常生效。



---

## Mock 内容

为了控制 Week 2 原型范围，以下内容暂未实现：

- React 前端页面；
- MetaMask 一键连接界面；
- 签到排行榜；
- 用户头像和昵称；
- Spring Boot 后端；
- MySQL 数据库；
- 链上数据分析看板；
- NFT 或 Token 奖励。

当前主要验证智能合约核心功能和 Monad Testnet 运行结果。

---

## Known Issues

- 当前主要通过 Remix 与合约交互，暂时没有普通用户前端；
- 日期通过 `block.timestamp / 1 days` 计算，按照 UTC 时间划分；
- 当前没有直接返回完整签到信息的查询函数；
- 当前没有自动化测试；
- 排行榜和数据看板尚未实现。

---

## 结论

当前原型已经完成完整的测试网验证：

```text
合约部署成功
→ checkIn() 调用成功
→ hasCheckedInToday(address) 返回 true
→ 重复签到交易失败
```

这证明 `CheckIn` 原型已经可以在 Monad Testnet 上运行，并且核心签到逻辑符合预期。
