//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 

import {Exchange} from "../src/factory.sol";
import {Test,console2} from "forge-std/Test.sol";

contract ExchangeTest is Test 
{
    Exchange public exchange;

    address token = 0xf19681998788b7d1235cFd47C74510a51902A91B;

    function setUp() public 
    {
        exchange = new Exchange(token);
    }

     function test_addLiquidity() public 
     {
        
     }
}