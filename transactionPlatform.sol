// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract transaction1 {
    
    uint public value;
    address payable public owner;
    enum State { Created, Ordered, Received, Closed }


    //A product to be put online
    struct productToSell{
        address payable seller;
        address payable buyer;
        uint cancelUntil;
        State transactionState;
        uint value;
    }
    
    //All products are saved in a mapping
    mapping(string => productToSell) public products;
    
    //Owner starts this contract
    constructor() public payable {
        owner = msg.sender;
    }
    
    //1.Seller upload his product
    function uploadSell(string memory productName)public payable{
       
        /*address payable public seller;
        address payable public buyer;
        uint cancelUntil;
        State public transactionState;
        uint public value;*/
        value = msg.value / 2;
        require((2 * value) == msg.value, "Value has to be even.");
        
        productToSell memory myProduct=productToSell(msg.sender, owner, now , State.Created, value);
        products[productName]=myProduct;
    } 
    
    //2.buyer purchase
    function buy(string memory productName) public payable{
        productToSell storage myProduct=products[productName];
        require(msg.value==2*myProduct.value, "Not right fund");
        require(myProduct.transactionState==State.Created, 
        "Product is not currently open to purchase");
        
        
        myProduct.transactionState=State.Ordered;
        myProduct.buyer=msg.sender;
        myProduct.cancelUntil=now+ 1 minutes;
    }
    
    //3.seller send the product
    //4.buyer confirmReceived
    function confirmReceived (string memory productName)  public payable{
        productToSell storage myProduct=products[productName];
        require(myProduct.buyer==msg.sender, "Only buyer can confirmReceived");
        require(myProduct.transactionState==State.Ordered, 
        "You haven't ordered the product");
        
        myProduct.transactionState=State.Received;
        myProduct.buyer.transfer(myProduct.value);
        
    }
    
    //5.seller close the transaction
    function cloesTransaction (string memory productName)  public payable{
        productToSell storage myProduct=products[productName];
        require(myProduct.seller==msg.sender, "Only seller can end transaction");
        myProduct.seller.transfer(myProduct.value*3);
    }
    
    //The seller can end the transaction before someone buy it
    function abort(string memory productName) public payable{
        productToSell storage myProduct=products[productName];
        require(myProduct.seller==msg.sender, "Only seller can end abort");
        myProduct.transactionState=State.Created;
        myProduct.seller.transfer(value*2);
    }
    
    //The buyer decides to cancel the purchase 
    function buyerChangeMind(string memory productName)  public payable{
        productToSell storage myProduct=products[productName];
        require(now<=myProduct.cancelUntil, "Cancel period passed");
        myProduct.transactionState=State.Created;
        myProduct.buyer.transfer(value*2);
    }
}
