//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import "node_modules/@openzeppelin/contracts/interfaces/IERC20.sol";


//Factory interface 
contract Factory
{
    function getExchange(address token) public returns(address){}
}

contract Exchange 
{
    //@dev Factory interface's object
    Factory public factory; 

    //@dev ERC20 token that's being traded on the exchange 
    IERC20 public s_token;

    //@dev Total number of 'UNI' equivalent in existence
    uint public s_totalSupply; 
    
    mapping(address => uint) public s_balances;

    constructor(address token)
    {
        s_token = IERC20(token); 
        
        factory = msg.sender; 
    }

    //@dev Emitted when liquidity is added 
    event LiquidityAdded(
        uint indexed liquidityMinted,
        uint indexed balanceOfUser,
        uint indexed totalPoolLiquidity
    );

    //@dev Emitted when liquidity is removed 
    event LiquidityRemoved(
        uint indexed EthersAmount,
        uint indexed TokenAmount
    );

    //@dev Emitted when tokens are purchased
    event TokensPurchased(
        address buyer,
        uint eth_sold,
        uint tokens_bought
    );

    //@dev Emitted when ETH are purchased
    event EthPurchased(
        address buyer,
        uint tokens_sold,
        uint eth_bought
    );

    //@dev Emitted when Tokens are swapped
    event TokensSwapped(
        address buyer,
        uint sellingTokens,
        uint purchasingTokens
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

    function getInputPrice(uint input_amount, uint input_reserve, uint output_reserve) internal returns(uint)
    {
        require(input_reserve > 0 && output_reserve > 0);

        uint input_amount_with_fee = input_amount * 997;

        uint numerator = input_amount_with_fee * output_reserve;

        uint denominator = (input_reserve * 1000) + input_amount_with_fee;

        return numerator / denominator; 
    }

    function ethToToken(uint min_tokens, address receiver) public payable returns(uint)
    {
        uint eth_sold = msg.value; 
        
        require(eth_sold > 0 && min_tokens > 0);

        uint token_reserve = s_token.balanceOf(address(this));

        uint tokens_bought = getInputPrice(eth_sold, address(this).balance - eth_sold, token_reserve);

        require(tokens_bought >= min_tokens);

        require(s_token.transfer(receiver, tokens_bought));

        emit TokensPurchased(receiver, eth_sold, tokens_bought);

        return tokens_bought; 
    }

    function tokenToEth(uint tokens_sold, uint min_eth) public returns(uint)
    {
        require(tokens_sold > 0 && min_eth > 0);

        uint token_reserve = s_token.balanceOf(address(this));

        uint eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);

        require(eth_bought > min_eth);

        msg.sender.transfer(eth_bought);

        require(s_token.transferFrom(msg.sender, address(this), tokens_sold));

        EthPurchased(msg.sender, tokens_sold, eth_bought);

        return eth_bought; 
    }

    function tokenToToken(uint tokens_sold, uint min_tokens_bought, address token) public returns(uint)
    {
        address exchange_address = factory.getExchange(token);

        require(tokens_sold > 0 && min_tokens_bought > 0);

        require(exchange_address != address(this) && exchange_address != address(0));

        uint token_reserve = s_token.balanceOf(address(this));

        uint eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);

        require(s_token.transferFrom(msg.sender, address(this), tokens_sold));

        uint tokens_bought = Exchange(exchange_address).ethToToken{value: eth_bought}(min_tokens_bought, msg.sender);

        emit TokensSwapped(msg.sender, tokens_sold, tokens_bought);

        return tokens_bought; 
    }
}