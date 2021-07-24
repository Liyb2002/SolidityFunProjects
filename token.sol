pragma solidity 0.6.10;

import './ERC20.sol';

contract techX is ERC20 {

    string public constant name = "techX";
    uint8 public constant decimals = 18;
    string public constant symbol = "techX";
    uint public constant supply = 1 * 10**8 * 10**uint(decimals); // 100 million

    /**
     * @dev ERC20 token to mock techX, send all balance to the deployer
     */
    constructor() public {
        _balances[msg.sender] = supply;
        _totalSupply = supply;
    }
    
}