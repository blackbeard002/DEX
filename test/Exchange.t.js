const {ethers} = require("hardhat");
const {expect}= require("chai");

describe("Exchange",()=>{
    let exchange;
    let mockERC20; 
    let messi;
    let suarez;
    let neymar; 

    before(async ()=>{
        [messi, suarez, neymar] = await ethers.getSigners();
        const MockERC20 = await ethers.getContractFactory("MockERC20");
        mockERC20 = await MockERC20.deploy(); 
        const Exchange = await ethers.getContractFactory("Exchange");
        exchange = await Exchange.deploy(mockERC20); 

    });

    context("Add Liquidity", ()=>{

        it("should mint ERC20 mock tokens",async()=>{
            await expect(await mockERC20.connect(messi).mintTokens(100000)).to
            .emit(mockERC20,"minted").withArgs(messi);

            await expect(await mockERC20.balanceOf(messi)).to.equal(100000);

            await mockERC20.connect(suarez).mintTokens(100000);
        });

        it("should add liquidity",async ()=>{
            const val = ethers.parseEther("0.1");
            await mockERC20.connect(messi).approve(exchange,25000);
            await expect(await exchange.connect(messi).
            addLiquidity(1,25000,{value:val})).
            to.emit(exchange,"LiquidityAdded").withArgs(val,val,val);

            //another user adds liquidity 
            await mockERC20.connect(suarez).approve(exchange,100000);
            await exchange.connect(suarez).
            addLiquidity(1,100000,{value:ethers.parseEther("0.1")});
        });

        it("should remove liquidity",async()=>{
            // await expect(await exchange.connect(suarez).
            // removeLiquidity(ethers.parseEther("0.05"),1,1)); 
            await exchange.connect(suarez).
            removeLiquidity(ethers.parseEther("0.05"),1,1);
            console.log("contract's token balance:"+await mockERC20.
            balanceOf(exchange));
        });
    });
});

