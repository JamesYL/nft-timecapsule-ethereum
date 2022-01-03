import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import { DAppProvider, Config } from "@usedapp/core";

const chainId = 1337;
const provider = "http://127.0.0.1:7545";

const config: Config = {
  readOnlyChainId: chainId,
  readOnlyUrls: {
    [chainId]: provider,
  },
};

ReactDOM.render(
  <React.StrictMode>
    <DAppProvider config={config}>
      <App />
    </DAppProvider>
  </React.StrictMode>,
  document.getElementById("root")
);
