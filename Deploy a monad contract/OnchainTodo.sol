// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainTodo {
    struct Todo {
        string text;
        bool isCompleted;
        uint256 createdAt;
    }

    mapping(address => Todo[]) private todos;

    event TodoCreated(
        address indexed user,
        uint256 indexed todoIndex,
        string text,
        uint256 createdAt
    );

    event TodoCompleted(
        address indexed user,
        uint256 indexed todoIndex,
        uint256 completedAt
    );

    function createTodo(string calldata text) external {
        require(bytes(text).length > 0, "Todo text cannot be empty");

        todos[msg.sender].push(
            Todo({
                text: text,
                isCompleted: false,
                createdAt: block.timestamp
            })
        );

        uint256 todoIndex = todos[msg.sender].length - 1;

        emit TodoCreated(
            msg.sender,
            todoIndex,
            text,
            block.timestamp
        );
    }

    function completeTodo(uint256 todoIndex) external {
        require(
            todoIndex < todos[msg.sender].length,
            "Todo does not exist"
        );

        require(
            !todos[msg.sender][todoIndex].isCompleted,
            "Todo is already completed"
        );

        todos[msg.sender][todoIndex].isCompleted = true;

        emit TodoCompleted(
            msg.sender,
            todoIndex,
            block.timestamp
        );
    }

    function getMyTodos() external view returns (Todo[] memory) {
        return todos[msg.sender];
    }
}
