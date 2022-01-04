import { useEtherBalance, useEthers } from "@usedapp/core";
import { formatEther } from "@ethersproject/units";
import { CssBaseline } from "@mui/material";
import Navbar from "./components/Navbar";
function App() {
  const { account } = useEthers();
  const etherBalance = useEtherBalance(account);
  return (
    <div>
      <CssBaseline />
      <Navbar />
      {account && <p>Account: {account}</p>}
      {etherBalance && <p>Balance: {formatEther(etherBalance)}</p>}
    </div>
  );
}

export default App;
