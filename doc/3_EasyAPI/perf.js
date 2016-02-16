//
// perf.js : get daily perf stat from sqldbstat table
//
var sql = require('mssql');

// get connection string from app settings
var config = require('./config.js');

var mssql;
sql.connect(config, function (err) {
    mssql = new sql.Request();

    console.log('connection success');
});

module.exports = {

    "get": function(req, res, next) {
        var sql = "SELECT TOP 10 * FROM sqldbstat ORDER BY [timestamp] DESC";
    
        //console.log(sql);
    
        mssql.query(sql, function (err, recordset) {
        if (err) {
           console.log(err);
        }
        else {
           res.set('Content-Type', 'application/json');
           res.status('200').send(recordset);
            }
        });     
    }
};
