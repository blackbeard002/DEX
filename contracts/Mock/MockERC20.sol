//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20
{
    event minted(
        address caller
    );
    address public manager; 

    constructor() ERC20("MOCK_TOKENS","MCK")
    {
        manager = msg.sender; 
    }

    function mintTokens(uint amount) public
    {
        _mint(msg.sender, amount);
        emit minted(msg.sender);
    }
}