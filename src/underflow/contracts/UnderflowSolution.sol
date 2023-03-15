

// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "./Underflow.sol";
/** @title Underflow - Recreating an arithmetic underflow bug
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev Bug fix for underflow error
        Note that you can also use a library like Openzeppelin safe Math
        or just upgrade solidity version to ^0.8 
 */
contract UnderflowSolution is Underflow {
    
    function withdraw(uint _amount) public virtual override {
        require(balances[msg.sender] >= _amount,"insufficient fund");
        payable(msg.sender).transfer(_amount);
        balances[msg.sender] -= _amount;

    }
}
