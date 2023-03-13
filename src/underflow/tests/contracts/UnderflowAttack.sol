// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../../contracts/Underflow.sol";
import "../../contracts/UnderflowSolution.sol";
import "../TestUtils.sol";

contract UnderflowAttack is Test,TestUtils {
    Underflow public underflow;
    UnderflowSolution public solution;

    constructor() {
        underflow = new Underflow();
        solution = new UnderflowSolution();
        vm.deal(address(underflow), 15 ether);
        vm.deal(address(solution), 15 ether);

    }

    function setUp() public {
        underflow.deposit{value: 0.5 ether}();
        solution.deposit{value: 0.5 ether}();
        assertTrue(balanceOf(address(underflow)) == 15.5 ether);
        assertTrue(balanceOf(address(solution)) == 15.5 ether);
    }

    function testAttack() public {
        underflow.withdraw(15.5 ether);
        assertTrue(balanceOf(address(underflow)) == 0 ether);
    }

    function testSolution() public {
        vm.expectRevert("insufficient fund");
        solution.withdraw(10 ether);
        assertTrue(balanceOf(address(solution)) == 15.5 ether);
    }

    function testSolutionValidWithdrawal() public {
        solution.withdraw(0.3 ether);
        assertTrue(balanceOf(address(solution)) == 15.2 ether);
    }

    receive() external payable {}
}
