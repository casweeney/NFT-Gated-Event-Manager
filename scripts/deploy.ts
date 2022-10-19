import { ethers } from "hardhat";

async function main() {
  const [owner, other] = await ethers.getSigners();

  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();
  await nft.deployed();
  console.log(`NFT deployed to ${nft.address}`);

  console.log("-----------------  Minting NFT to second address  --------------------");
  const mintNFTTx = await nft.safeMint(other.address);
  console.log("NFT Minted");


  console.log("-----------------  Deploying Event Contract  --------------------");

  const EventManager = await ethers.getContractFactory("EventManager");
  const eventManager = await EventManager.deploy();
  await eventManager.deployed();

  console.log(`Event Manager deployed to ${eventManager.address}`);

  console.log("-----------------  Creating Event  --------------------");
  const createEventTx = await eventManager.createEvent("Mara Event", "23 October 2022", "16:00", "Lekki Lagos", nft.address);
  console.log("Event Created");

  console.log("-----------------  Registering for Event  --------------------");
  const registerForEventTx = eventManager.connect(other).registerForEvent(1);
  const regEventReceipt = await (await registerForEventTx).wait()

  console.log(regEventReceipt);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
