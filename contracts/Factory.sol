// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Exchange.sol";

contract Factory 
{
    mapping(address=>address) public s_Token_To_Exchange;
    mapping(address=>address) public s_Exchange_To_Token;

    event exchange_Created(address token,address exchange);

    function createExchange(address token) public returns(address)
    {
        require(token != address(0));
        require(s_Token_To_Exchange[token] == address(0));
        
        address new_exchange = address(new Exchange(token));

        s_Token_To_Exchange[token] = new_exchange;
        s_Exchange_To_Token[new_exchange] = token; 

        emit exchange_Created(token, new_exchange);

        return new_exchange; 
    }

    function get_Exchange(address token) public view returns(address)
    {
        return s_Token_To_Exchange[token];
    }

    function get_Token(address exchange) public view returns(address)
    {
        return s_Exchange_To_Token[exchange];
    }
}