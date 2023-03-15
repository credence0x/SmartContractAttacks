
// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;


/** @title Underflow - Recreating an arithmetic underflow bug
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev This is a base class for a contract that has an underflow bug
         The bug can be found in the `withdraw` which can be called by 
         anyone who didn't make a deposit. Anyone would be able to withdraw

         [NOTE]
         ====
            This bug has been fixed in solidity ^0.8. An arithmetic error
            will be thrown if there is an overflow or underflow
         ====
 */
contract Underflow {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public virtual {

        if ((balances[msg.sender] - _amount) > 0){
            balances[msg.sender] -= _amount;
        } else {
            revert("Underflow: insufficient fund");
        }
        payable(msg.sender).transfer(_amount);
    }

    receive() external payable {}

}
