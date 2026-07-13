# GitHub Exploration Log：Moss

## 一、项目基本信息

项目名称：Moss
项目地址：[nishuzumi/moss](https://github.com/nishuzumi/moss)
主要语言：TypeScript
开源协议：MIT License
项目状态：Alpha 测试阶段

Moss 是一个面向 Monad 生态的链上交互能力层。它将复杂的 DApp 和 DeFi 协议交互封装成统一的、可以被 AI Agent 调用的功能，使 Agent 不需要自己处理 ABI、合约地址、calldata、代币精度和多步骤交易逻辑。([GitHub][1])

Moss 的核心流程是：

```text
discover → load → action → simulate
```

其中：

* `discover`：查找 Moss 当前支持的协议和功能。
* `load`：查看某项功能的参数、风险标签和使用说明。
* `action`：根据用户账户和参数生成待签名的交易计划。
* `simulate`：在签名前模拟交易，检查实际资产变化是否符合预期。

Moss 只负责构建和模拟交易，不会替用户签名或发送交易。用户的私钥仍然保存在钱包中，最终是否签名由用户决定。([GitHub][1])

---

## 二、项目解决的问题

普通的链上交易看起来可能只是一次简单的 Swap，但开发者通常需要处理：

* 合约地址；
* ABI；
* 合约方法；
* calldata；
* 代币 decimals；
* 滑点；
* 原生代币包装和解包；
* 授权步骤；
* 多次合约调用；
* 退款和清理流程。

如果 AI Agent 自己临时读取 ABI 并构造交易，很容易因为地址、参数或调用顺序错误而生成有风险的交易。

Moss 将这些复杂逻辑封装在统一的协议能力层中，再通过交易模拟检查计划中声明的资产变化与实际变化是否一致，从而降低 Agent 构造错误交易的风险。([GitHub][1])

---

## 三、项目目录结构

Moss 仓库的主要目录和文件如下：

```text
moss/
├── .changeset/
├── .claude/
│   └── agents/
├── .github/
├── docs/
├── examples/
├── packages/
├── .gitignore
├── .mcp.json
├── CLAUDE.md
├── CODE_OF_CONDUCT.md
├── CONTEXT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── README.zh-CN.md
├── SECURITY.md
├── TODO.md
├── biome.json
├── package.json
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
└── tsconfig.base.json
```

该项目采用 Monorepo 结构，主要代码放在 `packages/` 中，详细文档放在 `docs/` 中，可运行示例放在 `examples/` 中，并通过 pnpm workspace 管理多个软件包。([GitHub][1])

### 1. `.changeset/`

用于记录不同软件包的版本变化，帮助维护者管理版本号、发布流程和更新日志。

### 2. `.claude/agents/`

用于存放与 Claude Code Agent 有关的配置或 Agent 定义。

Moss 本身面向 AI Agent，因此这个目录主要用于配置 Agent 的任务流程和行为。

### 3. `.github/`

用于保存 GitHub 平台相关配置，例如：

* GitHub Actions；
* Issue 模板；
* Pull Request 模板；
* 自动化检查；
* 项目协作配置。

### 4. `docs/`

用于保存详细技术文档，包括：

* 新手入门指南；
* MCP 工具说明；
* Agent 使用规则；
* 协议接入指南；
* 架构决策记录；
* 项目术语说明。

README 负责快速介绍项目，而 `docs/` 负责进一步解释项目架构和使用方法。([GitHub][1])

### 5. `examples/`

用于保存可运行示例。

项目中的示例可以帮助开发者实际体验：

```text
discover → load → action → simulate
```

其中还包括 Agent 驱动交易的示例，用于展示 Agent 如何调用 Moss、模拟交易，并在本地 Monad 分叉环境中完成交易流程。([GitHub][1])

### 6. `packages/`

这是 Moss 最主要的源代码目录，包含核心逻辑、模拟器、ERC 标准接口、Monad 配置、协议适配器和 MCP Server。

---

## 四、核心模块及其作用

### 1. `@themoss/core`

`core` 是整个项目的基础模块，主要负责：

* 定义统一的协议能力接口；
* 管理协议注册；
* 定义 Plan、Capability 和 Query 等核心结构；
* 根据用户参数生成交易计划；
* 为其他模块提供通用基础能力。

该模块只包含通用机制，不保存具体链地址和协议 ABI。([GitHub][1])

### 2. `@themoss/simulator`

`simulator` 是 Moss 的交易验证模块，主要负责：

* 使用 `debug_traceCall` 模拟交易；
* 提取交易产生的实际效果；
* 检查代币转入和转出；
* 检查授权对象；
* 检查资产接收者；
* 对比实际效果与 Plan 中声明的预期效果；
* 对未声明的变化发出警告。

Moss 要求只要模拟结果中出现警告，就应该停止交易。([GitHub][1])

需要注意，模拟只能反映模拟时刻的链上状态。价格、流动性和合约状态可能在模拟后发生变化，因此模拟结果不能保证真实交易一定获得完全相同的结果。([GitHub][1])

### 3. `@themoss/erc`

`erc` 是标准代币接口层，主要包括：

* ERC-20 ABI；
* ERC-721 ABI；
* WETH9 ABI；
* 代币转账；
* 代币余额查询；
* 授权额度查询；
* 授权步骤构造。

这个模块负责处理通用代币标准，而不是某一个具体协议。([GitHub][1])

### 4. `@themoss/system`

`system` 用于保存 Monad 链上的具体实例和配置，包括：

* Monad 网络运行环境；
* 链的默认配置；
* 常见代币数据；
* WMON 相关功能；
* 与具体地址有关的系统适配器。

`core` 负责通用机制，而 `system` 为这些机制提供 Monad 链上的实际数据。([GitHub][1])

### 5. `@themoss/protocol-*`

这部分用于存放不同协议的适配器。

Moss 采用“一个协议对应一个软件包”的方式，例如：

```text
packages/protocols/protocol-kuru/
```

每个协议适配器需要说明：

* 协议支持什么功能；
* 功能需要哪些参数；
* 需要调用哪些合约；
* 如何构造交易；
* 交易预期产生什么资产变化；
* 如何查询协议状态。

项目还提供 `_template` 模板，帮助贡献者开发新的协议适配器。([GitHub][1])

### 6. `@themoss/mcp-server`

`mcp-server` 是 Moss 面向 AI Agent 的主要入口。

它向 Agent 提供四个 MCP 工具：

```text
discover
load
action
simulate
```

Agent 可以通过这些工具发现功能、读取参数、生成交易计划并进行模拟，而不需要直接处理具体协议的 ABI 和合约调用细节。([GitHub][1])

---

## 五、README 的作用

README 是用户进入项目后首先阅读的内容。

Moss 的 README 主要介绍：

* 项目的定位；
* 项目解决的问题；
* 核心操作流程；
* 安全模型；
* 当前支持的功能；
* 安装和运行方法；
* MCP Server 的使用方式；
* 作为代码库的使用方法；
* 仓库结构；
* 贡献方式；
* 安全提醒。

README 可以帮助用户快速判断这个项目是做什么的、是否符合自己的需求以及如何开始使用。

Moss 同时提供 `README.zh-CN.md`，方便中文开发者阅读。([GitHub][1])

---

## 六、Docs 的作用

`docs/` 比 README 更详细，主要面向想要深入使用或参与开发的用户。

Moss 文档包括：

* Getting Started：完整的新手入门流程；
* MCP Tools：四个 MCP 工具的参数和返回值；
* Protocol Onboarding：如何添加新的协议适配器；
* Agent Skill Guide：Agent 必须遵守的安全规则；
* Agent Swap Example：Agent 完成交易的示例；
* ADR：架构决策记录；
* Glossary：项目术语说明。([GitHub][1])

其中 ADR 是 Architecture Decision Record，即“架构决策记录”。

它用于说明项目为什么选择某种技术方案、这种方案有哪些优点和限制，以及是否考虑过其他替代方案。这样后来的贡献者不仅能看到最终代码，也能理解 Maintainer 的设计思路。

---

## 七、Issues 的作用

Issues 主要用于记录和追踪：

* Bug；
* 新功能需求；
* 文档改进；
* 协议接入需求；
* 架构问题；
* 开发任务。

Moss 当前使用不同标签管理 Issue，例如：

* `dex`：去中心化交易所相关；
* `needs-design`：需要先完成设计；
* `difficulty:intermediate`：中等难度任务；
* `good first issue`：适合第一次参与开源贡献的任务。

通过标签，贡献者可以快速判断一个任务属于什么方向、难度如何，以及是否适合自己。当前仓库页面显示有 12 个开放 Issue。([GitHub][2])

---

## 八、Pull Requests 的作用

Pull Request，简称 PR，用于向项目提交代码或文档修改。

一般流程是：

```text
Fork 项目
→ 创建开发分支
→ 修改代码或文档
→ 提交 Commit
→ 创建 Pull Request
→ Maintainer 审查
→ 根据反馈修改
→ 合并到主分支
```

Maintainer 可以在 PR 中：

* 查看修改内容；
* 评论具体代码；
* 要求补充测试；
* 查看自动化检查结果；
* 与贡献者讨论实现方式；
* 决定是否合并。

Moss 当前仓库页面显示没有正在开放的 Pull Request，因此本次探索选择一个 Issue 进行分析。([GitHub][1])

---

## 九、Discussions 的作用

Discussions 主要适合开放式社区交流，例如：

* 使用问题；
* 项目想法；
* 技术方案讨论；
* 社区公告；
* 功能建议；
* 经验分享。

Issues 更偏向一个可以被追踪和完成的具体任务，而 Discussions 更偏向开放讨论。

目前 Moss 仓库没有单独开启 Discussions 页面，因此项目当前主要通过 Issues 管理问题和功能需求。([GitHub][1])

---

## 十、感兴趣的 Issue

Issue 标题：Adapter: PancakeSwap swap

**Issue 的主要内容**

这个 Issue 的目标是在 Moss 中新增一个 PancakeSwap Swap 协议适配器，使 AI Agent 可以通过 Moss 完成代币兑换相关操作。

该适配器主要需要实现两个功能：
1. quote：查询两种代币之间的兑换报价；
2. swap：根据用户输入生成代币兑换交易计划。

用户需要提供的信息可能包括：
1. 输入代币；
2. 输出代币；
3. 兑换数量；
4. 滑点范围；
5. 用户钱包地址。

适配器需要调用 PancakeSwap Router 合约获取报价，并根据报价生成交易。生成的交易计划中还需要声明预期的资产变化，例如：
- 最多会转出多少输入代币；
- 最少应该收到多少输出代币；
- 是否需要先进行代币授权；
- 交易接收地址是谁。

最后还需要通过 Moss 的 simulate 功能模拟交易，检查实际资产变化是否与交易计划一致。

整体流程可以理解为：
```
输入代币、输出代币、数量和滑点
→ 查询 PancakeSwap 报价
→ 构造 Router 合约调用
→ 生成 Moss 交易计划
→ 模拟交易
→ 检查代币转入和转出结果
```

在正式开发前，还需要先确认 Monad 上部署的 PancakeSwap 版本，因为不同版本使用的 Router 合约、ABI 和调用方法可能不同。

**我为什么对这个 Issue 感兴趣**

我选择这个 Issue，是因为它与我目前学习的 Web3 Dev 方向比较接近。

我之前已经接触过：
- Solidity 智能合约；
- Monad Testnet；
- 合约部署和链上交易；
- 合约地址和交易 Hash；
- ABI 和合约函数调用；
- MetaMask 钱包交互。

这个 Issue 可以让我在已有基础上继续学习更真实的链上协议交互，而不仅是部署一个简单的智能合约。

通过解决这个 Issue，我可以进一步了解：
- DEX 的代币兑换流程；
- PancakeSwap Router 合约的作用；
- 报价和实际交易之间的关系；
- 滑点是如何处理的；
- ERC-20 授权为什么是 Swap 的前置步骤；
- Moss 如何将不同协议封装成统一接口；
- 如何通过交易模拟提前发现风险；
- 如何按照开源项目规范提交 Pull Request。

该 Issue 被 Maintainer 标记为 good first issue 和 difficulty:starter，说明它相对于项目中的借贷协议、ERC-1155 和复杂 DeFi 协议适配器更适合初学者。

同时，项目中已经存在 Kuru Swap adapter，可以作为实现 PancakeSwap adapter 的参考，因此不需要完全从零开始设计。


---

## 十一、Maintainer 如何组织和管理项目

### 1. 使用 Monorepo 管理多个模块

项目将核心逻辑、模拟器、ERC 标准、Monad 配置、协议适配器和 MCP Server 拆分为不同软件包。

这样可以明确各个模块的职责，也方便分别开发、测试和维护。

### 2. 使用统一的协议适配器结构

Moss 采用一个协议对应一个软件包的方式，并提供 `_template` 模板。

这样可以避免不同贡献者使用完全不同的项目结构，降低新增协议的开发成本。([GitHub][1])

### 3. 使用 Issues 和标签管理任务

Maintainer 使用协议类型、功能类型和任务难度等标签组织 Issue。

新贡献者可以优先查看带有以下标签的任务：

```text
good first issue
difficulty:starter
```

### 4. 使用文档记录架构设计

Moss 使用 ADR 记录重要的架构决策和不同方案之间的权衡。

这样可以帮助后来的贡献者理解项目为什么采用当前的实现方式。([GitHub][1])

### 5. 明确项目的安全边界

Moss 在 README 和安全文档中强调：

* Moss 不签名；
* Moss 不发送交易；
* 模拟结果不是执行保证；
* 出现 warning 时应该停止；
* 用户需要在钱包中重新检查交易；
* 项目仍处于 Alpha 阶段；
* 项目目前尚未经过正式审计。([GitHub][1])

---

## 十二、我的发现

### 1. 开源项目不只是代码

一个完整的开源项目通常还包括：

* README；
* Docs；
* Issues；
* Pull Requests；
* 测试；
* 贡献指南；
* 安全文档；
* 行为准则；
* 自动化工作流；
* 架构决策记录。

这些内容共同决定了一个项目是否容易被理解、使用和维护。

### 2. 项目目录能够反映架构思想

Moss 按照不同职责拆分模块，大致可以理解为：

```text
通用机制
→ 交易模拟
→ 标准代币接口
→ Monad 链上实例
→ 具体协议适配器
→ Agent 调用入口
```

这种结构体现了不同功能之间的职责分离。

### 3. Issues 可以反映项目未来方向

通过查看 Issues，可以了解项目正在考虑增加哪些功能，以及目前存在哪些待解决问题。

因此，Issues 不只是 Bug 列表，也可以看作项目的发展计划和任务列表。

### 4. 初学者也能参与开源项目

参与开源项目不一定必须先开发复杂功能。

初学者可以从以下任务开始：

* 改进安装说明；
* 补充使用示例；
* 修正文档错误；
* 增加常见问题；
* 翻译文档；
* 复现并记录 Bug；
* 为已有功能补充测试。

---

## 十三、学习收获

通过这次 GitHub 项目探索，我学习到了：

1. 阅读陌生项目时，可以先通过 README 了解项目目标。
2. 可以通过目录结构判断项目的模块划分。
3. Docs 用于进一步解释使用方法和技术设计。
4. Issues 可以用于查看 Bug、功能需求和未来计划。
5. Pull Requests 用于提交、审查和合并代码或文档修改。
6. Maintainer 会通过标签、模板、贡献指南和自动化工具管理项目。
7. Web3 项目不仅需要实现功能，也必须明确安全边界。
8. AI Agent 不应该随意构造链上交易，而应该通过统一能力层和交易模拟降低风险。
9. 新手可以从文档改进和 `good first issue` 开始参与开源项目。
10. 清晰的新手文档能够明显降低一个项目的使用门槛。

---

## 十四、总结

Moss 是一个面向 Monad 生态的 Agent 链上交互工具。

它通过：

```text
discover → load → action → simulate
```

让 AI Agent 能够发现链上能力、读取功能参数、构造交易计划并进行模拟验证。

该项目采用 Monorepo 和分层模块结构，通过 `core`、`simulator`、`erc`、`system`、`protocol-*` 和 `mcp-server` 等模块分离不同职责。

通过阅读该项目，我了解了 Moss 的基本功能和技术结构，也理解了 Maintainer 如何利用 README、Docs、Issues、Pull Requests、贡献指南和安全文档组织开源项目。

我选择的 Issue 是增加面向初学者的 Quick Start Guide。这个 Issue 与我目前的学习阶段比较接近，也让我认识到，开源贡献不仅包括开发新功能，也包括帮助其他用户更容易地理解和使用项目。

[1]: https://github.com/nishuzumi/moss "GitHub - nishuzumi/moss · GitHub"
[2]: https://github.com/nishuzumi/moss/issues "Issues · nishuzumi/moss · GitHub"
