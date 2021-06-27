pragma solidity >=0.5.0 <0.7.0;


contract multisig{
    address payable [] owner;
    mapping (address => bool) isOwner;
    mapping (uint => mapping(address => bool)) public voted;
    transaction[] transactionlist;
    uint[] confirmedCount;

    uint needToConfirm;
    
    struct transaction{
        address payable to;
        uint value;
        bool exe; 
    }
    
    modifier onlyOwner{
        require(isOwner[msg.sender]==true);
        _;
    }
    
    constructor(address[] memory owners, uint _needToConfirm) public {
        for(uint i=0; i<owners.length; i++){
            isOwner[owners[i]]==true;
        }
        needToConfirm= _needToConfirm;
    }
    
    function addTransaction(address payable _to, uint _value) onlyOwner public {
        transactionlist.push(transaction(_to, _value, false));
    }
    
    function confirmTransaction (uint _transactionId)onlyOwner public {
        require(voted[_transactionId][msg.sender]== false);
        voted[_transactionId][msg.sender]=true;
        confirmedCount[_transactionId]+=1;
        
    }
    
    function exeTransaction(uint _transactionId)public{
        require(transactionlist[_transactionId].exe == false);
        require(confirmedCount[_transactionId] >= needToConfirm);
        transactionlist[_transactionId].exe = true;
        transactionlist[_transactionId].to.transfer(transactionlist[_transactionId].value);
    }
    
    function revokeConfirm(uint _transactionId) onlyOwner public{
        require(voted[_transactionId][msg.sender]== true);
        voted[_transactionId][msg.sender]=false;
        confirmedCount[_transactionId]-=1;
    }
}