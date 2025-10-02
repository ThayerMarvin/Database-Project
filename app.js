// ########################################
// ########## SETUP

// Express
// 1 # Citation For The Following Function:
// 2 # Date:06/05/2025
// 3 # Copied from
// 4 # Based on the class starter code given
// 5 # SourceURL:https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 8468;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES

// 1 # Citation For The Following Function:
// 2 # Date:06/05/2025
// 3 # Copied from
// 4 # Based on the class starter code given
// 5 # SourceURL:https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948
// Every other route was written by us on our own

app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

let cachedProducts = null;
app.get('/products', async function (req, res) {
    try {
        const query = `CALL sp_GetProductsPage();`;
        const [products] = await db.query(query);
        const productList = products[0]
        cachedProducts = productList

        res.render("products", { products: productList});
    } catch (error) {
        console.error("Error fetching products:", error.message);
        res.status(500).send("Error fetching products.");
    }
});



app.get('/manage-products', async function (req, res) {
    try {
        const [products] = await db.query('SELECT * FROM Products;');
        const [vendors] = await db.query('SELECT vendorID, companyName FROM Vendors;');
        const [producttypes] = await db.query('SELECT productTypeID, productType FROM ProductTypes;');

        res.render('manage-products', {
            products,
            vendors,
            producttypes
        });
    } catch (error) {
        console.error('Error fetching data:', error);
        res.status(500).send('An error occurred while fetching data.');
    }
});


let cachedSales = null;
app.get('/sales', async function (req, res) {
    try {
        const query2 = `CALL sp_GetSalesPage();`;
        const [sales] = await db.query(query2);
        const salesList = sales[0]; // Use the first element of the result set
        cachedSales = salesList;

        // Apply date formatting and ensure `salesID` exists for each sale
        salesList.forEach(sale => {
            // Check if saleDate exists and format it as YYYY-MM-DD
            if (sale.saleDate) {
                const date = new Date(sale.saleDate);
                sale.saleDate = isNaN(date.getTime())
                    ? null // Handle invalid dates
                    : date.toISOString().split('T')[0]; // Format as YYYY-MM-DD
            } else {
                sale.saleDate = null; // Handle null dates
            }

            // Verify `salesID` exists and has a valid value
            if (!sale.saleID) {
                console.warn(`Warning: Missing salesID for sale:`, sale);
                sale.saleID = null; // Ensure it's at least set to `null`
            }
        });

        // Render 'sales' page with the processed salesList
        res.render('sales', { sales: salesList });
    } catch (error) {
        console.error('Error executing queries: ', error);
        res.status(500).send('An error occurred while executing the database queries.');
    }
});

