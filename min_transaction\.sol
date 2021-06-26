pragma solidity >=0.5.0 <0.7.0;

contract transaction1 {
    struct Object{
        address payable owner;
        uint256 price;
        uint256 id;
        bool available;
    }
address public deployer;
Object [] ObjectList;
uint256 id=1;



constructor() public {
    deployer = msg.sender;
    
}

function createObject(uint256 price)public {
    id++;
    ObjectList.push(Object(msg.sender, price, id, true));
}

function buyObject(uint256 thisId)public payable{
    require(msg.value==ObjectList[thisId].price);
    ObjectList[thisId].available=false;
    ObjectList[thisId].owner.transfer(msg.value);
}

function showPrice(uint256 thisId)public view returns(uint256){
    return (ObjectList[thisId].price);
}

}