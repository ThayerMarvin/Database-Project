-- Query to get the table for the Products page, join with the ProductType and ProductBrand tables
SELECT Products.*, Vendors.companyName, ProductBrands.productBrand 
FROM Products
JOIN Vendors ON Products.vendorID = Vendors.vendorID
JOIN ProductTypes ON Products.productTypeID = ProductTypes.productTypeID
JOIN ProductBrands ON ProductTypes.productBrandID = ProductBrands.productBrandID;

-- Query to insert values into the Products table
INSERT INTO Products (
    productName, 
    price, 
    productSalesPrice, 
    productTypeID,  
    vendorID 
    )
VALUES (
    @productName, 
    @price, 
    @productSalesPrice, 
    @productTypeID,  
    @vendorID 
    );

-- Query to update values in the Products table
UPDATE Products
SET 
    productName = @productName,
    price = @price,
    productSalesPrice = @productSalesPrice,
    productTypeID = @productTypeID,
    vendorID = @vendorID
WHERE productID = @productID;

-- Query to delete values from the Products table
DELETE FROM Products
WHERE productID = @productID;


-- Query to get the table for the Customers page
SELECT Customers.customerName, Customers.email, Customers.phoneNumber, Customers.accountValue 
FROM Customers;

-- Query to insert values into the Customers tables
INSERT INTO Customers (
    customerName, 
    email, 
    phoneNumber, 
    accountValue
    )
VALUES (
    @customerName, 
    @email, 
    @phoneNumber, 
    @accountValue);

-- Query to update values in the Customers table
UPDATE Customers
SET 
    customerName = @customerName, 
    email = @email, 
    phoneNumber = @phoneNumber, 
    accountValue = @accountValue
    
WHERE customerID = @customerID;

-- Query to delete a customer from the Customers table
DELETE FROM Customers
WHERE customerID = @customerID;


-- Query to get the table on the Sales page, joins it with the products table
SELECT Sales.saleID, Sales.customerID, Sales.saleDate, Sales.transactionType, Sales.saleAmount, Customers.customerName, 
Customers.email, Products.productID, Products.productName, ProductHasSales.quantity, ProductHasSales.price
FROM Sales
JOIN Customers 
ON Sales.customerID = Customers.customerID
JOIN ProductHasSales 
ON Sales.saleID = ProductHasSales.saleID
JOIN Products 
ON ProductHasSales.productID = Products.productID;

-- Query to insert values into the Sales table
INSERT INTO Sales
(
    customerID,
    saleDate,
    transactionType,
    saleAmount
)
VALUES(
    @customerID,
    @saleDate,
    @transactionType,
    @saleAmount
)

-- Query to update values in the Sales table
UPDATE Sales
SET 
    customerID = @customerID,
    saleDate = @saleDate,
    transactionType = @transactionType,
    saleAmount = @saleAmount
WHERE salesID = @salesID;

-- Query to delete a customer from the Sales table
DELETE FROM Sales
WHERE salesID = @salesID;


-- Query to get the table on the Vendors page joined with the addresses table
SELECT Vendors.companyName, Vendors.email, Vendors.phoneNumber, Addresses.addressLine1, Addresses.city, Addresses.state, Addresses.postalCode, Vendors.accountsPayable 
FROM Addresses 
JOIN Vendors ON Vendors.addressId = Addresses.addressid;

-- Query to insert values into the Vendors table
INSERT INTO Vendors (
    companyName, 
    email, 
    phoneNumber, 
    addressID,
    accountsPayable)
VALUES (
    @companyName, 
    @email, 
    @phoneNumber, 
    @addressID
    @accountsPayable
    );

--Query to update values in the Vendors table
UPDATE Vendors
SET 
    companyName = @companyName, 
    email = @email, 
    phoneNumber = @phoneNumber, 
    addressID = @addressID,
    accountsPayable = @accountsPayable
WHERE vendorID = @vendorID;

--Query to delete value in the Vendors table
DELETE FROM Vendors
WHERE vendorID = @vendorID;

-- Query to show the ProductBrands table
SELECT ProductBrands.* FROM ProductBrands;

-- Query to show the ProductTypes table
SELECT ProductTypes.* FROM ProductTypes;

-- Query to show the Addresses table
SELECT Addresses.* FROM Addresses;

--Query to update Addresses table
UPDATE Addresses
SET 
    addressLine1 = @addressLine1,
    city = @city,
    state = @state,
    postalCode = @postalCode
WHERE addressID = @addressID;

-- Query to show the ProductHasSales table
SELECT ProductHasSales.* FROM ProductHasSales;