// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Reentrant.sol";
/** @title ReentrantSolutio2 - Solution to reentrancy bug
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev The bug in the original contract is fixed by 
        using the msg.sender.transfer method as the gas sent
        when that method is used is not enough to call an external contract

 */
contract ReentrantSolution2 is Reentrant {

   function withdraw() public payable virtual override{
        uint _amount = WITHDRAWAL_VALUE;

        require(balances[msg.sender] >= _amount);

        // check withdrawal limit
        require(block.timestamp >= lastWithdrawTime[msg.sender]);

        // @solution the gas from the msg.sender.transfer
        // function sends 2300 gas which makes it 
        // impossible for another contract to be called
        // during function execution 
        payable(msg.sender).transfer(_amount);

        deductBalance(msg.sender, _amount);
        lastWithdrawTime[msg.sender] = block.timestamp;
    }
}
