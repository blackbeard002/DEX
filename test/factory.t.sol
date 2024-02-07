// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {Factory} from "../contracts/Factory.sol"; 

contract FactoryTest is Test 
{
    Factory public factory; 

    function setUp() public
    {
        factory = new Factory();
    }

    function test_Factory() public
    {
        address token = 0xf19681998788b7d1235cFd47C74510a51902A91B;
        address newExchange = factory.createExchange(token);
        console2.log("New Exchange:%s",newExchange);
        assertNotEq(newExchange, address(0));
        assertEq(token, factory.get_Token(newExchange));
        assertEq(newExchange, factory.get_Exchange(token));
    }

}
