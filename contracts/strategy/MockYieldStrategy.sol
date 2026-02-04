// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MockYieldStrategy is Ownable {
    IERC20 public immutable asset;
    uint256 public simulatedYield;

    constructor(IERC20 asset_) {
        asset = asset_;
    }

    function deposit(uint256) external {}
    function withdraw(uint256) external {}

    function totalAssets() external view returns (uint256) {
        return asset.balanceOf(address(this)) + simulatedYield;
    }

    function addSimulatedYield(uint256 amount) external onlyOwner {
        simulatedYield += amount;
    }
}
