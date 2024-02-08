const {ethers} = require("hardhat");
const {expect}= require("chai");

describe("Exchange",()=>{
    let exchange;
    let mockERC20; 
    let accounts; 

    beforeEach(async ()=>{
        accounts = await ethers.getSigners();
        const Exchange = await ethers.getContractFactory("Exchange");
        //exchange = await Exchange.deploy(); 
        const MockERC20 = await ethers.getContractFactory("MockERC20");
        mockERC20 = await MockERC20.deploy(); 
    });

    context("Add Liquidity", ()=>{

        it("should mint ERC20 mock tokens",async()=>{
            await expect(await mockERC20.connect(accounts[1]).mintTokens(100000,accounts[1].address)).to
            .emit(mockERC20,"minted").withArgs(accounts[1]);

            console.log("Balance:"+await mockERC20.balanceOf(accounts[1]));
        });
    });
});