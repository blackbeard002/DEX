//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 

import {Exchange} from "../contracts/Factory.sol";
import "forge-std/Test.sol";
import {MockERC20} from "../contracts/Mock/MockERC20.sol";

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

        //address(1).transfer(79228162514264337593543950000);

        address alice = vm.addr(0x1);
        console2.log("Alice balance: %d", alice.balance);
        console2.log("Alice: %s",alice);
     }
}