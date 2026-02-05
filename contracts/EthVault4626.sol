// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./strategy/IStrategy.sol";

contract EthVault4626 is ERC4626, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IStrategy public strategy;

    constructor(
        IERC20 asset_,
        IStrategy strategy_
    )
        ERC20("Sentinel Vault ETH", "svETH")
        ERC4626(asset_)
    {
        strategy = strategy_;
    }

    /// @notice Total assets = assets managed by strategy
    function totalAssets() public view override returns (uint256) {
        return strategy.totalAssets();
    }

    /// @notice Override deposit to forward funds to strategy
    function deposit(uint256 assets, address receiver)
        public
        override
        nonReentrant
        returns (uint256 shares)
    {
        shares = super.deposit(assets, receiver);

        IERC20(asset()).safeApprove(address(strategy), 0);
        IERC20(asset()).safeApprove(address(strategy), assets);
        strategy.deposit(assets);
    }

    /// @notice Override withdraw to notify strategy
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    )
        public
        override
        nonReentrant
        returns (uint256 shares)
    {
        uint256 available = IERC20(asset()).balanceOf(address(this));

        if (assets > available) {
            assets = available;
        }

        shares = super.withdraw(assets, receiver, owner);
        strategy.withdraw(assets);
    }
}
