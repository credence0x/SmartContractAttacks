// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./UnexpectedEther.sol";

/** @title Unexpected Ether - Creating a smart contract vulnerable to 
                                unexpected ether attack
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev see the base class for description
    
    Solution: the issue is solved by manually keeping track of balance
     deposited through the `play` function so that the assumptions are
     really invariant. 
 */
contract UnexpectedEtherSolution is UnexpectedEther{
    uint public depositedBalance;

    function play() public payable virtual override {
        require(msg.value == payableAmount);
        require(depositedBalance < withdrawableBalance);
        depositedBalance += msg.value;
    }

 
    function withdraw() public virtual override {
        require(depositedBalance == withdrawableBalance);
        payable(msg.sender).transfer(withdrawableBalance);
    }

}


