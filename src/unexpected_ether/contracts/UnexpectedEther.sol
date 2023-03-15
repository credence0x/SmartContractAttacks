// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/** @title Unexpected Ether - Creating a smart contract vulnerable to 
                                unexpected ether attack
    @author {Lanre Ojetokun - lojetokun@gmail.com }
    @dev Imagine that this is a game that allows anyone play by depositing ether
         but only the first person that calls the withdraw function 
         after the withdrawable balance has been reached.

         The bug is that the contract is making certain assumptions about 
         the amount of money the contract will hold at any given point. This
         contract assumes that the only way ether would be sent to it is through 
         the `play` payable function and therefore that contract balance would only increase 
         by 1 and therefore the contract balance would be 1,2,3...etc at any given point the 
         balance would never exceed the `withdrawableBalance`

         The problem arises if unexpected ether is sent e.g ( 0.1 ether) which nullifies the
         assumption and therefore disallows anyone from withdrawing since and locks any value
         in the contract forever
        
 */
contract UnexpectedEther{

    uint public withdrawableBalance = 5 ether;
    uint public payableAmount = 1 ether;


    function play() public payable virtual {
        require(msg.value == payableAmount);
        require(address(this).balance <= withdrawableBalance);
    }

 
    function withdraw() public virtual {
        require(address(this).balance == withdrawableBalance);
        payable(msg.sender).transfer(withdrawableBalance);
    }

}


