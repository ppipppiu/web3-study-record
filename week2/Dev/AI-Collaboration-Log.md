# AI Collaboration Log

## 1. 项目说明

本项目是一个部署在 Monad Testnet 上的链上每日签到原型。

用户通过自己的钱包地址进行签到，智能合约会分别记录每个地址的累计签到次数、当前连续签到天数和最近一次签到日期。

本周先完成最小可运行版本，重点验证以下功能：

- 不同钱包地址拥有独立的签到记录；
- 每个地址每天只能签到一次；
- 用户签到后，累计签到次数会增加；
- 连续签到时，连续签到天数会增加；
- 中断签到后，连续签到天数会重新计算；
- 用户可以查询自己当天是否已经签到。

---

## 2. 核心文档

本次开发主要参考了 Solidity 官方文档，并结合 AI 辅助理解以下内容：

- Solidity 合约的基本结构；
- `struct` 结构体的定义和使用；
- `mapping` 的数据存储方式；
- `msg.sender` 的作用；
- `block.timestamp` 的作用；
- `require` 条件检查；
- `event` 事件记录；
- `view` 查询函数；
- Remix 中合约的编译、部署与测试流程。

参考文档：

- Solidity 官方文档：<https://docs.soliditylang.org/>
- Remix IDE：<https://remix.ethereum.org/>
- Monad 官方文档：<https://docs.monad.xyz/>

---

## 3. 我向 AI 提出的问题

为了完成最小签到智能合约，我主要向 AI 提出了以下问题：

1. 如何设计一个最小可运行的链上每日签到合约？
2. 如何让不同钱包地址拥有独立的签到数据？
3. 如何判断用户当天是否已经签到？
4. 如何限制同一个地址一天只能签到一次？
5. 如何记录用户的累计签到次数？
6. 如何判断用户是否连续签到？
7. 用户中断签到后，如何重新计算连续签到天数？
8. `struct`、`mapping`、`msg.sender` 和 `block.timestamp` 分别有什么作用？
9. 如何在 Remix VM 中切换不同账户测试数据隔离？
10. 如何判断合约是否编译、部署和运行成功？
11. 如何测试重复签到失败的情况？
12. 后续如何把合约部署到 Monad Testnet？

---

## 4. 我让 AI 帮助理解了什么

### 4.1 `struct` 的作用

AI 帮助我理解了，`struct` 可以把多个相关字段组合成一组数据。

在本项目中，每个用户的签到信息包含：

- 累计签到次数；
- 当前连续签到天数；
- 最近一次签到日期。

因此使用 `CheckInInfo` 结构体统一保存这些信息，比单独建立多个变量更加清晰。

对应代码：

```solidity
struct CheckInInfo {
    uint256 totalCheckIns;
    uint256 currentStreak;
    uint256 lastCheckInDay;
}
```

---

### 4.2 `mapping` 的作用

AI 帮助我理解了，`mapping` 可以根据一个键查找对应的数据。

本项目使用钱包地址作为键，签到信息作为值：

```solidity
mapping(address => CheckInInfo) private checkInRecords;
```

它表示每个钱包地址都对应一份独立的 `CheckInInfo`。

例如：

- 钱包地址 A 有自己的签到记录；
- 钱包地址 B 有自己的签到记录；
- A 的签到操作不会直接修改 B 的数据。

---

### 4.3 `msg.sender` 的作用

AI 帮助我理解了，`msg.sender` 表示当前调用智能合约函数的钱包地址。

当用户调用 `checkIn()` 时，合约会通过 `msg.sender` 找到该用户自己的签到记录：

```solidity
CheckInInfo storage info = checkInRecords[msg.sender];
```

因此，用户不需要手动输入自己的钱包地址，也不能在签到函数中指定其他人的地址。

这种设计可以避免用户通过 `checkIn()` 修改其他钱包地址的签到数据。

---

### 4.4 `block.timestamp` 的作用

AI 帮助我理解了，`block.timestamp` 表示当前区块的时间戳，单位为秒。

为了判断用户是否在同一天签到，合约将时间戳除以一天的秒数：

```solidity
block.timestamp / 1 days
```

这样可以得到一个整数形式的日期编号。

对应函数：

```solidity
function getCurrentDay() public view returns (uint256) {
    return block.timestamp / 1 days;
}
```

