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
        });

        it("should add liquidity",async ()=>{
            
        });
    });
});

