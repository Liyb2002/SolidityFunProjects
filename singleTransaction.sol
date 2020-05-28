// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract transaction1 {
    
    uint public value;
    address payable public seller;
    address payable public buyer;
    uint cancelUntil;
    enum State { Created, Ordered, Received, Closed }
    State public transactionState;
    
    //1.Seller start a transaction
    constructor() public payable {
        seller = msg.sender;
        value = msg.value / 2;
        require((2 * value) == msg.value, "Value has to be even.");
    }
    
    modifier onlySeller(){
        require(msg.sender==seller, "Only seller can use this function");
        _;
    }
    
    modifier onlyBuyer(){
        require(msg.sender==buyer, "Only buyer can use this function");
        _;
    }
    modifier inState(State curState){
        require(curState==transactionState, "You can't do this");
        _;
    }
    
    //2.buyer purchase
    function buy() public payable{
        require(msg.value==2*value, "Not right fund");
        transactionState=State.Ordered;
        buyer=msg.sender;
        cancelUntil=now+ 1 minutes;
    }
    //3.seller send the product
    //4.buyer confirmReceived
    function confirmReceived () onlyBuyer public payable{
        transactionState=State.Received;
        buyer.transfer(value);
        
    }
    
    //5.seller close the transaction
    function cloesTransaction () onlySeller public payable{
        seller.transfer(value*3);
    }
    
    //The seller can end the transaction before someone buy it
    function abort()onlySeller inState(State.Created) public payable{
        transactionState=State.Created;
        seller.transfer(value*2);
    }
    
    //The buyer decides to cancel the purchase 
    function buyerChangeMind() onlyBuyer inState(State.Ordered) public payable{
        require(now<=cancelUntil, "Cancel period passed");
        transactionState=State.Created;
        buyer.transfer(value*2);
    }