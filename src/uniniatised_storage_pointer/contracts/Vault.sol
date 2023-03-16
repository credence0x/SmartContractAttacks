// SPDX-License-Identifier: MIT
pragma solidity ^0.4.18;

/** @title Vault - Simulating an uninitialized storage pointer attack
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev This is a vault that allows you make ONE TIME deposits (for simplicity)
    and allows you make withdrawals at the whim of an imaginary administrator. Since
    there is no way to change the `locked` variable, it is expected that you should
    only be able to make deposits but never withdraw.

    
    A boolean is determined by the value of its last bit and the locked boolean is stored at storage slot[0]
    However the userDetails struct in deposit function was not perviously initailized, 
    so when initialized to storage, it points to same slot as the locked boolean (slot [0])
    and can thus overwrite whatever value is being stored at that location.
    
    An attacker can thus manipulate the locked variable by sending a `_name` parameter
    (to the deposit function) that has its lowest bit set to zero (e.g 0x4703...000) 
    ans therefore set the value to false.

    bytes32 public constant nonZeroEndingByteText =
        "NonZeroEndingBytes32StringString";
    bytes32 public constant zeroEndingByteText = "ZeroEndingBytes32String";

    [NOTE] [FOR VULNERABILITY TESTING]
    =====
     There are no tests because it was diifcult to test old versions of solidty with
     foundry. You can however deploy this smart contract on remix ide and test manually

     If you use a value such as 0x5a65726f456e64696e6742797465733332537472696e67000000000000000000 as 
     the parameter to the deposit function (including some ether), you will be able to withdraw

     However, if you set the last bit to 1 while depositing, you will not be able to withdraw 
     as expected becuase the last bit is non zero which sets locked to true
 */
contract Vault{

    bool locked = true;

    struct UserDetails {
        bytes32 name;
        uint balance;
    }

    mapping(address => UserDetails) map;


    function deposit(bytes32 _name) public payable {
        UserDetails storage userDetails;
        userDetails.name = _name;
        userDetails.balance = msg.value;
        map[msg.sender] = userDetails;

    }

    function withdraw() public payable {
        require(!locked);
        UserDetails storage userDetails = map[msg.sender];
        if (userDetails.balance > 0){
            msg.sender.transfer(userDetails.balance);
        }
    }

}