合约不需要保存具体的年月日，只需要比较两次签到的日期编号是否相同。

---

### 4.5 `require` 的作用

AI 帮助我理解了，`require` 用于检查函数执行前必须满足的条件。

本项目使用 `require` 限制同一个地址一天只能签到一次：

```solidity
require(
    info.lastCheckInDay != currentDay,
    "You have already checked in today"
);
```

如果用户当天已经签到，再次调用 `checkIn()` 时，交易会失败，并返回对应的错误信息。

---

### 4.6 连续签到逻辑

AI 帮助我理解了连续签到的判断方法。

如果用户最近一次签到日期加一，正好等于今天，说明用户连续签到：

```solidity
if (info.lastCheckInDay + 1 == currentDay) {
    info.currentStreak += 1;
}
```

如果不是连续的日期，说明签到已经中断，需要重新开始计算：

```solidity
else {
    info.currentStreak = 1;
}
```

第一次签到时，`lastCheckInDay` 的默认值为 `0`，因此也会进入重新计算的逻辑，将连续签到天数设置为 `1`。

---

### 4.7 `event` 的作用

AI 帮助我理解了，`event` 可以在交易成功后，把关键操作写入交易日志。

本项目定义了：

```solidity
event CheckedIn(
    address indexed user,
    uint256 checkInDay,
    uint256 totalCheckIns,
    uint256 currentStreak
);
```

签到成功后触发：

```solidity
emit CheckedIn(
    msg.sender,
    currentDay,
    info.totalCheckIns,
    info.currentStreak
);
```

这样可以在 Remix 日志或区块浏览器中查看：

- 哪个地址完成了签到；
- 签到发生在哪一天；
- 当前累计签到次数；
- 当前连续签到天数。

后续前端、排行榜或数据看板也可以根据事件日志读取签到记录。

---

### 4.8 `view` 函数的作用

AI 帮助我理解了，`view` 函数只读取链上数据，不修改合约状态。

例如：

```solidity
function hasCheckedInToday(address user) public view returns (bool)
```

这个函数用于查询某个地址当天是否已经签到。

调用查询函数时不需要修改链上数据，在前端正常读取时也不需要发送状态变更交易。

---

## 5. AI 生成的最小代码骨架

AI 根据我的需求协助生成了 `contracts/CheckIn.sol` 的初始代码骨架。

代码骨架主要包含以下部分：

### 5.1 `CheckInInfo` 结构体

用于保存每个用户的签到状态：

- `totalCheckIns`：累计签到次数；
- `currentStreak`：当前连续签到天数；
- `lastCheckInDay`：最近一次签到的日期编号。

### 5.2 `checkInRecords` 映射

使用钱包地址关联用户自己的签到信息：

```solidity
mapping(address => CheckInInfo) private checkInRecords;
```

### 5.3 `getCurrentDay()` 函数

根据区块时间戳计算当前日期编号。

### 5.4 `hasCheckedInToday()` 函数

查询指定钱包地址当天是否已经签到。

### 5.5 `checkIn()` 函数

完成签到并更新：

- 累计签到次数；
- 连续签到天数；
- 最近一次签到日期。

### 5.6 `CheckedIn` 事件

记录用户签到成功后的关键信息。

---

## 6. 最终代码

当前最小版本的智能合约如下：

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

## 7. 我人工检查了什么

AI 生成代码后，我没有直接将代码视为最终结果，而是结合需求进行了人工检查。

### 7.1 Solidity 版本

我确认代码使用：

```solidity
pragma solidity ^0.8.20;
```

并在 Remix 中选择兼容的 Solidity 0.8.x 编译器。

---

### 7.2 用户数据是否隔离

我检查了：

```solidity
mapping(address => CheckInInfo) private checkInRecords;
```

以及：

```solidity
checkInRecords[msg.sender]
```

确认每个钱包地址拥有独立的数据记录。

用户通过 `checkIn()` 只能更新 `msg.sender` 对应的数据，不能直接修改其他用户的数据。

---

### 7.3 是否限制重复签到

我检查了 `require` 条件：

```solidity
require(
    info.lastCheckInDay != currentDay,
    "You have already checked in today"
);
```

确认同一个地址当天第二次签到时会失败。

---

### 7.4 连续签到逻辑

我检查了以下判断：

```solidity
if (info.lastCheckInDay + 1 == currentDay)
```

