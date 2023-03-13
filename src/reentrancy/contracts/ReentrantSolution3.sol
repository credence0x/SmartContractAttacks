// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Reentrant.sol";
/** @title ReentrantSolution3 - Solution to reentrancy bug
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev The bug in the original contract is fixed by 
        using using a state variable to know whether the 
        contract is being reentered or not

 */
contract ReentrantSolution3 is Reentrant{
    bool public reentrantState = false;

    function withdraw() public payable override {
        uint _amount = WITHDRAWAL_VALUE;

        require(reentrantState == false,"reentrant: contract was rentered");
        require(balances[msg.sender] >= _amount);

        reentrantState = true;

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        reentrantState = false;

        deductBalance(msg.sender, _amount);
        lastWithdrawTime[msg.sender] = block.timestamp;

    }
}