app.get('/manage-sales', async function (req, res) {
    try {
        // Query database to fetch customers, products, and sales
        const customersQuery = `SELECT customerID, customerName FROM Customers`;
        const productsQuery = `SELECT productID, productName FROM Products`;
        const salesQuery = `SELECT saleID FROM Sales`; // Fetch sale IDs for the dropdown

        // Execute queries
        const [customers] = await db.query(customersQuery);
        const [products] = await db.query(productsQuery);
        const [sales] = await db.query(salesQuery);

        // Render the form with queried data for select fields
        res.render('manage-sales', {
            customers: customers, // Pass customers for the dropdown
            products: products,   // Pass products for the dropdown
            sales: sales          // Pass sales for Sale ID dropdown
        });
    } catch (error) {
        console.error('Error fetching sales, customers, or products:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});




let cachedVendors = null;
app.get('/vendors', async function (req, res) {
    try {
        // Call the stored procedure `sp_GetVendorsPage`
        const [vendors] = await db.query('CALL sp_GetVendorsPage();');

        // Cache the result for future use, if necessary
        cachedVendors = vendors[0]; // Stored procedures typically return an extra wrapper around the result set

        // Render the `vendors` page, passing the result to the view
        res.render('vendors', { vendors: vendors[0] }); // Use `vendors[0]` to access the actual result
    } catch (error) {
        console.error('Error executing stored procedure: ', error);
        res.status(500).send('An error occurred while fetching vendor data.');
    }
});

// Route to render the vendor management page
app.get('/manage-vendors', async function (req, res) {
    try {
        // These are standalone queries fetching vendors and addresses for the management page
        const [vendors] = await db.query('SELECT vendorID, companyName FROM Vendors');
        const [addresses] = await db.query('SELECT addressID, addressLine1 FROM Addresses');

        res.render('manage-vendors', { vendors, addresses });
    } catch (error) {
        console.error('Error executing queries: ', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

// Route to fetch and render all customers
let cachedCustomers = null;
app.get('/customers', async function (req, res) {
    try {
        const query4 = 'SELECT * FROM Customers';
        const [customers] = await db.query(query4);
        cachedCustomers = customers

        res.render('customers', { customers: customers });
    } catch (error) {
        console.error('Error executing queries: ', error)
        res.status(500).send('An error occurred while executing the database queries.')
    }
})

// Route to render the customer management page using cached data
app.get('/manage-customers', async function (req, res) {
    if (cachedCustomers) {
        res.render('manage-customers', { customers: cachedCustomers });
    } else {
        res.status(500).send('An error occurred while rendering the page.');
    }
})

// Route to fetch and render all addresses
let cachedAddresses = null;
app.get('/addresses', async function (req, res) {
    try {
        const addressesquery = 'SELECT Addresses.* FROM Addresses';
        const [addresses] = await db.query(addressesquery);
        cachedAddresses = addresses

        res.render('addresses', { addresses: addresses });
    } catch (error) {
        console.error('Error executing queries: ', error)
        res.status(500).send('An error occurred while executing the database queries.')
    }
})

// Route to render the addresses management page 
app.get('/manage-addresses', async function (req, res) {
    if (cachedAddresses) {
        res.render('manage-addresses', { addresses: cachedAddresses });
    } else {
        res.status(500).send('An error occurred while rendering the page.');
    }
})

// Route to fetch and render all product brands
app.get('/productbrands', async function (req, res) {
    try {
        const productbrandsquery = 'SELECT ProductBrands.* FROM ProductBrands';
        const [productbrands] = await db.query(productbrandsquery);

        res.render('productbrands', { productbrands: productbrands });
    } catch (error) {
        console.error('Error executing queries: ', error)
        res.status(500).send('An error occurred while executing the database queries.')
    }
})

// Route to fetch and render all product types
app.get('/producttypes', async function (req, res) {
    try {
        const producttypesquery = 'SELECT ProductTypes.* FROM ProductTypes';
        const [producttypes] = await db.query(producttypesquery);

        res.render('producttypes', { producttypes: producttypes });
    } catch (error) {
        console.error('Error executing queries: ', error)
        res.status(500).send('An error occurred while executing the database queries.')
    }
})

// Route to fetch and render all product sales relationships
app.get('/producthassales', async function (req, res) {
    try {
        const producthassalesquery = 'SELECT ProductHasSales.* FROM ProductHasSales';
        const [producthassales] = await db.query(producthassalesquery);

        res.render('producthassales', { producthassales: producthassales });
    } catch (error) {
        console.error('Error executing queries: ', error)
        res.status(500).send('An error occurred while executing the database queries.')
    }
})

// DELETE ROUTES
app.post('/products/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
         console.log('Request body:', req.body);

        // Create and execute the query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query = `CALL sp_DeleteProduct(?);`;
        await db.query(query, [data.delete_product_id]);

        console.log(`DELETE product. ID: ${data.delete_product_id} ` +
            `Name: ${data.delete_product_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/products');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Route to delete sale
app.post('/sales/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Create and execute the query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query = `CALL sp_DeleteSale(?);`;
        await db.query(query, [data.delete_sales_id]);

        console.log(`DELETE sale. ID: ${data.delete_sales_id}`);

        // Redirect the user to the updated sales page
        res.redirect('/sales');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//Route to delete a customer
app.post('/customers/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Create and execute the query
        // Using parameterized queries to prevent SQL injection attacks
        const query = `CALL sp_DeleteCustomer(?);`;
        await db.query(query, [data.delete_customer_id]);

        console.log(`DELETED customer. ID: ${data.delete_customer_id}`);

        // Redirect the user to the updated customers page
        res.redirect('/customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Route to delete an address
app.post('/addresses/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Create and execute the query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query = `CALL sp_DeleteAddress(?);`;
        await db.query(query, [data.delete_address_id]);

        console.log(`DELETE sale. ID: ${data.delete_address_id}`);

        // Redirect the user to the updated address page
        res.redirect('/addresses');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//Route to delete a vendor
app.post('/vendors/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Create and execute the query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query = `CALL sp_DeleteVendor(?);`;
        await db.query(query, [data.delete_vendor_id]);

        console.log(`DELETE sale. ID: ${data.delete_vendor_id}`);

        // Redirect the user to the updated address page
        res.redirect('/vendors');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// CREATE ROUTES
// Route to create a product
app.post('/manage-products', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Cleanse data
        if (isNaN(parseFloat(data.create_product_price))) {
            data.create_product_price = null; // Ensure price is a number
        }
        if (isNaN(parseFloat(data.create_product_sales_price))) {
            data.create_product_sales_price = null; // Ensure sales price is a number
        }
        if (isNaN(parseInt(data.create_product_type_id))) {
            data.create_product_type_id = null; // Ensure product type ID is a number
        }

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query5 = `CALL sp_InsertProduct(?, ?, ?, ?, ?);`;

        // Store ID of last inserted row
        const result = await db.query(query5, [
        data.create_product_name,
        data.create_product_price,
        data.create_product_sales_price,
        data.create_product_type_id,
        data.create_vendor_id
        ]);
        console.log("Query Result:", result);
        const rows = result[0];




        console.log(`CREATE Products. ID: ${rows.new_id} ` +
            `Name: ${data.create_product_name}, ` + 
            `Price: ${data.create_product_price}, ` +
            `Sales Price: ${data.create_product_sales_price}, ` +
            `Product Type ID: ${data.create_product_type_id}, ` +
            `Vendor ID: ${data.create_vendor_id}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/products');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//Route to create a sale
app.post('/manage-sales', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Cleanse data to ensure valid inputs
        if (isNaN(parseInt(data.create_customer_id))) {
            data.create_customer_id = null; // Ensure customer ID is a valid number
        }
        if (isNaN(parseFloat(data.create_sale_amount))) {
            data.create_sale_amount = null; // Ensure sale amount is a valid number
        }
        if (!data.create_sale_date || isNaN(new Date(data.create_sale_date).getTime())) {
            data.create_sale_date = null; // Ensure sale date is valid
        }
        if (isNaN(parseInt(data.create_product_id))) {
            data.create_product_id = null; // Ensure product ID is a valid number
        }
        if (isNaN(parseInt(data.create_quantity))) {
            data.create_quantity = null; // Ensure quantity is a number
        }
        if (isNaN(parseFloat(data.create_price))) {
            data.create_price = null; // Ensure price is a valid number
        }

        // Create and execute the procedure call
        // Using parameterized queries to prevent SQL injection attacks
        const query = `CALL sp_InsertSale(?, ?, ?, ?, ?, ?, ?);`;

        // Call the procedure with the provided data
        const result = await db.query(query, [
            data.create_customer_id,       // Customer ID
            data.create_sale_date,         // Sale date
            data.create_transaction_type,  // Transaction type
            data.create_sale_amount,       // Sale amount
            data.create_product_id,        // Product ID
            data.create_quantity,          // Quantity
            data.create_price              // Product price
        ]);
        console.log("Query Result:", result);
        const rows = result[0];

        console.log(`CREATE Sale. ID: ${rows.new_id} ` +
            `Customer ID: ${data.create_customer_id}, ` +
            `Sale Date: ${data.create_sale_date}, ` +
            `Transaction Type: ${data.create_transaction_type}, ` +
            `Sale Amount: ${data.create_sale_amount}, ` +
            `Product ID: ${data.create_product_id}, ` +
            `Quantity: ${data.create_quantity}, ` +
            `Price: ${data.create_price}`
        );

        // Redirect the user to the updated sales management page
        res.redirect('/sales');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//Route to create a customer
app.post('/manage-customers', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Cleanse data to ensure valid inputs
        if (!data.create_customer_name || typeof data.create_customer_name !== 'string') {
            data.create_customer_name = null; // Ensure customer name is a valid string
        }
        if (!data.create_customer_email || typeof data.create_customer_email !== 'string') {
            data.create_customer_email = null; // Ensure email is a valid string
        }
        if (!data.create_customer_phone || typeof data.create_customer_phone !== 'string') {
            data.create_customer_phone = null; // Ensure phone number is a valid string
        }
        if (isNaN(parseFloat(data.create_customer_account_value))) {
            data.create_customer_account_value = null; // Ensure account value is a valid number
        }

        // Create and execute the procedure call
        // Using parameterized query to prevent SQL injection attacks
        const query = `CALL sp_InsertCustomer(?, ?, ?, ?);`;

        // Execute the procedure with the provided data
        const result = await db.query(query, [
            data.create_customer_name,      // Customer Name
            data.create_customer_email,     // Email
            data.create_customer_phone,     // Phone Number
            data.create_customer_account_value // Account Value
        ]);

        console.log("Query Result:", result);
        const rows = result[0];

        console.log(`CREATE Customer. Name: ${data.create_customer_name}, ` +
            `Email: ${data.create_customer_email}, ` +
            `Phone Number: ${data.create_customer_phone}, ` +
            `Account Value: ${data.create_customer_account_value}`);

        // Redirect the user to the updated customers page
        res.redirect('/customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the client
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Route create an address
app.post('/manage-addresses', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Cleanse data to ensure valid inputs
        if (!data.create_address_line_1 || typeof data.create_address_line_1 !== 'string') {
            data.create_address_line_1 = null; // Ensure address is a valid string
        }
        if (!data.create_city || typeof data.create_city !== 'string') {
            data.create_city = null; // Ensure city is a valid string
        }
        if (!data.create_state || typeof data.create_state !== 'string') {
            data.create_state = null; // Ensure state is a valid string
        }
        if (!data.create_postal_code || typeof data.create_postal_code !== 'string') {
            data.create_postal_code = null; // Ensure postal code is a valid string
        }

        // Create and execute the procedure call
        // Using parameterized query to prevent SQL injection attacks
        const query = `CALL sp_InsertAddress(?, ?, ?, ?);`;

        // Execute the procedure with the provided data
        const result = await db.query(query, [
            data.create_address_line_1,      // Address Line 1
            data.create_city,     // City
            data.create_state,     // State
            data.create_postal_code // Postal Code
        ]);

        console.log("Query Result:", result);
        const rows = result[0];

        console.log(`CREATE Address. Address Line 1: ${data.create_address_line_1}, ` +
            `City: ${data.create_city}, ` +
            `State: ${data.create_state}, ` +
            `Postal Code: ${data.create_postal_code}`);

        // Redirect the user to the updated customers page
        res.redirect('/addresses');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the client
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//Route to create a vendor
app.post('/manage-vendors', async function (req, res) {
    try {
        // Parse form data from the frontend
        let data = req.body;
        console.log('Request body:', req.body);

        // Cleanse data to ensure valid inputs
        if (!data.create_vendor_name || typeof data.create_vendor_name !== 'string') {
            data.create_vendor_name = null; // Ensure vendor name is a valid string
        }
        if (!data.create_vendor_email || typeof data.create_vendor_email !== 'string') {
            data.create_vendor_email = null; // Ensure email is a valid string
        }
        if (!data.create_vendor_phone || typeof data.create_vendor_phone !== 'string') {
            data.create_vendor_phone = null; // Ensure phone number is a valid string
        }
        if (isNaN(parseInt(data.addressID))) {
            data.addressID = null; // Ensure addressID is a valid integer
        }
        if (isNaN(parseFloat(data.create_vendor_ap))) {
            data.create_vendor_ap = null; // Ensure accounts payable is a valid number
        }

        // Create and execute the procedure call
        // Use parameterized query to prevent SQL injection
        const query = `CALL sp_InsertVendor(?, ?, ?, ?, ?);`;

        // Execute the query with the provided form data
        const result = await db.query(query, [
            data.create_vendor_name,      // Vendor Name
            data.create_vendor_email,     // Email
            data.create_vendor_phone,     // Phone Number
            data.addressID,               // Address ID
            data.create_vendor_ap         // Accounts Payable
        ]);

        console.log("Query Result:", result);

        console.log(`CREATE Vendor. 
            Name: ${data.create_vendor_name}, 
            Email: ${data.create_vendor_email}, 
            Phone: ${data.create_vendor_phone}, 
            Address ID: ${data.addressID}, 
            Accounts Payable: ${data.create_vendor_ap}`
        );

        // Redirect the user to the updated vendors page
        res.redirect('/vendors');
    } catch (error) {
        console.error('Error executing the database query:', error);
        // Send a generic error message to the client
        res.status(500).send('An error occurred while creating the vendor.');
    }
});



// UPDATE ROUTES
// Route to update a product
app.post('/update-products', async function (req, res) {
    try {
        // Parse form data from the request
        const data = req.body;

        // Ensure all fields are casted correctly or set to null if invalid
        if (!data.update_product_name || data.update_product_name.trim() === '') {
            data.update_product_name = null; // Use `null` if name is empty
        }
        if (isNaN(parseFloat(data.update_product_price))) {
            data.update_product_price = null; // Ensure price is a valid number or `null`
        }
        if (isNaN(parseFloat(data.update_product_sales_price))) {
            data.update_product_sales_price = null; // Ensure sales price is valid or `null`
        }
        if (isNaN(parseInt(data.update_product_type_id, 10))) {
            data.update_product_type_id = null; // Ensure type ID is valid or `null`
        }
        if (isNaN(parseInt(data.update_vendor_id, 10))) {
            data.update_vendor_id = null; // Ensure vendor ID is valid or `null`
        }

        // Validate the required `update_product_id` (must always exist)
        if (!data.update_product_id || isNaN(parseInt(data.update_product_id, 10))) {
            throw new Error('Invalid product ID provided');
        }

        // The query to call the stored procedure
        const query1 = 'CALL sp_UpdateProduct(?, ?, ?, ?, ?, ?);';

        // Execute the query with six arguments
        await db.query(query1, [
            data.update_product_id,
            data.update_product_name,
            data.update_product_price,
            data.update_product_sales_price,
            data.update_product_type_id,
            data.update_vendor_id
        ]);

        // Redirect after the update
        res.redirect('/products');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred while executing the update.');
    }
});

// Route to update a sale
app.post('/update-sales', async function (req, res) {
    try {
        // Parse form data from the request
        const data = req.body;

        // Ensure all fields are cast correctly or set to null if invalid
        if (!data.update_customer_id || isNaN(parseInt(data.update_customer_id, 10))) {
            data.update_customer_id = null;
        }
        if (!data.update_sale_date || data.update_sale_date.trim() === '') {
            data.update_sale_date = null;
        }
        if (!data.update_transaction_type || data.update_transaction_type.trim() === '') {
            data.update_transaction_type = null;
        }
        if (isNaN(parseFloat(data.update_sale_amount))) {
            data.update_sale_amount = null;
        }
        if (isNaN(parseInt(data.update_product_id, 10))) {
            data.update_product_id = null;
        }
        if (isNaN(parseInt(data.update_quantity, 10))) {
            data.update_quantity = null;
        }
        if (isNaN(parseFloat(data.update_price))) {
            data.update_price = null;
        }

        // Validate the required `update_sale_id` (must always exist)
        if (!data.update_sale_id || isNaN(parseInt(data.update_sale_id, 10))) {
            throw new Error('Invalid sale ID provided');
        }

        // The query to call the stored procedure
        const query = 'CALL sp_UpdateSale(?, ?, ?, ?, ?, ?, ?, ?);';

        // Execute the query with the eight arguments
        await db.query(query, [
            data.update_sale_id,
            data.update_customer_id,
            data.update_sale_date,
            data.update_transaction_type,
            data.update_sale_amount,
            data.update_product_id,
            data.update_quantity,
            data.update_price
        ]);

        // Redirect after the update
        res.redirect('/sales');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred while updating the sale.');
    }
});

// Route to update an address
app.post('/update-addresses', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);
        if (!data.addressLine1 || !data.addressLine1.trim()) {
        data.addressLine1 = null;
        } else {
        data.addressLine1 = data.addressLine1.trim(); // Trim leading/trailing spaces
        }

        if (!data.city || !data.city.trim()) {
            data.city = null;
        } else {
            data.city = data.city.trim();
        }

        if (!data.state || !data.state.trim()) {
            data.state = null;
        } else {
            data.state = data.state.trim();
        }

        if (!data.postalCode || !data.postalCode.trim()) {
            data.postalCode = null;
        } else {
            data.postalCode = data.postalCode.trim();
        }
        // Create and execute the procedure call
        // Using parameterized query to prevent SQL injection attacks
        const query = `CALL sp_UpdateAddress(?, ?, ?, ?, ?);`;

        // Execute the procedure with the provided data
        const result = await db.query(query, [
            data.addressID,         // ID for the address to be updated
            data.addressLine1,      // Address line 1
            data.city,              // City
            data.state,             // State
            data.postalCode         // Postal Code
        ]);


        console.log("Query Result:", result);
        const rows = result[0];

        console.log(`CREATE Address. Address Line 1: ${data.create_address_line_1}, ` +
            `City: ${data.create_city}, ` +
            `State: ${data.create_state}, ` +
            `Postal Code: ${data.create_postal_code}`);

        // Redirect the user to the updated customers page
        res.redirect('/addresses');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the client
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Route to update a customer
app.post('/update-customer', async function (req, res) {
    try {
        // Parse form data from the request
        const data = req.body;

        // Variables to store validated and sanitized values
        let customerID = null;
        let customerName = null;
        let email = null;
        let phoneNumber = null;
        let accountValue = null;

        // Validate and parse "customerID" (required field)
        if (!data.customerID || isNaN(parseInt(data.customerID, 10))) {
            throw new Error('Invalid or missing customer ID provided.');
        } else {
            customerID = parseInt(data.customerID, 10); // Convert to an integer
        }

        // Validate and sanitize "customerName" (optional field)
        if (data.customerName && data.customerName.trim() !== '') {
            customerName = data.customerName.trim(); // Use the trimmed customer name
        }

        // Validate and sanitize "email" (optional field)
        if (data.email && data.email.trim() !== '') {
            email = data.email.trim(); // Use email if it's not empty
        }

        // Validate and sanitize "phoneNumber" (optional field)
        if (data.phoneNumber && data.phoneNumber.trim() !== '') {
            phoneNumber = data.phoneNumber.trim(); // Use phone number if it's not empty
        }

        // Validate and sanitize "accountValue" (optional field)
        if (data.accountValue && !isNaN(parseFloat(data.accountValue))) {
            accountValue = parseFloat(data.accountValue); // Convert to float
        }

        // Query to call the stored procedure
        const query = 'CALL sp_UpdateCustomer(?, ?, ?, ?, ?);';

        // Execute the query with all arguments
        await db.query(query, [
            customerID,     // Required customer ID
            customerName,   // Optional customer name
            email,          // Optional email
            phoneNumber,    // Optional phone number
            accountValue    // Optional account value
        ]);

        // Redirect after successful update
        res.redirect('/customers');
    } catch (error) {
        console.error('Error updating customer:', error);
        res.status(500).send('An error occurred while updating the customer.');
    }
});

// Route to update a vendor
app.post('/update-vendors', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log('Request body:', req.body);

        // Validate and sanitize input data
        if (!data.vendorID || isNaN(parseInt(data.vendorID))) {
            return res.status(400).send('Invalid vendorID for update.');
        }
        if (!data.update_vendor_email || typeof data.update_vendor_email !== 'string') {
            data.update_vendor_email = null; // Ensure email is a valid string
        }
        if (!data.update_vendor_phone || typeof data.update_vendor_phone !== 'string') {
            data.update_vendor_phone = null; // Ensure phone number is a valid string
        }
        if (!data.update_vendor_addressID || isNaN(parseInt(data.update_vendor_addressID))) {
            data.update_vendor_addressID = null; // Ensure addressID is a valid integer
        }
        if (isNaN(parseFloat(data.update_vendor_ap))) {
            data.update_vendor_ap = null; // Ensure accounts payable is a valid number
        }

        // Create and execute the procedure call
        // Using parameterized query to prevent SQL injection
        const query = `CALL sp_UpdateVendor(?, ?, ?, ?, ?, ?);`;

        // Execute the procedure with the provided data
        const result = await db.query(query, [
            data.vendorID,                 // Vendor ID
            null,                          // Vendor Name (no field for name update from the form)
            data.update_vendor_email,      // Email
            data.update_vendor_phone,      // Phone Number
            data.update_vendor_addressID,  // Address ID
            data.update_vendor_ap          // Accounts Payable
        ]);

        console.log("Query Result:", result);
        const rows = result[0];

        console.log(`UPDATED Vendor. Vendor ID: ${data.vendorID}, ` +
            `Email: ${data.update_vendor_email}, ` +
            `Phone: ${data.update_vendor_phone}, ` +
            `Address ID: ${data.update_vendor_addressID}, ` +
            `Accounts Payable: ${data.update_vendor_ap}`);

        // Redirect the user to the updated vendors page
        res.redirect('/vendors');
    } catch (error) {
        console.error('Error executing database query:', error);
        // Send a generic error message to the client
        res.status(500).send(
            'An error occurred while updating the vendor.'
        );
    }
});



// RESET ROUTE
// Route to reset the entire database back to the original state
app.get('/reset-database', async function (req, res) {
    try {
        await db.query('CALL sp_ResetDatabase();');
        console.log("Database reset to its original state.");
        res.send(`
            <html>
                <head>
                    <title>Reset Successful</title>
                    <script>
                        alert('Database reset successful!');
                        window.location.href = '/';
                    </script>
                </head>
                <body>
                    <p>Reset successful. Redirecting to home...</p>
                </body>
            </html>
        `);
    } catch (error) {
        console.error('Error executing reset procedure:', error);
        res.status(500).send('An error occurred while resetting the database.');
    }
});

// ########################################
// ########## LISTENER
// Express
// 1 # Citation For The Following Function:
// 2 # Date:06/05/2025
// 3 # Copied from
// 4 # Based on the class starter code given
// 5 # SourceURL:https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
})
    