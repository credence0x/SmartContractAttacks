// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TestUtils {
   
    function balanceOf(address _address) internal view returns (uint){
        return address(_address).balance;
    }
}