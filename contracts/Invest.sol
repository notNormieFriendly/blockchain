pragma solidity ^0.4.23;

contract ERC20Interface {
function totalSupply() public constant returns (uint);

function balanceOf(address tokenOwner) public constant returns (uint balance);

function allowance(address tokenOwner, address spender) public constant returns (uint remaining);

function transfer(address to, uint tokens) public returns (bool success);

function approve(address spender, uint tokens) public returns (bool success);

function transferFrom(address from, address to, uint tokens) public returns (bool success);

event Transfer(address indexed from, address indexed to, uint tokens);
event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Identity{

    /*
    *   Storage
    */
    address public owner;
    uint public contractBalance;
    Profile[] public profileArray;
    uint public totalUsers = 0;
    bool private reentrancy_lock = false;

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
    
    function transact(address token)
    payable
    nonReentrant
    external 
    {
        //make a search index function that returns index.
        for(uint i = 0; i <= profileArray.length; i++){
            if(profileArray[i].userAddress == msg.sender){
                ercTokenBalances(token);
                if(profileArray[i].userBalance + msg.value >= 1000000000000000000){
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
                    profileArray[i].userBalance += msg.value; //difference;
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
    function ercTokenBalances(address token) internal returns(uint){
        //For ERC20 tokens
         //ERC20 token = ERC20();
        uint _newBalance = ERC20Interface(token).balanceOf(msg.sender);
        uint _difference = _newBalance - contractBalance;
        contractBalance += _difference;
        return _difference;
    }

}



