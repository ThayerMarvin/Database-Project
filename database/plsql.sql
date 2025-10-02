-- 1 # Citation For The Following Function:
-- 2 # Date:06/05/2025
-- 3 # Copied from
-- 4 # Used AI 
-- 5 # SourceURL: Copilot
-- 6 # We used AI to write our stored procedures. We wrote the queries needed and then asked copilot to transform them into stored procedures.

-- #############################
-- Insert Procedure
DROP PROCEDURE IF EXISTS sp_InsertProduct;
DELIMITER //

CREATE PROCEDURE sp_InsertProduct(
    IN p_productName VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_productSalesPrice DECIMAL(10,2),
    IN p_productTypeID INT,
    IN p_vendorID INT
)
BEGIN
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
        p_productName,
        p_price,
        p_productSalesPrice,
        p_productTypeID,
        p_vendorID
    );
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_InsertSale;
DELIMITER //

CREATE PROCEDURE sp_InsertSale(
    IN p_customerID INT,
    IN p_saleDate DATE,
    IN p_transactionType VARCHAR(50),
    IN p_saleAmount DECIMAL(10,2),
    IN p_productID INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    -- Insert into the Sales table
    INSERT INTO Sales
    (
        customerID,
        saleDate,
        transactionType,
        saleAmount
    )
    VALUES
    (
        p_customerID,
        p_saleDate,
        p_transactionType,
        p_saleAmount
    );

    -- Get the last inserted saleID
    SET @lastSaleID = LAST_INSERT_ID();

    -- Insert into the ProductHasSales table
    INSERT INTO ProductHasSales
    (
        saleID,
        productID,
        quantity,
        price
    )
    VALUES
    (
        @lastSaleID,
        p_productID,
        p_quantity,
        p_price
    );
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_InsertAddress;
DELIMITER //

CREATE PROCEDURE sp_InsertAddress(
    IN p_addressLine1 VARCHAR(50),
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(50),
    IN p_postalCode VARCHAR(50)
)
BEGIN
    -- Insert into the Addresses table
    INSERT INTO Addresses
    (
        addressLine1,
        city,
        state,
        postalCode
    )
    VALUES
    (
        p_addressLine1,
        p_city,
        p_state,
        p_postalCode
    );
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_InsertCustomer;
DELIMITER //

CREATE PROCEDURE sp_InsertCustomer(
    IN p_customerName VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phoneNumber VARCHAR(20),
    IN p_accountValue DECIMAL(10,2)
)
BEGIN
    INSERT INTO Customers
    (
        customerName,
        email,
        phoneNumber,
        accountValue
    )
    VALUES
    (
        p_customerName,
        p_email,
        p_phoneNumber,
        p_accountValue
    );
END //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_InsertVendor;
CREATE PROCEDURE sp_InsertVendor(
    IN p_companyName VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phoneNumber VARCHAR(20),
    IN p_addressID INT,
    IN p_accountsPayable DECIMAL(10,2)
)
BEGIN
    INSERT INTO Vendors
    (
        companyName,
        email,
        phoneNumber,
        addressID,
        accountsPayable
    )
    VALUES
    (
        p_companyName,
        p_email,
        p_phoneNumber,
        p_addressID,
        p_accountsPayable
    );
END //

DELIMITER ;



-- Update Procedure
DROP PROCEDURE IF EXISTS sp_UpdateProduct;

DELIMITER //
CREATE PROCEDURE sp_UpdateProduct(
    IN p_id INT,
    IN p_productName VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_productSalesPrice DECIMAL(10,2),
    IN p_productTypeID INT,
    IN p_vendorID INT
)
BEGIN
    -- Use COALESCE to only update columns if provided values are not NULL
    UPDATE Products
    SET
        productName = COALESCE(p_productName, productName),
        price = COALESCE(p_price, price),
        productSalesPrice = COALESCE(p_productSalesPrice, productSalesPrice),
        productTypeID = COALESCE(p_productTypeID, productTypeID),
        vendorID = COALESCE(p_vendorID, vendorID)
    WHERE productID = p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateCustomer;
DELIMITER //

CREATE PROCEDURE sp_UpdateCustomer(
    IN p_customerID INT,             -- Customer ID to identify the row to update
    IN p_customerName VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_phoneNumber VARCHAR(15),
    IN p_accountValue DECIMAL(10,2)
)
BEGIN
    -- Use COALESCE to only update columns if the input is NOT NULL
    UPDATE Customers
    SET
        customerName = COALESCE(p_customerName, customerName),
        email = COALESCE(p_email, email),
        phoneNumber = COALESCE(p_phoneNumber, phoneNumber),
        accountValue = COALESCE(p_accountValue, accountValue)
    WHERE customerID = p_customerID;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_UpdateSale;
DELIMITER //

CREATE PROCEDURE sp_UpdateSale(
    IN p_saleID INT,
    IN p_customerID INT,
    IN p_saleDate DATE,
    IN p_transactionType VARCHAR(50),
    IN p_saleAmount DECIMAL(10,2),
    IN p_productID INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    UPDATE Sales
    SET
        customerID = COALESCE(p_customerID, customerID),
        saleDate = COALESCE(p_saleDate, saleDate),
        transactionType = COALESCE(p_transactionType, transactionType),
        saleAmount = COALESCE(p_saleAmount, saleAmount)
    WHERE saleID = p_saleID;

    UPDATE ProductHasSales
    SET
        productID = COALESCE(p_productID, productID),
        quantity = COALESCE(p_quantity, quantity),
        price = COALESCE(p_price, price)
    WHERE saleID = p_saleID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateAddress;
DELIMITER //
CREATE PROCEDURE sp_UpdateAddress(
    IN p_addressID INT,
    IN p_addressLine1 VARCHAR(255),
    IN p_city VARCHAR(255),
    IN p_state VARCHAR(255),
    IN p_postalcode VARCHAR(50)

)
BEGIN
    UPDATE Addresses
    SET
        addressLine1 = COALESCE(p_addressLine1, addressLine1),
        city = COALESCE(p_city, city),
        state = COALESCE(p_state, state),
        postalcode = COALESCE(p_postalcode, postalcode)
    WHERE addressID = p_addressID;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateVendor;
DELIMITER //

CREATE PROCEDURE sp_UpdateVendor(
    IN p_vendorID INT,
    IN p_companyName VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phoneNumber VARCHAR(20),
    IN p_addressID INT,
    IN p_accountsPayable DECIMAL(10,2)
)
BEGIN
    UPDATE Vendors
    SET
        companyName = COALESCE(p_companyName, companyName),
        email = COALESCE(p_email, email),
        phoneNumber = COALESCE(p_phoneNumber, phoneNumber),
        addressID = COALESCE(p_addressID, addressID),
        accountsPayable = COALESCE(p_accountsPayable, accountsPayable)
    WHERE vendorID = p_vendorID;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ResetDatabase;
DELIMITER //

CREATE PROCEDURE sp_ResetDatabase()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    -- Reset the Customers table
    TRUNCATE TABLE Customers;
    INSERT INTO Customers (customerName, email, phoneNumber, accountValue)
    VALUES
        ('Thayer Marvin', 'thayer@gmail.com', '541-701-1881', 51),
        ('Joven Kvortek', 'Jovenk@hotmail.com', '541-567-8125', 12),
        ('Madison Nelson', 'nelsonm@yahoo.com', '541-968-3239', 27),
        ('Penelope Paul', 'ppaul@gmail.com', '541-701-1235', 22);

    -- Reset the Addresses table
    TRUNCATE TABLE Addresses;
    INSERT INTO Addresses (addressLine1, city, state, postalCode)
    VALUES
        ('123 Main St', 'Springfield', 'Oregon', '97478'),
        ('407 Jefferson St', 'Eugene', 'Oregon', '97407'),
        ('42 W 11th Ave', 'Eugene', 'Oregon', '97407'),
        ('1389 Whitmore Circle', 'Eugene', 'Oregon', '97408');

    -- Reset the Vendors table
    TRUNCATE TABLE Vendors;
    INSERT INTO Vendors (companyName, email, phoneNumber, addressID, accountsPayable)
    VALUES
        ('Sports N Stuff', 'sportsnstuff@gmail.com', '541-920-6354', 1, 250.47),
        ('Pokemon Connect', 'pc@gmail.com', '541-567-8125', 2, 900.54),
        ('TradingCards R Us', 'tradingcardsru@gmail.com', '541-503-4487', 3, 133.56),
        ('Magical Cards', 'magical@gmail.com', '541-330-2990', 4, 601.23);

    -- Reset the ProductBrands table
    TRUNCATE TABLE ProductBrands;
    INSERT INTO ProductBrands (productBrand)
    VALUES
        ('Topps'),
        ('Pokemon'),
        ('Magic The Gathering');

    -- Reset the ProductTypes table
    TRUNCATE TABLE ProductTypes;
    INSERT INTO ProductTypes (productType, productBrandID, productDescription)
    VALUES
        ('Sports Card Box', 1, 'Box of 10 Booster Packs'),
        ('Pokemon Card Booster Pack', 2, 'Single Booster Pack'),
        ('Magic Cards Deck', 3, 'Prebuilt Deck'),
        ('Pokemon Card Binder', 2, 'Card Binder');

    -- Reset the Products table
    TRUNCATE TABLE Products;
    INSERT INTO Products (productName, price, productSalesPrice, productTypeID, vendorID)
    VALUES
        ('Surging Sparks Blister', 3.50, 5.99, 2, 2),
        ('NFL Super Breaker', 75.00, 200.00, 1, 1),
        ('Catch Em All Binder', 6.50, 14.99, 4, 2),
        ('Final Fantasy Prebuilt Deck', 47.89, 99.99, 3, 4);

    -- Reset the Sales table
    TRUNCATE TABLE Sales;
    INSERT INTO Sales (customerID, saleDate, transactionType, saleAmount)
    VALUES
        (1, '2025-01-19', 'sale', 17.97),
        (2, '2025-03-04', 'sale', 200.00),
        (3, '2025-04-11', 'sale', 29.98),
        (1, '2025-04-24', 'sale', 199.98);

    -- Reset the ProductHasSales table (many-to-many)
    TRUNCATE TABLE ProductHasSales;
    INSERT INTO ProductHasSales (productID, saleID, quantity, price)
    VALUES
        (1, 1, 3, 5.99),
        (2, 2, 1, 200.00),
        (3, 3, 2, 14.99),
        (4, 4, 2, 99.99);

    -- You can add additional tables to reset here if needed
    SET FOREIGN_KEY_CHECKS = 1;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_GetProductsPage;
DELIMITER //

CREATE PROCEDURE sp_GetProductsPage()
BEGIN
    SELECT Products.*,
           IFNULL(Products.vendorID, 'NULL') AS vendorID,       -- Show "NULL" for vendorID if NULL
           IFNULL(Vendors.companyName, 'NULL') AS vendorName,   -- Show "NULL" for vendorName if NULL
           ProductBrands.productBrand AS productBrandName
    FROM Products
         LEFT JOIN Vendors ON Products.vendorID = Vendors.vendorID -- LEFT JOIN for retaining products with NULL vendorIDs
         JOIN ProductTypes ON Products.productTypeID = ProductTypes.productTypeID
         JOIN ProductBrands ON ProductTypes.productBrandID = ProductBrands.productBrandID;
END //
DELIMITER ;





DROP PROCEDURE IF EXISTS sp_GetSalesPage;
DELIMITER //

CREATE PROCEDURE sp_GetSalesPage()
BEGIN
    SELECT Sales.saleID,
           Sales.customerID,
           DATE_FORMAT(Sales.saleDate, '%Y-%m-%d') AS saleDate,
           Sales.transactionType,
           Sales.saleAmount,
           Customers.customerName,
           Customers.email,
           Products.productID,
           Products.productName,
           ProductHasSales.quantity,
           ProductHasSales.price
    FROM Sales
             JOIN Customers ON Sales.customerID = Customers.customerID
             JOIN ProductHasSales ON Sales.saleID = ProductHasSales.saleID
             JOIN Products ON ProductHasSales.productID = Products.productID;
END //
DELIMITER ;

DELIMITER //

DELIMITER //

DROP PROCEDURE IF EXISTS sp_GetVendorsPage;

CREATE PROCEDURE sp_GetVendorsPage()
BEGIN
    SELECT
        Vendors.vendorID,
        Vendors.companyName,
        Vendors.email,
        Vendors.phoneNumber,
        IFNULL(Addresses.addressLine1, 'NULL') AS addressLine1,
        IFNULL(Addresses.city, 'NULL') AS city,
        IFNULL(Addresses.state, 'NULL') AS state,
        IFNULL(Addresses.postalCode, 'NULL') AS postalCode,
        Vendors.accountsPayable
    FROM
        Vendors
    LEFT JOIN
        Addresses
    ON
        Vendors.addressID = Addresses.addressID;
END //

DELIMITER ;



DROP PROCEDURE IF EXISTS sp_DeleteSale;

DELIMITER //
CREATE PROCEDURE sp_DeleteSale(IN p_salesID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete the sale from the Sales table
        DELETE FROM Sales WHERE saleID = p_salesID;

        -- Use ROW_COUNT() to check rows affected
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Sales for saleID: ', p_salesID);
            -- Trigger a custom error, invoking the EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteCustomer;

DELIMITER //
CREATE PROCEDURE sp_DeleteCustomer(IN p_customerID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete the customer from the Customers table
        DELETE FROM Customers WHERE customerID = p_customerID;

        -- Use ROW_COUNT() to check rows affected
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Customers for customerID: ', p_customerID);
            -- Trigger a custom error, invoking the EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteAddress;

DELIMITER //
CREATE PROCEDURE sp_DeleteAddress(IN p_addressID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete the customer from the Customers table
        DELETE FROM Addresses WHERE addressID = p_addressID;

        -- Use ROW_COUNT() to check rows affected
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Addresses for addressID: ', p_addressID);
            -- Trigger a custom error, invoking the EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteVendor;

DELIMITER //
CREATE PROCEDURE sp_DeleteVendor(IN p_vendorID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete the customer from the Customers table
        DELETE FROM Vendors WHERE vendorID = p_vendorID;

        -- Use ROW_COUNT() to check rows affected
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Vendors for vendorID: ', p_vendorID);
            -- Trigger a custom error, invoking the EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteProduct;

DELIMITER //
CREATE PROCEDURE sp_DeleteProduct(IN p_productID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete rows from the Products table
        DELETE FROM Products WHERE productID = p_productID;

        -- Use ROW_COUNT() to check rows affected
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Products for productID: ', p_productID);
            -- Trigger custom error, invoking the EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;