确认只有最近一次签到日期与当前日期相差一天时，连续签到天数才会增加。

如果间隔超过一天，连续签到天数会重新设置为 `1`。

---

### 7.5 第一次签到逻辑

新的钱包地址还没有签到记录时，各字段默认值为 `0`。

第一次调用 `checkIn()` 时，不满足连续签到条件，因此：

```solidity
info.currentStreak = 1;
```

符合第一次签到的预期。

---

### 7.6 状态更新顺序

我检查了函数的执行顺序：

1. 计算当前日期；
2. 获取当前用户的签到信息；
3. 检查当天是否已经签到；
4. 计算连续签到天数；
5. 增加累计签到次数；
6. 更新最近签到日期；
7. 触发签到事件。

该顺序可以避免重复签到后错误更新数据。

---

### 7.7 查询函数是否修改数据

我确认：

```solidity
getCurrentDay()
```

和：

```solidity
hasCheckedInToday(address user)
```

都声明为 `view`，只读取数据，不修改合约状态。

---

### 7.8 事件信息是否足够

我检查了 `CheckedIn` 事件中记录的字段：

- 用户地址；
- 签到日期编号；
- 累计签到次数；
- 连续签到天数。

这些信息足以支持后续的签到记录查询、排行榜统计和数据看板分析。

---

## 8. 我手动修改或确认了什么

在 AI 提供代码骨架后，我主要进行了以下人工处理：

1. 将 Solidity 版本统一为 `0.8.20`；
2. 检查合约名称和文件名保持一致；
3. 检查变量命名是否容易理解；
4. 确认签到记录按照钱包地址隔离；
5. 确认同一地址当天不能重复签到；
6. 确认第一次签到时连续天数为 `1`；
7. 确认连续签到时 `currentStreak` 正常增加；
8. 确认中断签到后连续天数重新计算；
9. 确认 `totalCheckIns` 每次有效签到只增加一次；
10. 确认查询函数不会修改链上状态；
11. 在 Remix 中进行编译、部署和手动测试；
12. 使用不同测试账户验证数据相互独立。

本次人工修改主要集中在逻辑确认、运行测试和结果验证，没有加入超出最小原型范围的复杂功能。

---

## 9. 测试环境

本项目目前使用以下环境进行开发和测试：

- 开发语言：Solidity
- Solidity 版本：0.8.20
- 开发工具：Remix IDE
- 本地测试环境：Remix VM
- 测试网络：Monad Testnet
- 钱包工具：MetaMask
- 代码托管：GitHub

---

## 10. 手动测试记录

### 10.1 编译测试

操作：

1. 在 Remix 中打开 `CheckIn.sol`；
2. 选择兼容的 Solidity 0.8.20 编译器；
3. 点击编译。

预期结果：

- 合约编译成功；
- 没有阻止部署的错误。

实际结果：

- 编译成功。

当前状态：

- 已完成。

---

### 10.2 部署测试

操作：

1. 在 Remix 中进入 Deploy & Run Transactions；
2. 选择 Remix VM 测试环境；
3. 选择 `CheckIn` 合约；
4. 点击 Deploy。

预期结果：

- 合约成功部署；
- Deployed Contracts 中出现 `CheckIn` 合约。

实际结果：

- 合约成功部署。

当前状态：

- 已完成。

---

### 10.3 未签到状态查询

操作：

1. 选择一个尚未签到的测试账户；
2. 将该地址输入 `hasCheckedInToday(address)`；
3. 点击查询。

预期结果：

```text
false
```

说明该地址当天还没有完成签到。

实际结果：

- 查询结果符合预期。

当前状态：

- 已完成。

---

### 10.4 第一次签到测试

操作：

1. 使用测试账户调用 `checkIn()`；
2. 点击 Transact；
3. 查看交易结果和事件日志。

预期结果：

- 交易执行成功；
- `totalCheckIns` 更新为 `1`；
- `currentStreak` 更新为 `1`；
- `lastCheckInDay` 更新为当天日期编号；
- 触发 `CheckedIn` 事件。

实际结果：

- 第一次签到成功；
- 交易执行结果符合预期。

当前状态：

- 已完成。

---

### 10.5 签到后状态查询

操作：

1. 第一次签到成功后；
2. 再次调用 `hasCheckedInToday(address)` 查询当前账户。

预期结果：

```text
true
```

