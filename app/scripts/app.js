'use strict';

/**
 * @ngdoc overview
 * @name sqlmonAppApp
 * @description
 * # sqlmonAppApp
 *
 * Main module of the application.
 */

angular
  .module('sqlmonAppApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'AdalAngular',
    'chart.js',
    'aadconfig' // config.js
  ])
  .config(['$routeProvider', '$httpProvider', 'adalAuthenticationServiceProvider', 'ChartJsProvider', 'AAD_CONFIG',
    function ($routeProvider, $httpProvider, adalProvider, ChartJsProvider, aad_config ) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl',
        controllerAs: 'main'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutCtrl',
        controllerAs: 'about'
      })
      .when('/stat', {
        templateUrl: 'views/stat.html',
        controller: 'StatCtrl',
      })
      .when('/perf', {
        templateUrl: 'views/perf.html',
        controller: 'PerfCtrl',
      })
      .when('/mon', {
        templateUrl: 'views/mon.html',
        controller: 'MonCtrl',
      })
      .otherwise({
        redirectTo: '/'
      });
      
    adalProvider.init(
        aad_config,
        $httpProvider
        );

    ChartJsProvider.setOptions({
        colours: ['#97BBCD', '#DCDCDC', '#F7464A', '#46BFBD', '#FDB45C', '#949FB1', '#4D5360'],
        responsive: true,
        showTooltips: false,
        animation: true
    }); 

  }]);
