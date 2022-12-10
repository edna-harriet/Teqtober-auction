const {ethers} = require("hardhat")

async function main(){
    
    const AuccContract  = await ethers.getContractFactory("Bider");

    const AuccContractDeploy = await AuccContract.deploy();
    
    await AuccContractDeploy.deployed();
    
     //call contract tokens
     const TokenContract  = await ethers.getContractFactory("AuccToken");

    //Deploy Token
    const TokenContractDeploy = await TokenContract.deploy(AuccContractDeploy.address);
    //await Token Contract
    await TokenContractDeploy.deployed();
    //Console both Address
    console.log("AuccAddress:",AuccContractDeploy.address);
    console.log("TokenAddress:",TokenContractDeploy.address);
    
    //AuccAddress: 0x5fbdb2315678afecb367f032d93f642f64180aa3
 
    
    
}
//main
main(()=>process.exit(0)).
catch((error)=>{
    console.error(error);
    process.exit(1);
})