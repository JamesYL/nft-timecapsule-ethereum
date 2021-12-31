import Web3 from "web3";
import config from "./config.json";
const { contractAddress, abi } = config;

const loadBlockchain = async () => {
  const web3 = new Web3(process.env.PROVIDER as string);
  const accounts = await web3.eth.getAccounts();
  const contract = new web3.eth.Contract(abi as any, contractAddress);

  return { accounts, contract };
};
