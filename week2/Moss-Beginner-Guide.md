# Moss 新手入门指南

## 1. Moss 是什么

Moss 是一个面向 Monad 生态的开源开发框架，主要作用是把链上协议操作封装成 AI Agent 可以调用的能力。

传统的 AI Agent 如果需要完成代币转账、授权或 Swap 等链上操作，通常要自己理解合约地址、ABI、函数参数和交易数据。Moss 将这些内容封装起来，让 Agent 可以按照以下流程完成链上操作：

```text
discover → load → action → simulate
````

各步骤的作用如下：

* `discover`：发现目前可以使用的协议和功能。
* `load`：加载指定协议或能力的详细信息。
* `action`：根据用户需求构建链上操作。
* `simulate`：在正式签名前模拟交易并检查执行结果。

需要注意的是，Moss 只负责构建和模拟未签名交易，不会代替用户签名，也不会直接发送交易。

> Moss 目前仍属于未经审计的 Alpha 阶段项目，不建议使用真实生产资金进行测试。

---

## 2. Moss 可以做什么

Moss 目前主要支持 Monad 网络中的以下操作：

* 查询原生 MON 和 ERC-20 代币余额。
* 转账 ERC-20 代币。
* 授权 ERC-20 代币额度。
* 查询代币授权额度和基础信息。
* 转账 ERC-721 NFT。
* 查询 NFT 所有者和持有数量。
* 将 MON 包装为 WMON。
* 将 WMON 解除包装为 MON。
* 通过 Kuru 协议查询 Swap 报价。
* 构建并模拟 Kuru Swap 交易。
* 作为 MCP Server 接入支持 MCP 的 AI Agent。

Moss 当前主要面向 Monad Mainnet，Chain ID 为 `143`。

---

## 3. 环境准备

在运行 Moss 之前，需要提前安装以下工具：

* Git
* Node.js 22 或更高版本
* pnpm 11
* VS Code 或其他代码编辑器

### 3.1 检查 Node.js 版本

打开终端并运行：

```bash
node -v
```

如果返回版本低于 Node.js 22，需要先升级 Node.js。

### 3.2 检查 pnpm 版本

运行：

```bash
pnpm -v
```

如果电脑中还没有安装 pnpm，可以运行：

```bash
npm install -g pnpm
```

安装完成后再次检查：

```bash
pnpm -v
```

---

## 4. 下载 Moss 项目

打开终端，执行以下命令：

```bash
git clone https://github.com/nishuzumi/moss.git
```

进入项目目录：

```bash
cd moss
```

也可以使用 VS Code 打开项目：

```bash
code .
```

如果终端不支持 `code` 命令，也可以手动打开 VS Code，然后选择 Moss 项目文件夹。

---

## 5. 安装项目依赖

在 Moss 项目根目录运行：

```bash
pnpm install
```

该命令会根据项目中的 `package.json` 和 `pnpm-lock.yaml` 安装所有依赖。

安装过程可能需要几分钟。执行完成后，如果没有出现红色报错，一般说明依赖安装成功。

---

## 6. 构建项目

安装依赖后运行：

```bash
pnpm build
```

Moss 使用 Monorepo 结构，构建命令会依次构建不同的 Workspace Package。

需要先执行 `pnpm build`，再进行类型检查，因为部分 Workspace Package 需要使用构建后生成的类型声明文件。

---

## 7. 运行第一个 Moss 示例

Moss 官方提供了一个简单的操作流程示例，可以用来体验：

```text
discover → load → action → simulate
```

运行 WMON Wrap 模拟：

```bash
pnpm --filter @themoss/example-simple-flow wrap
```

该示例会构建一个将 MON 包装为 WMON 的操作，并对交易进行模拟。

Moss 不会签名或发送交易，因此运行示例时不需要私钥，也不要求测试账户中拥有真实资金。

运行成功后，可以在终端中看到：

* 调用的协议能力。
* 构建出的未签名交易。
* 模拟执行结果。
* 交易产生的状态变化。
* Moss 生成的 Receipt。
* 是否存在 Warning。

---

## 8. 运行 Swap 模拟示例

Moss 还提供了 Kuru Swap 示例，可以模拟 MON 兑换 USDC：

```bash
pnpm --filter @themoss/example-simple-flow swap
```

该示例主要包含以下过程：

1. 查询 Kuru Swap 报价。
2. 加载对应的 Swap 能力。
3. 构建未签名交易。
4. 模拟交易执行。
5. 检查交易产生的状态变化。
6. 生成结构化 Receipt。

如果模拟过程中出现交易回滚、Receipt 解析失败或状态变化不匹配，Moss 会产生 Warning。

在真实应用中，出现 Warning 的交易不应该继续交给用户签名。

---

## 9. 运行测试

如果希望测试项目，可以运行：

```bash
pnpm test
```

如果不希望测试过程调用实时 RPC，可以运行离线测试：

```bash
pnpm test:offline
```

离线测试更适合初次检查本地环境是否配置正确。

开发过程中还可以运行以下命令：

```bash
pnpm typecheck
```

用于检查 TypeScript 类型错误。

```bash
pnpm lint
```

用于检查代码格式和代码规范问题。

完整的基础检查流程可以写成：

```bash
pnpm build
pnpm typecheck
pnpm lint
pnpm test:offline
```

---

## 10. Moss 项目目录结构

Moss 主要采用 Monorepo 结构，核心目录如下：

```text
moss/
├── docs/
├── examples/
├── packages/
├── .github/
├── package.json
├── pnpm-workspace.yaml
├── pnpm-lock.yaml
├── README.md
├── README.zh-CN.md
└── CONTRIBUTING.md
```

### `docs`

存放 Moss 的教程、架构设计、协议接入、安全规则和 MCP 工具说明。

### `examples`

存放可以直接运行的示例项目。

新手可以先阅读并运行这里的示例，了解 Moss 的完整调用流程。

### `packages`

存放 Moss 的核心功能模块和协议模块，是项目最主要的源码目录。

### `.github`

存放 GitHub Issue、Pull Request 和自动化工作流等项目协作配置。

### `README.md`

英文版项目介绍和快速开始文档。

### `README.zh-CN.md`

中文版项目介绍，中文用户可以优先阅读。

### `CONTRIBUTING.md`

项目贡献指南。准备提交 Issue 或 Pull Request 前，应先阅读该文件。

---

## 11. Moss 核心模块

### `@themoss/core`

Moss 的核心模块，主要负责：

* Registry 注册。
* 参数规则。
* Capability 构建。
* Capability Tree 管理。
* Receipt 校验。
* Protocol 与 Method 的能力组织。

### `@themoss/simulator`

交易模拟模块，主要负责：

* 调用 `debug_traceCall`。
* 模拟交易执行。
* 提取链上状态变化。
* 记录 Event 和原生 MON 转账。
* 检查交易是否回滚。
* 输出模拟 Warning。

### `@themoss/erc`

通用 ERC 协议模块，主要支持：

* ERC-20 转账。
* ERC-20 授权。
* 余额查询。
* 授权额度查询。
* 代币信息查询。
* ERC-721 转账和所有权查询。

### `@themoss/system`

Monad 系统级模块，主要包含：

* Monad Runtime。
* 官方合约常量。
* MON 和 WMON 相关能力。
* Monad 网络基础配置。

### `@themoss/protocol-*`

特定协议的接入模块。

例如 Kuru 协议模块会包含：

* 协议合约 ABI。
* 协议地址。
* Swap Capability。
* Quote Query。
* 参数校验规则。
* Receipt 解析逻辑。

### `@themoss/mcp-server`

MCP Server 模块，用于将 Moss 的功能暴露给支持 MCP 的 AI Agent。

---

## 12. Moss 为什么需要交易模拟

普通链上应用通常会直接让钱包显示一笔待签名交易，但普通用户很难仅根据合约地址和十六进制数据判断交易是否安全。

Moss 会在用户签名前对交易进行模拟，并提取交易可能产生的状态变化，例如：

* 转出了多少 MON。
* 收到了多少代币。
* 修改了多少授权额度。
* 哪个 NFT 的所有权发生了变化。
* 是否触发了预期的合约事件。
* 交易是否发生回滚。

模拟完成后，Moss 会生成结构化 Receipt，帮助 Agent 和用户判断交易结果是否符合原始意图。

因此，Moss 的重点不只是“生成交易”，还包括“验证交易是否符合用户的真实需求”。

---

## 13. Moss 与钱包的关系

Moss 不负责保存用户私钥，也不会直接替用户签名。

一个较安全的完整流程是：

```text
用户提出需求
↓
AI Agent 理解需求
↓
Moss 发现和加载能力
↓
Moss 构建未签名交易
↓
Moss 模拟并生成 Receipt
↓
AI Agent 检查结果是否符合需求
↓
钱包展示交易
↓
用户确认并签名
↓
钱包发送交易
```

这种设计将“理解用户意图”“构建交易”和“签名交易”分离，可以降低 Agent 直接控制钱包带来的风险。

---

## 14. 将 Moss 配置为 MCP Server

完成项目构建后，可以将 Moss 添加到支持 MCP 的客户端中。

基础配置示例如下：

```json
{
  "mcpServers": {
    "moss": {
      "command": "node",
      "args": [
        "<path-to-moss>/packages/mcp-server/dist/cli.js"
      ],
      "env": {
        "MOSS_RPC_URL": "https://rpc.monad.xyz"
      }
    }
  }
}
```

需要将：

```text
<path-to-moss>
```

替换为电脑中 Moss 项目的真实绝对路径。

例如：

```text
/Users/yourname/Documents/moss
```

配置完成后，MCP 客户端可以调用 Moss 提供的四个工具：

* `discover`
* `load`
* `action`
* `simulate`

不同 MCP 客户端的配置文件位置可能不同，因此应根据具体客户端的文档填写。

---

## 15. 常见问题

### 15.1 `pnpm` 命令不存在

可能是因为还没有安装 pnpm，可以运行：

```bash
npm install -g pnpm
```

然后重新打开终端。

### 15.2 Node.js 版本过低

Moss 要求 Node.js 22 或更高版本。

检查版本：

```bash
node -v
```

版本不符合要求时，需要升级 Node.js 后重新安装依赖。

### 15.3 `pnpm build` 执行失败

可以依次检查：

1. 当前终端是否位于 Moss 根目录。
2. 是否已经执行 `pnpm install`。
3. Node.js 和 pnpm 版本是否符合要求。
4. 安装依赖时是否出现网络错误。
5. 是否修改过项目文件。

确认后重新运行：

```bash
pnpm install
pnpm build
```

### 15.4 示例运行时出现 RPC 错误

Moss 示例会读取 Monad 的实时链上状态，因此需要正常的网络连接和可用的 RPC。

可以检查：

* 当前网络是否正常。
* RPC 地址是否可访问。
* 环境变量是否填写正确。
* RPC 是否存在限流或临时故障。

### 15.5 是否需要准备私钥

运行官方模拟示例通常不需要私钥。

Moss 只负责构建和模拟未签名交易，不会替用户进行签名和广播。

### 15.6 是否需要准备 MON

运行 Moss 的模拟示例通常不需要真实资金。

但如果后续通过钱包实际发送交易，则需要账户拥有对应网络的 Gas Token。

### 15.7 为什么需要先 Build 再 Typecheck

Moss 的部分 Workspace Package 会引用构建后生成的 TypeScript 类型声明，因此应先运行：

```bash
pnpm build
```

再运行：

```bash
pnpm typecheck
```

---

## 16. 新手推荐学习顺序

第一次学习 Moss 时，可以按照以下顺序进行：

1. 阅读 `README.zh-CN.md`。
2. 安装 Node.js 22 和 pnpm 11。
3. Clone Moss 仓库。
4. 执行 `pnpm install`。
5. 执行 `pnpm build`。
6. 运行 Wrap 示例。
7. 运行 Swap 示例。
8. 执行离线测试。
9. 阅读 `examples` 目录。
10. 阅读 `packages` 中的核心模块。
11. 了解 `discover → load → action → simulate` 流程。
12. 阅读 `CONTRIBUTING.md`。
13. 选择简单的 Issue 或文档问题参与贡献。

