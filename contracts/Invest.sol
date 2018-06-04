pragma solidity ^0.4.23;

import "./ERC20.sol";

contract Invest{

    /*
    *   Storage
    */
    ERC20 myToken;
    address public owner;
    uint public contractBalance;
    uint public contractTokenBalance;
    Profile[] public profileArray;
    uint public totalUsers = 0;
    bool private reentrancy_lock = false;
    address public tokenContractAddress = 0xe500E70daEbAF0e6CD5a90af221473B132C4e881;

    // enum AgreementStatus {
    //     Pending,
    //     Closed
    // }
    
    struct Profile {
        address userAddress;
        uint userBalance;
        uint userEtherPaidOut;
    }
    
    /*
    * Constructor
    */
    constructor()
    public
    payable{
        owner = msg.sender;
        contractBalance = msg.value;
    }
    /*
    *   Events
    */
    event profileDetailStrings(
        address indexed userAddress, 
        uint userBalance, 
        uint userEtherPaidOut
    );
    event contractTokenBalanceEvent(
        address indexed contractAddress, 
        uint oldContractTokenBalance, 
        uint newContractTokenBalance,
        uint difference
    );
    /*
    * Modifiers
    */
    modifier isOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier nonReentrant() {
        require(!reentrancy_lock);
        reentrancy_lock = true;
        _;
        reentrancy_lock = false;
    }
    
    /*
    *   Functions
    */
    
    function createProfile() 
     
        external 
        nonReentrant
        payable
        {
        
        Profile memory profile;
        profile.userAddress = msg.sender; 
        profile.userBalance = msg.value;
        profile.userEtherPaidOut = 0;
        profileArray.push(profile);
        
        emit profileDetailStrings(
            profile.userAddress, 
            profile.userBalance, 
            profile.userEtherPaidOut
            );
        
        //think of something better than possible recursion
        totalUsers += 1;
    }   
    
    function transact()
    payable
    nonReentrant
    external 
    {
        //make a search index function that returns index.
        for(uint i = 0; i <= profileArray.length; i++){
            if(profileArray[i].userAddress == msg.sender){
                uint value = ercTokenBalances();
                if(profileArray[i].userBalance + value >= 100){
                    msg.sender.transfer(1000000000000000000);
                    profileArray[i].userBalance = 0;
                    profileArray[i].userEtherPaidOut += 1000000000000000000;
                    emit profileDetailStrings(
                        msg.sender, 
                        profileArray[i].userBalance, 
                        profileArray[i].userEtherPaidOut
                        );
                    return;
                }
                else{
                    profileArray[i].userBalance += value;
                    emit profileDetailStrings(
                        msg.sender, 
                        profileArray[i].userBalance, 
                        profileArray[i].userEtherPaidOut
                        );
                    return;
                }
            }
        }
        
    }
    function ercTokenBalances() internal returns(uint){
        //For ERC20 tokens
        ERC20 t = ERC20(tokenContractAddress);
        uint _newBalance = t.balanceOf(address(this));
        uint _difference = _newBalance - contractTokenBalance;  
        contractTokenBalance += _difference;
        
        // emit contractTokenBalanceEvent(
        //     owner, 
        //     contractTokenBalance, 
        //     _newBalance, 
        //     _difference);
        return _difference;
    }
    function findBalanceOfUser(address userAddress) public view  returns(uint){
        ERC20 t = ERC20(tokenContractAddress);
        return t.balanceOf(userAddress);
    }
    function transferTokensOut() isOwner external {
        ERC20 t = ERC20(tokenContractAddress);
        t.transfer(owner, contractTokenBalance);
    }
    function transferEtherOut() isOwner external{
        owner.transfer(contractBalance);
    }
}

