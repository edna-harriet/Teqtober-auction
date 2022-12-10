import React from "react";
import { BiderAbi } from "../../abi/bidercontract_abi";
import Web3Modal from "web3modal";
import { useRef, useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { SiBitcoincash } from "react-icons/si";
import { useNavigate } from "react-router-dom";

import { providers, Contract } from "ethers";
import NavbarHome from "../../components/NavbarHome";

const BiderForm = () => {
  const navigate = useNavigate();
  const { state } = useLocation();
  const { id } = state; // Read values passed on state
  const ContractBiderAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
  const Web3ModalRef = useRef();
  const [biderCompanyName, setBiderCompanyName] = useState("");
  const [biderCompanyRegistrationNumber, setBiderCompanyRegistrationNumber] = useState("");
  const [biderContact, setBiderContact] = useState("");
  const [_tenderIndex, settenderIndex] = useState("");
  const [bidertypeOfGoods, setTypeOfGoods] = useState("");

  //provide sgner or provider
  const getProviderOrSigner = async (needSigner = false) => {
    const provider = await Web3ModalRef.current.connect();
    const web3Provider = new providers.Web3Provider(provider);
    // check if network is Hardhat
    const { chainId } = await web3Provider.getNetwork();
    if (chainId !== 5) {
      window.alert("Change network to Goerli");
      throw new Error("Change network To Goerli");
    }
    if (needSigner) {
      const signer = web3Provider.getSigner();
      return signer;
    }
    return web3Provider;
  };

  //call the metamask on page reload
  useEffect(() => {
    Web3ModalRef.current = new Web3Modal({
      network: "Goerli",
      providerOptions: {},
      disableInjectedProvider: false,
      cacheProvider: false,
    });
    getProviderOrSigner();
    settenderIndex(id);
    window.scrollTo({ top: 0, left: 0, behavior: "auto" });
  }, []);
  //btnsubmit to submit the biders tender details
  const btnsubmit = async () => {
    const params = [
      _tenderIndex,
      biderContact,
      bidertypeOfGoods,
    ];

    try {
      const signer = await getProviderOrSigner(true);
      const BiderContract = new Contract(
        ContractBiderAddress,
        BiderAbi,
        signer
      );
      const results = await BiderContract.inputBiderDetails(...params);

      alert("BidSuccessful ");
    } catch (error) {
      alert(error);
    }
  };
  // //Form submit event
  const handleAddTender = (e) => {
    //prevent page refresh
    e.preventDefault();

    
    setBiderContact("");
    setTypeOfGoods("");
  };

  <div class="center">
      <form class="search-container" id="send">
          <button onClick="ConnectWallet()">Connect to fill form</button><br>
            <p id="AccountArea"></p>
          <button onClick="ConnectWallet()">Name</button><br>
            <p id="ContractArea"></p>
      </form>
    </div>
  
};
export default BiderForm;
