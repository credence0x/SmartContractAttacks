// SPDX-License-Identifier: MIT
pragma solidity ^0.4.18;
import "./Vault.sol";

/** @title VaultSolution - Solution to uninitialized storage pointer attack
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev 
    
        
 */
contract VaultSolution is Vault{
    function deposit(bytes32 _name) public payable virtual override {
        // solution: set location function to memory
        UserDetails memory userDetails;
        userDetails.name = _name;
        userDetails.balance = msg.value;
        map[msg.sender] = userDetails;
    }

}