// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;



contract CollectiblesContract {
    string public name;
    string public symbol;

    address owner;

    uint collectiblesCount;

    mapping( uint => address ) collectibleOwners;
    
    mapping( uint => bytes ) collectibleMetadatas;
    
    mapping( address => uint ) addressCollectiblesCounter;


    constructor( string memory _name, string memory _symbol ) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }


    function mint( string memory collectibleUri ) public {
        // ensure its not by address 0x0
        require( msg.sender != address(0), "Cant mint");

        collectiblesCount++;

        // add collectible & its owner
        collectibleOwners[collectiblesCount] = msg.sender;

        // add collectible metadata
        collectibleMetadatas[collectiblesCount] = bytes(collectibleUri);

        // add user collectibles
        addressCollectiblesCounter[msg.sender]++;
    }


    // return address that owns a collectible
    function ownerOf(uint collectible) public view returns(address) {
        // ensure collectible exists
        require(collectible > 0 && collectible < (collectiblesCount+1), "Not Existent");

        return collectibleOwners[collectible];        
    }


    // return how many collectibles an address has
    function balanceOf(address _owner) public view returns(uint) {
        return addressCollectiblesCounter[_owner];
    }


    // transfer collectible to another address
    function transfer(address _to, uint _collectible) public {
        // ensure caller is not 0 address
        require( msg.sender != address(0) , "Cant transfer" );

        // ensure sender owns collectible
        address _owner = collectibleOwners[_collectible];
        require( _owner == msg.sender , "You must be owner of collectible" );

        // transfer collectible
        collectibleOwners[_collectible] = _to;
        // add the new owners collectible count
        addressCollectiblesCounter[_to]++;

        // decrement previous owners collectibles cause they just transferred one of their own
        addressCollectiblesCounter[msg.sender]--;
    }

}