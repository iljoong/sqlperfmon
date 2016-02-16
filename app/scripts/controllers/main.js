'use strict';

/**
 * @ngdoc function
 * @name sqlmonAppApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the sqlmonAppApp
 */
angular.module('sqlmonAppApp')
  .controller('MainCtrl', ['$scope', 'adalAuthenticationService', '$location', function ($scope, adalProvider, $location) {
    this.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    
    $scope.loginUser = function() {
        // ADAL automatically adds 'access_token' in http header after successfully logged in
        adalProvider.login();
    };
    
    $scope.logoutUser = function() {
        adalProvider.logOut();   
    };
    
    $scope.isActive = function (viewLocation) {        
        return viewLocation === $location.path();
    };
  }]);
