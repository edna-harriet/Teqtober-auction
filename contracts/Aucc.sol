//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract Generator {
    address public ownerGenerator;
    Aucc[] public deployedAucc;

    constructor(){
        ownerGenerator = msg.sender;
    }

    function deployAucc() public{
        Aucc new_Aucc_Address = new Aucc();
        deployedAucc.push(new_Aucc_Address);
    }

}

contract Aucc{
    address payable public owner;
    //its not safe to use block.timestamp as a timer since the miner can spoof in to the block timestamp.
    uint public startBlock;
    uint public endBlock;
    uint public MinimumBidValue;
    string public ipfsHash;

    enum State{
        Started,
        Running, 
        Ended,
        Canceled
    }
    State public auctionState;

    uint public highestBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;
    uint bidIncrement;

    //when initiating contract, it will be in ENDED state
    constructor(){
        address _contractOwner;
        owner = payable(_contractOwner);
        auctionState = State.Started;
    }

    function isOwner(address _address) internal view returns(bool){
        return _address == owner;
    }

    //can only start new bid when the old one are already Ended
    //assuming we want to run the auction once per day
    //the it'll be (60s * 60m *24h)/15s = 5,760 blocks. 1 block in ethereum are generated per 15s
    function startNewBid(uint blocksCreated, uint BidIncrementWei, uint _MinimumBidValue) public onlyOwner isStarted{
        startBlock = block.number;
        endBlock = startBlock + blocksCreated;
        auctionState = State.Running;
        ipfsHash = "";
        bidIncrement = BidIncrementWei;
        MinimumBidValue = _MinimumBidValue;
    }

    function min(uint a, uint b) internal pure returns(uint){
        if(b<=a){
            return b;
        }else {
            return a;
        }
    }

    function cancelAuction() public onlyOwner {
        auctionState = State.Canceled;

    }

    //msg.value is the maximum amount the user willing to pay
    function placeBid() public payable notOwnerOrBeneficiary afterStart beforeEnd{
        require(auctionState == State.Running, "The auction will start shortly");
        require(msg.value >= MinimumBidValue);

        uint currentBid = bids[msg.sender] + msg.value;

        require(currentBid >= highestBid);

        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }else{
            highestBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    function finalizeAuction() public{
        require(auctionState == State.Canceled || block.number >= endBlock);
        require(isOwner(msg.sender) || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if(auctionState == State.Canceled){ //auction nullified
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }else{ //run when the auction stopped
            if(isOwner(msg.sender)){
                recipient = payable(owner);
                value = highestBid;
            }else{ //a bidder
                if(msg.sender == highestBidder){ //when highest bidder 
                    recipient = payable(highestBidder);
                    value = bids[msg.sender] - highestBid;
                }else{ //when not highest bidder
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }

        bids[recipient] = 0;
        recipient.transfer(value);
    }

    modifier afterStart(){
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock);
        _;
    }

    //so that owner wont raise the bid artificially
    modifier notOwnerOrBeneficiary(){
        require(msg.sender != owner);
        _;
    }

    modifier isStarted(){
        require (auctionState == State.Started);
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier isRunning(){
        require( auctionState == State.Running);
        _;
    }
}


