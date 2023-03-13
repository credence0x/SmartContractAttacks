// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

contract TestUtils {
   
    function balanceOf(address _address) internal view returns (uint){
        return address(_address).balance;
    }
}