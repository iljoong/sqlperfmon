//
// stat.js: get perf stat from sys.dm_db_resource_stats
//
var sql = require('mssql');

// get connection string from app settings
var config = require('./config.js');

module.exports = {

    "get": function (req, res, next) {

        sql.connect(config, function (err) {
            var mssql = new sql.Request();

            console.log('connection success');
            var cmd = "SELECT * FROM sys.dm_db_resource_stats";
    
            //console.log(sql);
    
            mssql.query(cmd, function (err, recordset) {
                if (err) {
                    console.log(err);
                }
                else {
                    res.set('Content-Type', 'application/json');
                    res.status('200').send(recordset);
                }
            });
        });
    }
};