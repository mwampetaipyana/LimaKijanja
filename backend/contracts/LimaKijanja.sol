// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9; 

contract LimaKijanja {

    address public i_owner;

    struct User {
        string name;
        string email;
        string phoneNumber;
        string location;
        address payable walletAddress;
    }  

    struct LoginInfo{
        address userAddress;
        string userType;
    }

    struct Product {
        string productName;
        string productDescription;
        uint256 kilograms;
        uint256 price;
        address payable owner;
        string tag;
    }

    struct Price {
        string productName;
        uint256 min_Price;
        uint256 max_Price;
    }

    struct TransactionRecord {
        string action;
        string details;
        uint256 timestamp;
    }

    Price[] public productPricesArray;
    Product[] public productrArray;
    User[] public userArray;
    TransactionRecord[] public transactionRecords;


    mapping (string => Price) public productPricemapping;
    mapping (address => Product) public Productsmapping;
    mapping (address => TransactionRecord[]) public userTransactionsmapping;
    mapping (address => LoginInfo) loginmapping;
    mapping (address => User) userInfoMapping;

    event TransactionEvent(address indexed user, string action, string details);

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Only the owner can call this function");
        _;
    }

    modifier onlyUSer() {

         bool isOwner = false;

        for (uint256 i = 0; i < userArray.length; i++) {
            if (userArray[i].walletAddress == msg.sender) {
            isOwner = true;
            break;
            }
        }

        require(isOwner, "Only the user can call this function");
        _;
    }

    constructor(){
        i_owner = msg.sender;
        loginmapping[i_owner].userType= "admin";
    }

    function postProduct(
        string memory _productName,
        string memory _productDescription,
        uint256 _kilograms,
        uint256 _price,
        string memory _tag
    ) public  onlyUSer{
        Price memory prodPrice = productPricemapping[_productName];
        require(_price >= prodPrice.min_Price && _price <= prodPrice.max_Price, 
        "Price not within the specified range or The Product does not Exist");
        
        Product memory myproduct =  Product({
            productName: _productName,
            productDescription: _productDescription,
            kilograms: _kilograms,
            price: _price,
            owner: payable(msg.sender),
            tag: _tag
        });
        productrArray.push(myproduct);
        Productsmapping[msg.sender] = myproduct;

        recordTransaction(msg.sender, "Post Product", _productName);
    }

    function viewProducts() public view returns (Product[] memory) {
        return productrArray;
    }

    function register(
        string memory _name,
        string memory _email,
        string memory _phoneNumber,
        string memory _location,
        address payable _walletAddress
    ) public onlyOwner{
        User memory newUser  = User({
            name : _name,
            email : _email,
            phoneNumber : _phoneNumber,
            location : _location,
            walletAddress : _walletAddress
        });
        userArray.push(newUser);
        userInfoMapping[_walletAddress] = newUser;
        loginmapping[_walletAddress].userType = "user";
        recordTransaction(msg.sender, "Add User", _name);
    }

    function getUserInfo(address _userAddress) public view returns ( User memory){
            return userInfoMapping[_userAddress];
        }



    function setPrice (
        uint256 _minPrice,
        uint256 _maxPrice,
        string memory _productName
    ) public onlyOwner {
        Price storage prodPrice = productPricemapping[_productName];

        if (prodPrice.min_Price == 0 && prodPrice.max_Price == 0) {
        // The product doesn't have a price, so create a new entry
        productPricemapping[_productName] = Price({
            productName: _productName,
            min_Price: _minPrice,
            max_Price: _maxPrice
        });
        } else {
        // Update the existing entry
        prodPrice.min_Price = _minPrice;
        prodPrice.max_Price = _maxPrice;
        }

    recordTransaction(msg.sender, "Set Price", _productName);
    }


    function buyProduct(
    address payable  _owner,
    uint256 _kilograms
    ) public  payable onlyUSer{

    require(_kilograms <= Productsmapping[_owner].kilograms, "Invalid amount to buy");
    require(_owner != address(0), "Invalid recipient address");

    // Deduct the amount to be bought from the original amount uploaded by the owner
    Productsmapping[_owner].kilograms -= _kilograms;

    // Update the product array with the remaining amount
    for (uint256 i = 0; i < productrArray.length; i++) {
        if (productrArray[i].owner == _owner) {
            productrArray[i].kilograms = Productsmapping[_owner].kilograms;
        }
    }

    // Calculate the total cost for buying the product
    uint256 totalPrice = _kilograms * Productsmapping[_owner].price;
    //returnTotalPrice(totalPrice);
    //return totalPrice;

    require(totalPrice >= _kilograms * Productsmapping[_owner].price, "Insufficient funds");
    // Transfer the total price from the buyer's address to the owner's address
    _owner.transfer(totalPrice);

    // Record the transaction
    recordTransaction(msg.sender, "Buy Product", Productsmapping[_owner].productName);
    }

function returnTotalPrice(address _owner, uint256 _kilograms) public view returns (uint256) {
    // require(_kilograms <= Productsmapping[_owner].kilograms, "Invalid amount to buy");
    // require(_owner != address(0), "Invalid recipient address");

    uint256 totalPrice = _kilograms * Productsmapping[_owner].price;
    return totalPrice;
}


    function recordTransaction(
        address _user,
        string memory _action,
        string memory _details
    ) internal {
        TransactionRecord memory transaction = TransactionRecord({
            action: _action,
            details: _details,
            timestamp: block.timestamp
        });

        transactionRecords.push(transaction);
        userTransactionsmapping[_user].push(transaction);
        emit TransactionEvent(_user, _action, _details);
    }

    function getTransactionsForUser() public view returns (TransactionRecord[] memory) {
        return userTransactionsmapping[msg.sender];
    }

    function getTransactionRecords() public view returns (TransactionRecord[] memory) {
        return transactionRecords;
    }

    function getAllUsers() public view returns(User[] memory) {
        return userArray;
    }

    function getPricePerProduct(string memory _product) public view returns (Price memory) {
    return productPricemapping[_product];
}

      function Login(address _userAddress) public view returns (string memory) {
            return loginmapping[_userAddress].userType;
        }

    function logout() external {
        
    }
} 