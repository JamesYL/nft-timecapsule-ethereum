import json
from web3 import Web3

from solcx import compile_standard, install_solc
from dotenv import load_dotenv
import os

load_dotenv()

contractName = "Capsule"
w3 = Web3(Web3.HTTPProvider(os.getenv("PROVIDER")))
chain_id = int(os.getenv("CHAIN_ID"))
address = os.getenv("ADDRESS")
private_key = os.getenv("PRIVATE_KEY")
solc_version = os.getenv("SOLC_VERSION")

contract_file = f"{contractName}.sol"
with open(f"./{contract_file}") as file:
    contract_file_content = file.read()

install_solc(solc_version)
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {f"{contract_file}": {"content": contract_file_content}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version=solc_version,
)

bytecode = compiled_sol["contracts"][contract_file][contractName]["evm"]["bytecode"][
    "object"
]

abi = json.loads(compiled_sol["contracts"][contract_file][contractName]["metadata"])[
    "output"
]["abi"]

SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
nonce = w3.eth.getTransactionCount(address)
transaction = SimpleStorage.constructor().buildTransaction(
    {"chainId": chain_id, "gasPrice": w3.eth.gas_price, "from": address, "nonce": nonce}
)

signed_tx = w3.eth.account.sign_transaction(transaction, private_key=private_key)
tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

with open("./src/config.json", "w") as f:
    json.dump({"contractAddress": tx_receipt.contractAddress, "abi": abi}, f)
