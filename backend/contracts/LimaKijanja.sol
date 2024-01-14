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
        address user;
        string action;
        string details;
    }

    TransactionRecord[] public transactionRecords;
    Price [] public productPrices;
    Product[] public productrArray;
    User[] public userArray;

    mapping (string => Price) public  productPricemapping;
    mapping (address => Product) public Productsmapping;
    //mapping (Product => User) public productContactmapping;

    event TransactionEvent(address indexed user, string action, string details);


    constructor(){
        i_owner=msg.sender;
    }

    function postProduct(
        string memory _productName,
        string memory _productDescription,
        uint256 _kilograms,
        uint256 _price,
        string memory _tag
    ) public {

         Price memory prodPrice = productPricemapping[_productName];
        require(_price >= prodPrice.min_Price && _price <= prodPrice.max_Price, "Price not within the specified range");
        
        Product memory myproduct =  Product({
            productName: _productName,
            productDescription: _productDescription,
            kilograms: _kilograms,
            price: _price,
            owner: msg.sender,
            tag: _tag


        });
        productrArray.push(myproduct);
        Productsmapping[msg.sender]= myproduct;

        recordTransaction(msg.sender, "Post Product", _productName);
        

    }

    function viewProducts() public view returns (Product[] memory) {
        return  productrArray;
     
    }

    function addUser(
        string memory _name,
        string memory _email,
        string memory _phoneNumber,
        string memory _location,
        address _walletAddress
    ) public {

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
        uint256 _minPRice,
        uint256 _maxPrice,
        string memory _productName) public {
        Price memory prodPrice = Price ({
            min_Price: _minPRice,
            max_Price : _maxPrice
        });

        productPricemapping[_productName] = prodPrice;
        productPrices.push(prodPrice);
        recordTransaction(msg.sender, "Set Price", _productName);

    }

    function recordTransaction(
        address _user,
        string memory _action,
        string memory _details) internal {
        TransactionRecord memory transaction = TransactionRecord({
            user: _user,
            action: _action,
            details: _details
        });

        transactionRecords.push(transaction);
        emit TransactionEvent(_user, _action, _details);
    }

    function getTransactionRecords() public view returns (TransactionRecord[] memory) {
        return transactionRecords;
    }

}