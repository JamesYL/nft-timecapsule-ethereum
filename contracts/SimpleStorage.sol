// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint storedData;

    function set1(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}