//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0; 
import "./Exchange.sol";

contract Factory
{
    //address s_exchangeTemplate;
    mapping(address=>address) s_exchange_to_token; 
    mapping(address=>address) s_token_to_exchange; 
    mapping(uint=>address) s_id_to_token;
    uint s_tokenCount; 

    
    // constructor(address exchangeTemplate)
    // {
    //     require(exchangeTemplate!=address(0));
    //     s_exchangeTemplate=exchangeTemplate;
    // }

    event exchangeCreated
    (
        address token,
        address exchange
    );

    function createExchange(address token) public returns(address)
    {
        require(token!=address(0));
        require(s_token_to_exchange[token]==address(0));
        Exchange exchange; 
        exchange=new Exchange(token); 
        s_tokenCount++; 
        s_token_to_exchange[token]=address(exchange);
        s_exchange_to_token[address(exchange)]=token;
        s_id_to_token[s_tokenCount]=token; 
        emit exchangeCreated(token, address(exchange));
        return address(exchange); 
        //return 99999999999999999;
    } 

    function getExchange(address token) public view returns(address)
    {
        return s_token_to_exchange[token];
    }

    function gettoken(address exchange) public view returns(address)
    {
        return s_exchange_to_token[exchange];
    }

    function getTokenWithId(uint id) public view returns(address)
    {
        return s_id_to_token[id]; 
    }
}