# Onchain Todo Mini Demo

## 1. 项目简介

这是一个部署在 Monad Testnet 上的最小 Onchain Todo Demo。

每个钱包地址可以：

- 创建自己的 Todo；
- 查询自己的 Todo；
- 将指定 Todo 标记为已完成。

不同用户通过 `msg.sender` 拥有独立的 Todo 列表。

## 2. 我做了什么

我使用 Solidity 编写了一个 Onchain Todo 智能合约，并通过 Remix 将其部署到 Monad Testnet。

随后完成了以下链上交互：

1. 部署智能合约；
2. 调用 `createTodo` 创建任务；
3. 调用 `getMyTodos` 查询任务；
4. 调用 `completeTodo` 将任务标记为已完成；
5. 在区块浏览器中检查交易状态和交易信息。

## 3. 真实链上操作

以下操作真实发生在 Monad Testnet：

- 合约部署；
- 创建 Todo；
- 完成 Todo；
- 通过区块浏览器查询交易状态。

合约地址：

`填写你的合约地址`

部署交易：

`填写部署交易浏览器链接`

createTodo 交易：

`填写 createTodo 交易浏览器链接`

completeTodo 交易：

`填写 completeTodo 交易浏览器链接`

## 4. AI 辅助完成的部分

AI 主要协助我完成了：

- 根据需求生成 Solidity 合约初稿；
- 解释合约结构和函数作用；
- 检查可能需要人工确认的安全问题；
- 整理部署与交互步骤；
- 整理 README 和提交材料。

## 5. 人工判断和修改

我人工完成或确认了以下内容：

- 检查合约是否能够正常编译；
- 确认每个用户通过 `msg.sender` 访问自己的 Todo；
- 检查数组下标是否通过 `require` 防止越界；
- 确认写入操作需要钱包签名并消耗测试 Gas；
- 判断部署和调用交易是否成功；
- 核对合约地址、交易哈希和区块浏览器信息；
- 确认 README 中没有私钥、助记词、API Key 或 `.env` 文件。

## 6. 功能说明

### createTodo

创建一条新的 Todo，并记录任务文本、完成状态和创建时间。

### completeTodo

将指定 Todo 标记为已完成。

### getMyTodos

读取当前钱包地址拥有的全部 Todo。

## 7. 项目技术栈

- Solidity 0.8.x
- Remix IDE
- MetaMask
- Monad Testnet
- Monad 区块浏览器

## 8. Week 2 方向

我选择 Tech 方向。

接下来希望继续学习智能合约、DApp 前端连接、钱包交互和链上数据展示，并将当前只有 Remix 操作界面的 Todo 合约扩展为一个带有可视化页面的轻量 DApp。
