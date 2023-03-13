// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Reentrant.sol";
/** @title ReentrantSolution1 - Solution to reentrancy bug
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev The bug in the original contract is fixed by 
        updating the state of the user's balance before 
        making any external calls
 */
contract ReentrantSolution1 is Reentrant {
       function withdraw() public payable virtual override {
        uint _amount = WITHDRAWAL_VALUE;

        require(balances[msg.sender] >= _amount,"balance too low");

        // check withdrawal limit
        require(block.timestamp >= lastWithdrawTime[msg.sender]);

        //@solution update state before calling external contract
        deductBalance(msg.sender, _amount);
        lastWithdrawTime[msg.sender] = block.timestamp;

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

  
    }


}
