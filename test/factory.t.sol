//SPDX-License-Identiifer:MIT
pragma solidity ^0.8.0; 

import {Test} from "forge-std/Test.sol";
import {Factory} from "../contracts/Factory.sol"; 
import "forge-std/console.sol";

contract FactoryTest
{
    Factory factory; 

    function setUp() public
    {
        factory=new Factory();
    }

    function test_createExchange() public 
    {
        console.log("Testing");
        address exchange=factory.createExchange(0x74E2cb43e21aC8Fbcc0b5c3eae95aF95bfADB4e3);
        console.logAddress(exchange);
        require(exchange!=address(0));
        //address another=factory.createExchange(0x74E2cb43e21aC8Fbcc0b5c3eae95aF95bfADB4e3);
        // console.logAddress(another);
    }
}