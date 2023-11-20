describe("Factory",()=>{

  let factory;
  let accounts;
  beforeEach(async ()=>{
    accounts=await ethers.getSigners();
    const Factory=await ethers.getContractFactory("Factory");
    factory=await Factory.deploy();
  });

  describe("createExchange",()=>{
    it("Check the address of Exchange",async()=>{
      const token="0x74E2cb43e21aC8Fbcc0b5c3eae95aF95bfADB4e3"; 
      const exchange=await factory.createExchange(token);
      console.log(exchange);
    });
  });

});