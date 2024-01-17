import { ethers } from "ethers";
import {abi} from "./contract/LimaKijanja.json"

//CONTRACT AND WALLET RELATED
const contractAddress = "0xdbC43Ba45381e02825b14322cDdd15eC4B3164E6"

export const getProvider = () => {
    return new ethers.providers.Web3Provider(window.ethereum) ;
}

export const getSignerContract = async () => {
    let provider = await getProvider()
    await provider.send('eth_requestAccounts', [])
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    return { signer, contract }
}

export const getViewerContract = async () => {
    const provider = new ethers.providers.JsonRpcProvider('http://127.0.0.1:8545/');
    const contract = new ethers.Contract(contractAddress, abi, provider);
    return {  contract }
}


//STATE RELATED
const defaultState = {
    address: "",
    status:false,
     //holds a signature to ur identity so u can sign transactions
}

const STATE_NAME = "usedState";

export const setState = (state)=>{
    localStorage.setItem(STATE_NAME,JSON.stringify(state))
}

export const getState = ()=>{
    return JSON.parse(localStorage.getItem(STATE_NAME))
}

export const resetState = ()=> {
    localStorage.removeItem(STATE_NAME);
}



