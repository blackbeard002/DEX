// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter 
{
    address s_ExchangeTemplate;
    mapping(address=>address) s_TokenToExchange;
    mapping(address=>address) s_ExchangeToToken;

    constructor(address template)
    {
        s_ExchangeTemplate=template; 
    }

    function createExchange(address token) public returns(address)
    {
        require(s_TokenToExchange[token]==address(0));
        
    }
}
