// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/** @title Reentrant - Recreating a reentrancy bug
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev This is a base class for a contract that has a reentrancy bug
         The bug can be found in the `withdraw` function of this contract 
         and other contracts that try to fix the bug will modify/override
         the withdraw function
 */
contract Reentrant {
    mapping(address => uint) public balances;
    mapping(address => uint256) public lastWithdrawTime;

    uint public DEPOSIT_VALUE = 0.1 ether;
    uint public WITHDRAWAL_VALUE = 0.1 ether;

    function deductBalance(address _addr, uint _amount) internal {
        // Since solidity ^0.8, overflow and underflow
        // errors are thrown automaticallywhen they occur
        // so we bypass this with the if else statement
        if (balances[_addr] >= _amount){
            balances[_addr] -= _amount;
        } else {
            balances[_addr] = 0;
        }
    }


    function deposit() public payable {
        require(msg.value >= DEPOSIT_VALUE);
        balances[msg.sender] += msg.value;
    }

    function withdraw() public payable virtual {
        uint _amount = WITHDRAWAL_VALUE;

        require(balances[msg.sender] >= _amount);

        // check withdrawal limit
        require(block.timestamp >= lastWithdrawTime[msg.sender]);

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        deductBalance(msg.sender, _amount);
        lastWithdrawTime[msg.sender] = block.timestamp;
    }

}
