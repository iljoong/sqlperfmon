# SQLPerfMon

SQLPerMon is a performance monitoring sample app for Azure SQL Database

It has 3 dashboards:

* Stat: Performance stats of last 60 mins (source form `master.sys.resource_stats`)
* Perf: Daily performance stats (source from `database.sys.dm_db_resource_stats`) 
* Mon: Daily SLO & scale recommnedation (refer https://azure.microsoft.com/en-us/documentation/articles/sql-database-performance-guidance/)

Note: 

* Data for 'Perf' and 'Mon' are generated via Azure Automation and can be accessed by API app.
* API app is protected by Azure AD and can be accessed with right credential.

![SQLMonWeb](/doc/pix/azsqlmonweb01.png)

* Angularjs based Web App on Azure
* This project is generated with [yo angular generator](https://github.com/yeoman/generator-angular)
version 0.15.1.

## How to setup

1. [Setup Automation](/doc/1_Automation_PS/README.md)
2. [Setup AAD](/doc/2_AAD/README.md)
3. [Setup API app](/doc/3_EasyAPI/README.md)


## Build

* ` npm install `
* ` bower install `
* ` grunt build `

## Test Run

* ` grunt serve `

## Publish to Azure

* ` grunt publish `

## Terms & Conditions
* MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE


