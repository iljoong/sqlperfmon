//
// mon.js: get scale up/down metrics from sqldbmon
//
var sql = require('mssql');

// get connection string from app settings
var config = require('./config.js');

module.exports = {

    "get": function (req, res, next) {

        sql.connect(config, function (err) {
            
            var mssql = new sql.Request();

            console.log('connection success');
            
            var cmd = "SELECT TOP 50 * FROM sqldbmon ORDER BY [timestamp] DESC";
    
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