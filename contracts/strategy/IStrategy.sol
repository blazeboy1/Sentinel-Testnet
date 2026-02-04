// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IStrategy {
    function deposit(uint256 assets) external;
    function withdraw(uint256 assets) external;
    function totalAssets() external view returns (uint256);
}
