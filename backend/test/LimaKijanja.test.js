const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LimaKijanja", function () {
  let limaKijanja;
  let owner, user1, user2;

  beforeEach(async () => {
    [owner, user1, user2] = await ethers.getSigners();

    const LimaKijanja = await ethers.getContractFactory("LimaKijanja");
    limaKijanja = await LimaKijanja.deploy();
    await limaKijanja.waitForDeployment();
  });

  it("should allow the owner to register a user", async () => {
    const name = "John Doe";
    const email = "john@example.com";
    const phoneNumber = "123456789";
    const location = "City";
    const walletAddress = user1.address;

    await limaKijanja.connect(owner).register(name, email, phoneNumber, location, walletAddress);

    const users = await limaKijanja.userArray(user1.address);
    expect(users.name).to.equal(name);
  });
  
  it("should allow the owner to set a product price", async () => {
    const productName = "Tomatoes";
    const minPrice = 5;
    const maxPrice = 10;

    await limaKijanja.connect(owner).setPrice(minPrice, maxPrice, productName);

    const price = await limaKijanja.productPricemapping(productName);
    expect(price.min_Price).to.equal(minPrice);
  });

  it("should allow a user to post a product", async () => {
    const productName = "Tomatoes";
    const productDescription = "Fresh tomatoes from the garden";
    const kilograms = 10;
    const price = 5;
    const tag = "Vegetables";

    await limaKijanja.connect(user1).postProduct(productName, productDescription, kilograms, price, tag);

    const products = await limaKijanja.viewProducts();
    expect(products.length).to.equal(1);
    expect(products[0].productName).to.equal(productName);
  });

  it("should allow a user to buy a product", async () => {
    const ownerAddress = user1.address;
    const kilograms = 5;

    await limaKijanja.connect(user1).postProduct("Tomatoes", "Fresh tomatoes", 10, 5, "Vegetables");

    const initialBalance = await ethers.provider.getBalance(ownerAddress);

    await limaKijanja.connect(user2).buyProduct(ownerAddress, kilograms, { value: kilograms * 5 });

    const finalBalance = await ethers.provider.getBalance(ownerAddress);
    const expectedBalance = initialBalance.add(kilograms * 5);
    expect(finalBalance).to.equal(expectedBalance);
  });

  it("should record transactions", async () => {
    const productName = "Tomatoes";
    const productDescription = "Fresh tomatoes from the garden";
    const kilograms = 10;
    const price = 5;
    const tag = "Vegetables";

    await limaKijanja.connect(user1).postProduct(productName, productDescription, kilograms, price, tag);

    const transactions = await limaKijanja.getTransactionsForUser();
    expect(transactions.length).to.equal(1);
    expect(transactions[0].action).to.equal("Post Product");
  });

  // Add more tests as needed...

});
