// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./strategy/IStrategy.sol";

contract EthVault4626 is ERC4626, ReentrancyGuard {
    IStrategy public strategy;

    constructor(ERC20 asset_, IStrategy strategy_)
        ERC20("Sentinel Vault ETH", "svETH")
        ERC4626(asset_)
    {
        strategy = strategy_;
    }

    function totalAssets() public view override returns (uint256) {
        return strategy.totalAssets();
    }

    function afterDeposit(uint256 assets, uint256) internal override {
        asset().approve(address(strategy), assets);
        strategy.deposit(assets);
    }

    function beforeWithdraw(uint256 assets, uint256) internal override {
        strategy.withdraw(assets);
    }
}
