SET FOREIGN_KEY_CHECKS = 0;

-- Truncate tables in the correct order
TRUNCATE TABLE ProductHasSales;
TRUNCATE TABLE Products;
TRUNCATE TABLE Sales;
TRUNCATE TABLE ProductTypes;
TRUNCATE TABLE ProductBrands;
TRUNCATE TABLE Vendors;
TRUNCATE TABLE Customers;
TRUNCATE TABLE Addresses;

-- Create the Customers table

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers
(
    customerID INT AUTO_INCREMENT NOT NULL,
    customerName VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    phoneNumber VARCHAR(12) NOT NULL,
    accountValue DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY(customerID)
);

-- Insert sample data into the Customers table
INSERT INTO Customers
(
    customerName,
    email,
    phoneNumber,
    accountValue
)
VALUES
(
    'Thayer Marvin',
    'thayer@gmail.com',
    '541-701-1881',
    51
),
(
    'Joven Kvortek',
	'Jovenk@hotmail.com',
    '541-567-8125',
    12
),
(
    'Madison Nelson',
    'nelsonm@yahoo.com',
    '541-968-3239',
    27
),
(
    'Penelope Paul',
    'ppaul@gmail.com',
    '541-701-1235',
    22
);

-- Create the Addresses table
DROP TABLE IF EXISTS Addresses;
CREATE TABLE Addresses
(
    addressID INT AUTO_INCREMENT NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    city VARCHAR(30) NOT NULL,
    state VARCHAR(20) NOT NULL,
    postalCode CHAR(5) NOT NULL,
    PRIMARY KEY(addressID)
);

-- Insert sample data into the Addresses table
INSERT INTO Addresses
(
    addressLine1,
    city,
    state,
    postalCode
)
VALUES
(
    '123 Main St',
    'Springfield',
    'Oregon',
    '97478'
),
(
    '407 Jefferson St',
    'Eugene',
    'Oregon',
    '97407'
),
(
    '42 W 11th Ave',
    'Eugene',
    'Oregon',
    '97407'
),
(
    '1389 Whitmore Circle',
    'Eugene',
    'Oregon',
    '97408'
);

-- Create the Vendors table
DROP TABLE IF EXISTS Vendors;
CREATE TABLE Vendors
(
    vendorID INT AUTO_INCREMENT NOT NULL,
    companyName VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    phoneNumber VARCHAR(12) NOT NULL,
    addressID INT NULL,
    accountsPayable DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY(vendorID),
    FOREIGN KEY(addressID) REFERENCES Addresses(addressID) ON DELETE SET NULL
);

-- Insert sample data into the Vendors table
INSERT INTO Vendors(
    companyName,
    email,
    phoneNumber,
    addressID,
    accountsPayable
)
VALUES
(
    'Sports N Stuff',
    'sportsnstuff@gmail.com',
    '541-920-6354',
    1,
    250.47
),
(
    'Pokemon Connect',
    'pc@gmail.com',
    '541-567-8125',
    2,
    900.54
),
(
    'TradingCards R Us',
    'tradingcardsru@gmail.com',
    '541-503-4487',
    3,
    133.56
),
(
    'Magical Cards',
    'magical@gmail.com',
    '541-330-2990',
    4,
    601.23
);

-- Create the ProductBrands table
DROP TABLE IF EXISTS ProductBrands;
CREATE TABLE ProductBrands
(
    productBrandID INT AUTO_INCREMENT NOT NULL,
    productBrand VARCHAR(50) NOT NULL,
    PRIMARY KEY(productBrandID)
);

-- Insert sample data into the ProductBrands table
INSERT INTO ProductBrands
(
    productBrand
)
VALUES
(
    'Topps'
),
(
    'Pokemon'
),
(
    'Magic The Gathering'
);

-- Create the ProductTypes table
DROP TABLE IF EXISTS ProductTypes;
CREATE TABLE ProductTypes
(
    productTypeID INT AUTO_INCREMENT NOT NULL,
    productType VARCHAR(50) NOT NULL,
    productBrandID INT NOT NULL,
    productDescription VARCHAR(4000) DEFAULT NULL,
    PRIMARY KEY(productTypeID),
    FOREIGN KEY(productBrandID) REFERENCES ProductBrands(productBrandID)
    ON DELETE CASCADE
);

-- Insert sample data into the ProductTypes table
INSERT INTO ProductTypes
(
    productType,
    productBrandID,
    productDescription
)
VALUES
(
    'Sports Card Box',
    1,
    'Box of 10 Booster Packs'
),
(
    'Pokemon Card Booster Pack',
    2,
    'Single Booster Pack'
),
(
    'Magic Cards Deck',
    3,
    'Prebuilt Deck'
),
(
    'Pokemon Card Binder',
    2,
    'Card Binder'
);

-- Create the Products table
DROP TABLE IF EXISTS Products;
CREATE TABLE Products
(
    productID INT AUTO_INCREMENT NOT NULL,
    productName VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    productSalesPrice DECIMAL(10,2) NOT NULL,
    productTypeID INT NOT NULL,
    vendorID INT,
    PRIMARY KEY(productID),
    FOREIGN KEY(productTypeID) REFERENCES ProductTypes(productTypeID),
    FOREIGN KEY(vendorID) REFERENCES Vendors(vendorID) ON DELETE SET NULL
);

-- Insert sample data into the Products table
INSERT INTO Products
(
    productName,
    price,
    productSalesPrice,
    productTypeID,
    vendorID
)
VALUES
(
    'Surging Sparks Blister',
    3.50,
    5.99,
    2,
    2
),
(
    'NFL Super Breaker',
    75.00,
    200.00,
    1,
    1
),
(
    'Catch Em All Binder',
    6.50,
    14.99,
    4,
    2
),
(
    'Final Fantasy Prebuilt Deck',
    47.89,
    99.99,
    3,
    4
);

-- Create the Sales table
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales
(
    saleID INT AUTO_INCREMENT NOT NULL,
    customerID INT DEFAULT NULL,
    saleDate DATE NOT NULL,
    transactionType ENUM('sale', 'purchase') NOT NULL,
    saleAmount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(saleID),
    FOREIGN KEY(customerID) REFERENCES Customers(customerID) ON DELETE CASCADE
);

-- Insert sample data into the Sales table
INSERT INTO Sales
(
    customerID,
    saleDate,
    transactionType,
    saleAmount
)
VALUES
(
    1,
    '2025-01-19',
    'sale',
    17.97
),
(
    2,
    '2025-03-04',
    'sale',
    200.00
),
(
    3,
    '2025-04-11',
    'sale',
    29.98
),
(
    1,
    '2025-04-24',
    'sale',
    199.98
);

-- Create the ProductHasSales table, intersection table for many-to-many between Products and Sales
DROP TABLE IF EXISTS ProductHasSales;
CREATE TABLE ProductHasSales
(
    productHasSalesID INT AUTO_INCREMENT NOT NULL,
    productID INT NOT NULL,
    saleID INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(productHasSalesID),
    FOREIGN KEY(productID) REFERENCES Products(productID) ON DELETE CASCADE,
    FOREIGN KEY(saleID) REFERENCES Sales(saleID) ON DELETE CASCADE
);

-- Insert sample data into the ProductHasSales table
INSERT INTO ProductHasSales
(
    productID,
    saleID,
    quantity,
    price
)
VALUES
(
    1,
    1,
    3,
    5.99
),
(
    2,
    2,
    1,
    200.00
),
(
    3,
    3,
    2,
    14.99
),
(
    4,
    4,
    2,
    99.99
);



