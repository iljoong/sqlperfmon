 var adal_config = {
            instance: 'https://login.microsoftonline.com/',
            tenant: 'ilkimorg.onmicrosoft.com',
            clientId: 'db650a98-f802-46f5-b5a9-e39422fd3365',
            extraQueryParameter: 'nux=1',
            //cacheLocation: 'localStorage', // enable this for IE, as sessionStorage does not work for localhost.
        };
        
module.exports.adal_config = adal_config;