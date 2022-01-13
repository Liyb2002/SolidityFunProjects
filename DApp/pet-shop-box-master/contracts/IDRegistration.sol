pragma solidity >=0.5.0 <0.7.0;


contract IDRegistration{
    mapping (string => address) Registrar;
    address owner;


    constructor( ) public{
        owner =msg.sender;
    }
    
    modifier registerRestriction(string memory Personal_ID){
        require(Registrar[Personal_ID]==address(0));
        _;
    }
    
    function register (string memory Personal_ID) registerRestriction(Personal_ID) public {
        Registrar[Personal_ID]=msg.sender;
    }
    
    function viewAddress(string memory Personal_ID) view public returns(address){
        return (Registrar[Personal_ID]);
    }
    

}