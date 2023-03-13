// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TestUtils {
    function getTestAddresses() internal pure returns (address[3] memory){
        return [
            address(0x67676767676767),
            address(0x87878787878787),
            address(0x97979797979797)
        ];

    }
    
    function balanceOf(address _address) internal view returns (uint){
        return address(_address).balance;
    }
}