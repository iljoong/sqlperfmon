//
// config.js : parse sql connection config from SQLCONNSTR_MS_TableConnectionString
//
var conString = require('../node_modules/azure-mobile-apps/src/configuration/connectionString.js');

var config = conString.parse(process.env.SQLAZURECONNSTR_MS_TableConnectionString);

console.log(JSON.stringify(config));
module.exports = config;