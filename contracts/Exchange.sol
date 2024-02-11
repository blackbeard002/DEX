//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import "node_modules/@openzeppelin/contracts/interfaces/IERC20.sol";

contract Exchange 
{
    //@dev ERC20 token that's being traded on the exchange 
    IERC20 public s_token;

    //@dev Total number of 'UNI' equivalent in existence
    uint public s_totalSupply; 
    
    mapping(address => uint) public s_balances;

    constructor(address token)
    {
        s_token = IERC20(token); 
    }

    event LiquidityAdded(
        uint indexed liquidityMinted,
        uint indexed balanceOfUser,
        uint indexed totalPoolLiquidity
    );

    event LiquidityRemoved(
        uint indexed EthersAmount,
        uint indexed TokenAmount
    );
 
    function addLiquidity(uint min_liquidity,uint max_tokens) public payable returns(uint)
    {
        uint total_liquidity = s_totalSupply; 

        if(total_liquidity > 0)
        {
            require(min_liquidity > 0); 

            uint eth_reserve = address(this).balance - msg.value;
            uint token_reserve = s_token.balanceOf(address(this));

            uint token_amount = msg.value * token_reserve / eth_reserve + 1; 
            uint liquidity_minted = msg.value * total_liquidity / eth_reserve; 

            require(max_tokens >= token_amount && liquidity_minted >= min_liquidity,"Bug:1");

            s_balances[msg.sender] += liquidity_minted;

            s_totalSupply = total_liquidity + liquidity_minted; 

            require(s_token.transferFrom(msg.sender, address(this), token_amount));

            emit LiquidityAdded(liquidity_minted,s_balances[msg.sender], s_totalSupply);

            return liquidity_minted;
        }
        else
        {
            uint token_amount = max_tokens; 
            uint initial_liquidity = address(this).balance; 

            s_totalSupply = initial_liquidity;
            s_balances[msg.sender] = initial_liquidity; 

            require(s_token.transferFrom(msg.sender, address(this), token_amount));

            emit LiquidityAdded(initial_liquidity,s_balances[msg.sender], s_totalSupply);

            return initial_liquidity; 
        }
    }

    function removeLiquidity(uint amount, uint min_eth, uint min_tokens) public returns(uint,uint)
    {
        require(amount > 0 && min_eth > 0 && min_tokens >0);

        uint total_liquidity = s_totalSupply;
        require(total_liquidity > 0);

        uint token_reserve = s_token.balanceOf(address(this));

        uint eth_amount = amount * address(this).balance / total_liquidity; 

        uint token_amount = amount * token_reserve / total_liquidity; 

        require(eth_amount >= min_eth && token_amount >= min_tokens);

        s_balances[msg.sender] -= amount; 
        s_totalSupply = total_liquidity - amount;

        payable(msg.sender).transfer(eth_amount); 
        require(s_token.transfer(msg.sender, token_amount));

        emit LiquidityRemoved(eth_amount, token_amount);

        return(eth_amount, token_amount);
    }

    function getInputPrice(uint input_amount, uint input_reserve, uint output_reserve) 
    internal returns(uint)
    {
        
    }

    function ethToERC20(uint min_tokens) public payable returns(uint)
    {
        uint eth_sold = msg.value; 
        
        require(eth_sold > 0 && min_tokens >0);

        uint token_reserve = s_token.balanceOf(address(this));

        uint tokens_bought = getInputPrice(eth_sold, address(this).balance - eth_sold, token_reserve);

        require(tokens_bought >= min_tokens);

        require(s_token.transfer(msg.sender, tokens_bought));

        //emit

        return tokens_bought; 
    }
}