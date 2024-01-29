// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./exchange.sol";

contract Factory 
{
    mapping(address=>address) s_Token_To_Exchange;
    mapping(address=>address) s_Exchange_To_Token;

    function createExchange(address token) public returns(address)
    {
        require(s_Token_To_Exchange[token] == address(0));
        
        address new_exchange = address(new Exchange());

        s_Token_To_Exchange[token] = new_exchange;
        s_Exchange_To_Token[new_exchange] = token; 

        return new_exchange; 
    }
}
