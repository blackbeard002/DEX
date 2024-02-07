//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 

import {Exchange} from "../src/Factory.sol";
import "forge-std/Test.sol";
import {MockERC20} from "../src/Mock/MockERC20.sol";

contract ExchangeTest is Test,MockERC20 
{
    Exchange public exchange;
    MockERC20 public mockERC20; 

    address token = 0xf19681998788b7d1235cFd47C74510a51902A91B;

    function setUp() public 
    {
        exchange = new Exchange(token);
        mockERC20 = new MockERC20();
        
    }

     function test_addLiquidity() public 
     {
        //Mint tokens to add into liquidity
        mockERC20.mintTokens(1000000,address(1));

        //console2.log("Balance: %d",balance);
        assertEq(mockERC20.balanceOf(address(1)),1000000);
     }
}