# Onchain Todo Contract on Monad Testnet

## 1. 合约简介

这是一个部署在 Monad Testnet 上的最小 Onchain Todo 智能合约。

该合约允许每个用户通过自己的钱包地址创建独立的 Todo 列表。用户可以创建 Todo、查询自己的 Todo，也可以将指定 Todo 标记为完成。

本项目用于练习智能合约从源码、编译、部署、交互到区块浏览器验证的完整流程。

---

## 2. 合约功能

### createTodo

创建一条新的 Todo。

- 函数类型：write function
- 是否修改链上状态：是
- 是否需要钱包确认：是
- 是否产生 transaction hash：是

### completeTodo

将指定编号的 Todo 标记为完成。

- 函数类型：write function
- 是否修改链上状态：是
- 是否需要钱包确认：是
- 是否产生 transaction hash：是

### getMyTodos

查询当前钱包地址创建的全部 Todo。

- 函数类型：read function
- 是否修改链上状态：否
- 是否需要钱包确认：否
- 是否产生 transaction hash：否

---

## 3. 部署环境

- 开发工具：Remix
- 钱包：MetaMask
- 网络：Monad Testnet
- Solidity 版本：0.8.x
- 合约名称：OnchainTodo

---

## 4. 合约源码

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainTodo {
    struct Todo {
        string text;
        bool isCompleted;
        uint256 createdAt;
    }

    mapping(address => Todo[]) private todos;

    event TodoCreated(address indexed user, uint256 indexed index, string text);
    event TodoCompleted(address indexed user, uint256 indexed index);

    function createTodo(string memory _text) public {
        todos[msg.sender].push(
            Todo({
                text: _text,
                isCompleted: false,
                createdAt: block.timestamp
            })
        );

        emit TodoCreated(msg.sender, todos[msg.sender].length - 1, _text);
    }

    function completeTodo(uint256 _index) public {
        require(_index < todos[msg.sender].length, "Todo does not exist");

        todos[msg.sender][_index].isCompleted = true;

        emit TodoCompleted(msg.sender, _index);
    }

    function getMyTodos() public view returns (Todo[] memory) {
        return todos[msg.sender];
    }
}
```

---


## 5. 部署信息
合约地址：
>0xD7981E90dB205fec2a0c79b14626CfeEc9eF29da

部署交易 hash：
>0x733d950b78b6b84655ae056e5bc238428244f250f12f3d37032428f630019fa0

合约交互 transaction hash：
>0xdc76155e5bf3db168e4e176ee6a19129591c66050f1b19103cfbdde1c5774f34

## 6. 部署过程

我使用 Remix 编写并编译 OnchainTodo 合约，然后通过 MetaMask 连接 Monad Testnet，将合约部署到测试网。

部署成功后，Remix 显示合约已部署到 Monad Testnet，并生成了合约地址。

部署交易也可以在 MonadVision 区块浏览器中查询到，交易状态为 Success。

## 7. 合约交互过程
### 7.1 调用 write function

部署完成后，我调用了 createTodo 函数，创建了一条 Todo：
>Learn Monad smart contract

该操作属于 write function，会修改链上状态，因此需要 MetaMask 确认交易，并产生 transaction hash。
该交互交易可以在 MonadVision 中查询到，交易状态为 Success，方法为 CreateTodo。

### 7.2 调用 read function

随后我调用了 getMyTodos 函数，成功读取到刚刚创建的 Todo。

读取结果显示：
>Learn Monad smart contract
false
1783598820

其中：
>Learn Monad smart contract 是 Todo 内容
false 表示该 Todo 当前还没有被标记为完成
1783598820 是创建时间戳

## 8. 人工检查说明

我对合约进行了以下人工检查：
- 合约使用 msg.sender 区分不同用户，每个钱包地址都有独立的 Todo 列表。
-createTodo 会修改链上状态，因此属于 write function，需要钱包确认交易。
-getMyTodos 使用 view 修饰，只读取数据，不修改链上状态。
-completeTodo 使用 require 检查 Todo 下标是否存在，避免访问不存在的任务。
-合约源码中没有私钥、助记词、API Key、访问 Token、.env 文件或其他敏感信息。

## 9. 本次任务完成情况

本次任务完成了以下内容：
- 使用 Remix 编译 Solidity 合约
- 使用课程专用钱包连接 Monad Testnet
- 将合约部署到 Monad Testnet
- 保存合约地址和部署交易 hash
- 调用了一次 write function：createTodo
- 调用了一次 read function：getMyTodos
- 使用 MonadVision 区块浏览器验证部署交易和交互交易
- 整理 README 说明合约功能、部署过程和交互过程

