// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9; 

contract LimaKijanja {

    address public i_owner;

    struct User {
        string name;
        string email;
        string phoneNumber;
        string location;
        address walletAddress;
    }   

    struct Product {
        string productName;
        string productDescription;
        uint256 kilograms;
        uint256 price;
        address owner;
        string tag;
    }

    struct Price {
        uint256 min_Price;
        uint256 max_Price;
    }

    struct TransactionRecord {
        string action;
        string details;
        uint256 timestamp;
    }

    Price[] public productPrices;
    Product[] public productrArray;
    User[] public userArray;
    TransactionRecord[] public transactionRecords;


    mapping (string => Price) public productPricemapping;
    mapping (address => Product) public Productsmapping;
    mapping (address => TransactionRecord[]) public userTransactionsmapping;

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
        i_owner=msg.sender;
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
            owner: msg.sender,
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
        address _walletAddress
    ) public onlyOwner{
        User memory newUser  = User({
            name : _name,
            email : _email,
            phoneNumber : _phoneNumber,
            location : _location,
            walletAddress : _walletAddress
        });
        userArray.push(newUser);
        recordTransaction(msg.sender, "Add User", _name);
    }

    function setPrice (
        uint256 _minPrice,
        uint256 _maxPrice,
        string memory _productName
    ) public onlyOwner{
        Price memory prodPrice = Price ({
            min_Price: _minPrice,
            max_Price : _maxPrice
        });

        productPricemapping[_productName] = prodPrice;
        productPrices.push(prodPrice);
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
    require(totalPrice >= _kilograms * Productsmapping[_owner].price, "Insufficient funds");


    // Transfer the total price from the buyer's address to the owner's address
    _owner.transfer(totalPrice);

    // Record the transaction
    recordTransaction(msg.sender, "Buy Product", Productsmapping[_owner].productName);
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

    function Login() public view returns (string memory) {
        return (msg.sender == i_owner) ? "admin" : "user";        
    }

    function logout() external {
        //loggedInUser = address(0);
    }
}