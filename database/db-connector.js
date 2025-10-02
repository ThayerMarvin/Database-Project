// 1 # Citation For The Following Function:
// 2 # Date:06/05/2025
// 3 # Copied from
// 4 # Based on the class starter code given
// 5 # SourceURL:https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : 'classmysql.engr.oregonstate.edu',
    user              : 'cs340_kvortekj',
    password          : '9LYZCirftKyP',
    database          : 'cs340_kvortekj'
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool