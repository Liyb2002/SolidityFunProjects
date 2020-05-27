// SPDX-License-Identifier: GPL-3.0
/* 
Blind Bid is adapted based on auction
The key idea is that the bider no longer sends a value but sends a messege containing:
1.the hashed value of value+secret word+truthness
2.his value

The value will be revealed when the auction ends


*/
pragma solidity >=0.5.0 <0.7.0;

contract SimpleAuction {
    
    struct Bid{
        bytes32 blindedBid;
        uint deposit;
    }
    //Who will receive the money selling the product
    address payable public owner;
    uint public auctionEndTime;
    uint public biddingEndTime;
    bool alreadyEnded;
    bool alreadyBided;
    mapping(address => uint) pendingReturns;
    address [] Bidders;
    
    mapping(address => Bid []) BidtoBids;
    address public highestBidder;
    uint public highestBid;
    
    constructor(address payable _owner) public {
        owner = _owner;
        //I set it to two minutes
        //Actually can let owner decide
        biddingEndTime=now +1 minutes;
        auctionEndTime = now + 2 minutes;
    }

    modifier onlyBefore(uint _time){require(now<_time);
    _;}

    modifier onlyAfter(uint _time){require(now>_time);
    _;}
    
    function sendBid(bytes32 _blindedBid)public payable onlyBefore(biddingEndTime){ 
        BidtoBids[msg.sender].push(Bid(_blindedBid, msg.value));
    }
    
    function revealBid(uint[] memory _values, bool[] memory _fake, bytes32[] memory _secret)public 
    onlyAfter(biddingEndTime)
        onlyBefore(auctionEndTime)
    {
        uint totalDeposit;
        uint length = BidtoBids[msg.sender].length;
        require(_values.length == length);
        require(_fake.length == length);
        require(_secret.length == length);
        
        for (uint i=0; i<length; i++){
            Bid storage bidToCheck = BidtoBids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) =
                    (_values[i], _fake[i], _secret[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret))) {
                continue;
            }
            totalDeposit+=bidToCheck.deposit;
            if (!fake && totalDeposit>=value){
                totalDeposit-=value;
                _bid2(msg.sender,value);
            }
            msg.sender.transfer(totalDeposit);
        }
    }
    
    function _bid2(address bidder, uint value)private{
        require(now<auctionEndTime, "Bid ended");
        
        //If there's already a bid
        if(alreadyBided){
            //Save the last bid's value into pendingReturns
            pendingReturns[highestBidder]+=highestBid;
            //save last bidder infomation 
            Bidders.push(highestBidder);
            
            highestBidder=bidder;
            highestBid=value;}
        
        //If no one bid before 
        else{
        highestBidder=bidder;
        highestBid=value;
        alreadyBided=true;
        }
    }
    

    
    //If someone lose the bid, they can withDraw what they prviously put
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
    
    //Only owner can end the bid
    function endAutction()public{
        require(msg.sender==owner, "Only owner can end the Bid");
        require(now>=auctionEndTime, "Bid has not ended");
        require(alreadyEnded==false, "Bid has been ended");
        //Check if function called before 
        alreadyEnded=true;
        owner.transfer(highestBid);
        _retreiveAll();
    }
    
    //Take all money that is not withDraw before the bid ends
    function _retreiveAll ()private{
        for (uint i=0; i<Bidders.length; i++){
            if (pendingReturns[Bidders[i]]!=0){
                //Take the money
                 owner.transfer(pendingReturns[Bidders[i]]);
                 pendingReturns[Bidders[i]]=0;
            }
        }
        
    }
    
    //Return howlong until the bid ends
    function timeTillEnd()public view returns (uint currentTime, uint endTime){
        currentTime=now;
        endTime=auctionEndTime;
    }
    
}