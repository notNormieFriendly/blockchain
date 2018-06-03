pragma solidity ^0.4.23;

contract Identity {

    /*
    *   Storage
    */
    address public owner;
    uint public currentBalance;
    Profile[] public profileArray;
    uint public totalUsers = 0;
    bool private reentrancy_lock = false;

    // enum AgreementStatus {
    //     Pending,
    //     Closed
    // }
    
    struct Profile {
        address userAddress;
        string firstName;
        string lastName;
        string password;
        uint8 age;
        uint32 dob;
    }
    
    /*
    * Constructor
    */
    constructor()
    public
    payable{
        owner = msg.sender;
        currentBalance = msg.value;
    }
    /*
    *   Events
    */
    event profileDetailStrings(
        address indexed userAddress, string firstName, string password,
        string lastName, uint8 age, uint32 dob
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
    
    function createProfile(
        address _userAddress, string _firstName, string _password,
        string _lastName, uint8 _age, uint32 _dob
        ) 
     
        external 
        nonReentrant
        payable
        {
        
        Profile memory profile;
        profile.userAddress = msg.sender; 
        profile.firstName = _firstName; 
        profile.lastName = _lastName; 
        profile.password = _password;
        profile.age = _age;
        profile.dob = _dob;
        profileArray.push(profile);
        
        emit profileDetailStrings(_userAddress, _firstName, _lastName, _password, _age, _dob);
        
        //think of something better than possible recursion
        totalUsers += 1;
    }   
    
    
    //Redundant.  automatic getter created from struct array.
    // function retrieveProfile(uint32 _profileIndex)
    // view
    // external
    // returns (address, string, string, uint8, uint32){
        
    //     Profile memory profile = profileArray[_profileIndex];
        
    //     return (
    //         profile.userAddress,
    //         profile.firstName,
    //         profile.lastName,
    //         profile.age,
    //         profile.dob
    //         );
    // }

}



