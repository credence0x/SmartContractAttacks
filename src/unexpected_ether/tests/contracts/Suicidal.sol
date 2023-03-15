// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Suicidal {
    function kill(address payable _addr) public payable{
        selfdestruct(_addr);
    }
}