实际结果：

```text
true
```

当前状态：

- 已完成。

---

### 10.6 重复签到失败测试

操作：

1. 使用当天已经签到的同一个账户；
2. 再次调用 `checkIn()`。

预期结果：

- 交易回滚；
- 返回错误信息：

```text
You have already checked in today
```

实际结果：

```text
The transaction has been reverted to the initial state.
Reason provided by the contract: "You have already checked in today".
```

这说明重复签到限制生效。

当前状态：

- 已完成。

---

### 10.7 切换账户签到测试

操作：

1. 在 Remix VM 中切换到另一个测试账户；
2. 查询该账户的签到状态；
3. 调用 `checkIn()`。

预期结果：

- 新账户初始查询结果为 `false`；
- 新账户可以正常完成第一次签到；
- 新账户的签到不受前一个账户影响。

实际结果：

- 新账户签到成功。

当前状态：

- 已完成。

---

### 10.8 多账户数据隔离测试

操作：

1. 使用账户 A 完成签到；
2. 切换到账户 B；
3. 查询账户 A 和账户 B 的签到状态；
4. 使用账户 B 完成签到；
5. 再次分别查询两个账户。

预期结果：

- 两个账户的数据按照钱包地址分别保存；
- 账户 A 的操作不会直接修改账户 B 的记录；
- 账户 B 的操作不会直接修改账户 A 的记录。

实际结果：

- 两个账户均可以独立签到；
- 数据隔离逻辑符合预期。

当前状态：

- 已完成。

---

## 11. 当前运行状态

当前状态：**Remix VM 中已跑通，Monad Testnet 部署待完成。**

已经完成：

- `CheckIn.sol` 代码编写；
- Remix 编译；
- Remix VM 部署；
- 未签到状态查询；
- 第一次签到测试；
- 签到后状态查询；
- 重复签到失败测试；
- 切换账户测试；
- 多账户数据隔离测试；
- 事件日志检查。

尚未完成：

- 将最终版本部署到 Monad Testnet；
- 保存最终合约地址；
- 保存部署交易 Hash；
- 在 Monad Testnet 调用一次 `checkIn()`；
- 保存签到交易 Hash；
- 在区块浏览器中确认交易状态；
- 将测试网证据补充到 README。

---

## 12. 本周真实实现与 Mock 范围

### 12.1 本周真实实现

本周真实实现以下内容：

- Solidity 每日签到智能合约；
- 按钱包地址保存用户签到信息；
- 每日一次签到限制；
- 累计签到次数；
- 连续签到天数；
- 当天签到状态查询；
- 签到事件；
- Remix VM 编译、部署和测试；
- Monad Testnet 部署与交互验证。

---

### 12.2 本周暂时 Mock 或不实现

为了控制原型范围，本周暂时不完整实现以下内容：

- React 前端页面；
- MetaMask 一键连接按钮；
- 用户签到按钮界面；
- 签到排行榜；
- Spring Boot 后端；
- MySQL 数据库；
- 链上事件同步服务；
- 数据分析看板；
- 用户头像和昵称；
- 签到奖励系统；
- NFT 或 Token 奖励；
- 管理员后台。

这些内容不会影响智能合约最小功能的验证，可以在后续阶段继续开发。

---

## 13. 为什么选择先实现智能合约

本项目的核心逻辑是链上签到，因此本周优先实现智能合约，而不是先制作完整前端。

这样安排有以下原因：

1. 智能合约决定签到数据如何保存；
2. 智能合约决定一天一次签到的限制；
3. 智能合约决定连续签到的计算规则；
4. 前端和后端都需要依赖已经确定的合约接口；
5. 先验证合约，可以尽早发现核心逻辑问题；
6. 使用 Remix 即可完成最小测试，不需要提前搭建完整工程。

因此，即使暂时没有前端页面，也可以通过 Remix 和区块浏览器证明原型已经能够运行。

---

## 14. AI 在本项目中的作用

AI 在本项目中主要承担以下辅助工作：

- 帮助拆解签到合约需求；
- 解释 Solidity 基础语法；
- 生成最小代码骨架；
- 解释每个函数的作用；
- 帮助检查重复签到逻辑；
- 帮助检查连续签到逻辑；
- 提供 Remix 测试步骤；
- 帮助分析测试结果；
- 帮助整理开发文档和测试记录。

