// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../contracts/EthVault4626.sol";
import "../../contracts/strategy/MockYieldStrategy.sol";
import "../../contracts/mocks/MockERC20.sol";

contract VaultInvariant is Test {
    EthVault4626 vault;
    MockYieldStrategy strategy;
    MockERC20 asset;

    address alice = address(0xA11CE);
    address bob   = address(0xB0B);

    function setUp() public {
        asset = new MockERC20("WETH", "WETH");
        strategy = new MockYieldStrategy(asset);
        vault = new EthVault4626(asset, strategy);

        asset.mint(alice, 1000 ether);
        asset.mint(bob, 1000 ether);

        vm.prank(alice);
        asset.approve(address(vault), type(uint256).max);
        vm.prank(bob);
        asset.approve(address(vault), type(uint256).max);
    }

    function invariant_solvency() public {
        assertGe(
            vault.totalAssets(),
            vault.convertToAssets(vault.totalSupply())
        );
    }
}
