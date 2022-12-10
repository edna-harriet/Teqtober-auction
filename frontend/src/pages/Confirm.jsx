import React from "react";
import { BiderAbi } from "../../abi/bidercontract_abi";
import Web3Modal from "web3modal";
import { useRef, useEffect, useState } from "react";
import { providers, Contract } from "ethers";
import DisplayBids from "./displayBids";

function Confirm() {
  const [walletconnect, setWalletConnect] = useState(false);
  const [BidTenders, setBidTenders] = useState([]);
  const [index, setIndex] = useState();
  const ContractBiderAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
  const Web3ModalRef = useRef();
  

  const getProviderOrSigner = async (needSigner = false) => {
    const provider = await Web3ModalRef.current.connect();
    const web3Provider = new providers.Web3Provider(provider);
    
    // check if network is goerli
    const { chainId } = await web3Provider.getNetwork();
    if (chainId !== 5) {
      window.alert("Change network to goerli");
      throw new Error("Change network To goerli");
    }

    if (needSigner) {
      const signer = web3Provider.getSigner();
      return signer;
    }
    return web3Provider;
  };

  //getallbids tenders
  const getAllBids = async () => {
    let _bidTenders = [];
    const provider = await getProviderOrSigner();
    const BidersContract = new Contract(
      ContractBiderAddress,
      BiderAbi,
      provider
    );
   
    const allbids = await Promise.all(_bidTenders);
    setBidTenders(allbids);
  };
  //Approve function
  const confirmTender = async (ids) => {
    const signer = await getProviderOrSigner(true);

    const BiderContract = new Contract(ContractBiderAddress, BiderAbi, signer);
    const confirms = await BiderContract.confirmTender(ids);
   
  };

  useEffect(() => {
    Web3ModalRef.current = new Web3Modal({
      network: "goerli",
      providerOptions: {},
      disableInjectedProvider: false,
      cacheProvider: false,
    });
    getAllBids();
  }, [walletconnect]);

  return (
    <div>
      <main>
        <NavbarHome />
        <DisplayBids bids={BidTenders} confirm={confirmTender} />
      </main>
    </div>
  );
}

export default Confirm;
