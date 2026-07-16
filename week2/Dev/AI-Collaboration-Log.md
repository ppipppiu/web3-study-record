# AI Collaboration Log

## 项目说明

本周完成了一个最小链上每日签到智能合约 `CheckIn.sol`。

用户通过钱包地址完成签到，合约会记录：

- 累计签到次数；
- 当前连续签到天数；
- 最近一次签到日期；
- 当天是否已经签到。

该项目用于完成 Week 2 的 Dev 技术验证，目前不代表最终黑客松项目方向。

---

## 文档链接

本次主要参考：

- [Solidity 官方文档](https://docs.soliditylang.org/)
- [Remix IDE](https://remix.ethereum.org/)
- [Monad 官方文档](https://docs.monad.xyz/)

代码文件：
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CheckIn {

    struct CheckInInfo {
        uint256 totalCheckIns;
        uint256 currentStreak;
        uint256 lastCheckInDay;
    }

    mapping(address => CheckInInfo) private checkInRecords;

    event CheckedIn(
        address indexed user,
        uint256 checkInDay,
        uint256 totalCheckIns,
        uint256 currentStreak
    );

    function getCurrentDay() public view returns (uint256) {
        return block.timestamp / 1 days;
    }

    function hasCheckedInToday(address user) public view returns (bool) {
        return checkInRecords[user].lastCheckInDay == getCurrentDay();
    }

    function checkIn() public {
        uint256 currentDay = getCurrentDay();
        CheckInInfo storage info = checkInRecords[msg.sender];

        require(
            info.lastCheckInDay != currentDay,
            "You have already checked in today"
        );

        if (info.lastCheckInDay + 1 == currentDay) {
            info.currentStreak += 1;
        } else {
            info.currentStreak = 1;
        }

        info.totalCheckIns += 1;
        info.lastCheckInDay = currentDay;

        emit CheckedIn(
            msg.sender,
            currentDay,
            info.totalCheckIns,
            info.currentStreak
        );
    }
}
```
---

## 我让 AI 帮我理解了什么

我让 AI 帮助我理解了：

- 如何使用 `struct` 保存用户签到信息；
- 如何使用 `mapping` 按钱包地址隔离用户数据；
- `msg.sender` 如何识别当前签到用户；
- 如何通过 `block.timestamp` 判断当前日期；
- 如何使用 `require` 限制每天只能签到一次；
- 如何计算累计签到次数和连续签到天数；
- 如何通过 `event` 记录签到结果；
- 如何在 Remix 中编译、部署和测试合约。

---

## AI 生成了什么代码骨架或技术方案

AI 协助生成了 `CheckIn.sol` 的最小代码骨架，主要包括：

- `CheckInInfo`：保存累计签到次数、连续签到天数和最近签到日期；
- `checkInRecords`：按钱包地址保存签到信息；
- `getCurrentDay()`：计算当前日期编号；
- `hasCheckedInToday(address)`：查询某地址当天是否签到；
- `checkIn()`：完成签到并更新记录；
- `CheckedIn`：记录签到成功事件。

整体技术方案为：

```text
用户钱包
  ↓
调用 checkIn()
  ↓
合约检查当天是否已签到
  ↓
更新累计次数和连续签到天数
  ↓
触发 CheckedIn 事件
```

---

## 我手动修改和检查了什么

AI 生成代码骨架后，我手动完成了以下检查：

- 将 Solidity 版本确定为 `0.8.20`；
- 检查合约名称和文件名是否一致；
- 检查每个钱包地址的数据是否独立；
- 检查同一地址当天是否只能签到一次；
- 检查第一次签到时连续天数是否为 `1`；
- 检查连续签到和中断签到的计算逻辑；
- 检查查询函数是否只读取数据；
- 检查签到成功后是否触发事件。

我还在 Remix VM 中切换多个账户进行了实际测试。

---

## 当前是否跑通

**当前状态：已跑通。**

已在 Remix VM 中完成：

- 合约编译；
- 合约部署；
- 未签到状态查询；
- 第一次签到；
- 签到后状态查询；
- 同一账户重复签到失败；
- 切换账户签到；
- 多账户数据隔离测试。

测试结果符合预期。

---

## 如果没跑通，卡在哪里

当前代码骨架已经跑通，**没有代码或逻辑阻塞**。

Monad Testnet 部署、合约地址和交易 Hash 将在后续 `Prototype Evidence` 任务中补充，不影响本任务的完成状态。

---

## AI 与人工工作的边界

AI 主要用于：

- 理解 Solidity 文档；
- 拆解合约需求；
- 生成最小代码骨架；
- 提供测试思路；
- 协助分析错误信息。

我人工完成了：

- 检查代码逻辑；
- 在 Remix 中编译和部署；
- 调用合约函数；
- 切换测试账户；
- 验证重复签到限制；
- 判断测试结果是否符合需求。

因此，AI 提供的是开发辅助，最终是否跑通仍然以人工测试结果为准。
