//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0; 

contract Exchange
{
    address s_token;
    constructor(address token)
    {
        s_token=token;
    }
}