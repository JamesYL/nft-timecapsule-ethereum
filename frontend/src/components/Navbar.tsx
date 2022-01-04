import { AppBar, Toolbar, Typography, Link, Button } from "@mui/material";
import { useEthers } from "@usedapp/core";

export default function Navbar() {
  const { activateBrowserWallet } = useEthers();
  return (
    <AppBar position="static" elevation={1} style={{ display: "flex" }}>
      <Toolbar>
        <Typography variant="h6" style={{ flexGrow: 1 }}>
          <Link
            href="/"
            color="inherit"
            variant="inherit"
            style={{ textDecoration: "none" }}
          >
            Time Capsule NFT
          </Link>
        </Typography>
        <Button
          onClick={() => activateBrowserWallet()}
          variant="outlined"
          style={{ color: "white", borderColor: "white" }}
        >
          Connect Wallet
        </Button>
      </Toolbar>
    </AppBar>
  );
}