AI 没有替代人工完成以下工作：

- 最终确定项目范围；
- 在 Remix 中实际编译代码；
- 部署合约；
- 切换测试账户；
- 发起签到交易；
- 判断交易是否成功；
- 检查不同账户的数据；
- 确认代码是否符合本项目需求；
- 决定哪些功能本周实现、哪些功能暂缓。

---

## 15. 对 AI 输出的判断

我认为 AI 输出可以作为代码骨架和学习辅助，但不能直接当作已经验证的最终结果。

主要原因是：

- AI 生成的代码可能存在语法或逻辑问题；
- AI 无法代替开发者完成真实部署；
- AI 无法仅凭代码证明测试结果；
- 连续签到等时间逻辑需要实际检查；
- 合约与钱包、网络、Remix 的连接需要人工操作；
- 项目需求可能在开发过程中发生调整。

因此，本项目采用的方式是：

1. 先用 AI 理解需求；
2. 让 AI 生成最小代码骨架；
3. 人工阅读代码；
4. 在 Remix 中编译；
5. 使用多个账户进行测试；
6. 根据测试结果判断代码是否可用；
7. 再将最终代码提交到 GitHub。

---

## 16. Known Issues

当前版本仍存在以下限制：

### 16.1 没有直接查询完整签到信息的函数

当前合约提供了：

```solidity
hasCheckedInToday(address)
```

但暂时没有提供直接返回以下全部信息的查询函数：

- 累计签到次数；
- 当前连续签到天数；
- 最近签到日期。

后续可以增加：

```solidity
getCheckInInfo(address user)
```

---

### 16.2 日期基于 UTC 时间计算

当前日期通过：

```solidity
block.timestamp / 1 days
```

计算，本质上按照 UTC 时间划分日期。

这可能与用户所在地区的自然日不完全一致。

当前最小原型接受这一限制，后续可以在前端明确显示日期口径，或根据业务需求重新设计签到周期。

---

### 16.3 尚未实现前端

当前用户需要通过 Remix 调用合约，不适合普通用户直接使用。

后续可以使用 React 和 ethers.js 或 viem 实现：

- 连接 MetaMask；
- 点击签到；
- 查询签到状态；
- 显示累计签到次数；
- 显示连续签到天数。

---

### 16.4 尚未实现排行榜

当前合约按照地址保存数据，但没有维护所有用户地址列表。

如果直接在合约中遍历大量用户，可能带来较高的 Gas 成本。

后续更适合通过 `CheckedIn` 事件，在链下读取并统计排行榜。

---

### 16.5 尚未进行自动化测试

当前测试主要通过 Remix 手动完成。

后续可以使用 Hardhat 或 Foundry 编写自动化测试，包括：

- 第一次签到成功；
- 当天重复签到失败；
- 连续签到天数增加；
- 中断后连续天数重置；
- 多账户数据隔离。

---

## 17. 后续开发计划

下一步计划按照以下顺序推进：

1. 将 `CheckIn.sol` 部署到 Monad Testnet；
2. 保存合约地址；
3. 保存部署交易 Hash；
4. 在 Monad Testnet 完成一次签到；
5. 保存签到交易 Hash；
6. 在区块浏览器确认交易成功；
7. 将运行证据上传到 GitHub；
8. 完善项目 README；
9. 增加 `getCheckInInfo(address)` 查询函数；
10. 使用 React 制作最小签到页面；
11. 使用 MetaMask 连接用户钱包；
12. 读取 `CheckedIn` 事件；
13. 制作签到记录和排行榜；
14. 后续接入 Spring Boot、MySQL 和数据看板。

---

## 18. 本次开发结论

通过本次 AI 辅助开发，我完成了一个最小可运行的链上每日签到智能合约。

目前已经验证：

- 合约可以成功编译和部署；
- 用户可以完成第一次签到；
- 同一个地址当天不能重复签到；
- 不同钱包地址的数据相互独立；
- 用户可以查询当天是否已经签到；
- 签到成功后会产生事件日志。

AI 主要用于帮助理解文档、生成代码骨架和检查思路，最终代码是否可用仍然通过人工阅读、Remix 编译和多账户测试进行确认。

当前原型已经在 Remix VM 中跑通。下一步是部署到 Monad Testnet，并补充合约地址、交易 Hash 和区块浏览器截图，形成完整的可验证开发证据。
