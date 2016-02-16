// AAD Config
var _config = {
            instance: 'https://login.microsoftonline.com/',
            tenant: '<tenant name>',
            clientId: '<client id>',
            //extraQueryParameter: 'nux=1',
            //cacheLocation: 'localStorage', // enable this for IE, as sessionStorage does not work for localhost.
        };
        
var aad_config = angular.module('aadconfig', [])
    .constant('AAD_CONFIG', _config);
