

## Quick start

The first things you need to do are cloning this repository and installing its
dependencies:

```sh
git clone https://github.com/edna-harriet/Teqtober-auction.git
cd Teqtober-auction
npm install --save-dev hardhat
npm install


Once installed, let's run Hardhat's testing network:

```sh
npx hardhat node
```

Then, on a new terminal, go to the repository's root folder and run this to
deploy your contract:

```sh
npx hardhat run scripts/deploy.js --network localhost
```

Finally, we can run the frontend with:

```sh
cd frontend
npm install
npm start
```

Open [http://localhost:3000/](http://localhost:3000/) to see your Dapp. You will
need to have [Metamask](https://metamask.io) installed and listening to
`localhost 8545`.

