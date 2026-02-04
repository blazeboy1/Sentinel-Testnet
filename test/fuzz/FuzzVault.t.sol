// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../contracts/EthVault4626.sol";
import "../../contracts/strategy/MockYieldStrategy.sol";
import "../../contracts/mocks/MockERC20.sol";

contract FuzzVault is Test {
    EthVault4626 vault;
    MockYieldStrategy strategy;
    MockERC20 asset;

    function setUp() public {
        asset = new MockERC20("WETH", "WETH");
        strategy = new MockYieldStrategy(asset);
        vault = new EthVault4626(asset, strategy);
    }

    function testFuzz_depositWithdraw(uint96 amt, uint96 yield) public {
        amt = uint96(bound(amt, 1 ether, 100 ether));
        yield = uint96(bound(yield, 0, 50 ether));

        asset.mint(address(this), amt);
        asset.approve(address(vault), amt);

        vault.deposit(amt, address(this));
        strategy.addSimulatedYield(yield);

        uint256 shares = vault.balanceOf(address(this));
        vault.withdraw(
            vault.convertToAssets(shares),
            address(this),
            address(this)
        );

        assertLe(asset.balanceOf(address(this)), amt + yield);
    }
}
