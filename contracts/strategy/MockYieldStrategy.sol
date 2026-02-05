// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IStrategy.sol";

contract MockYieldStrategy is Ownable, IStrategy {
    IERC20 public immutable asset;
    uint256 public simulatedYield;

    constructor(IERC20 asset_) {
        asset = asset_;
    }

    function deposit(uint256) external override {}

    function withdraw(uint256) external override {}

    function totalAssets() external view override returns (uint256) {
        return asset.balanceOf(address(this)) + simulatedYield;
    }

    function addSimulatedYield(uint256 amount) external onlyOwner {
        simulatedYield += amount;
    }
}
