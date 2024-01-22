import { ethers } from "ethers";
import {abi} from "./contract/LimaKijanja.json"

//CONTRACT AND WALLET RELATED
const contractAddress = "0xc3e53F4d16Ae77Db1c982e75a937B9f60FE63690"

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



