'use strict';

var sqldbapiurl = "https://azsqlmon.ilkimase.p.azurewebsites.net";

angular.module('sqlmonAppApp')
  .controller('MonCtrl',['$scope', '$http', 'adalAuthenticationService', '$filter',
  function ($scope, $http, adalProvider, $filter) {
   
      $scope.init = function () {
          
          $http.get(sqldbapiurl + '/api/mon')
              .success(function (recordset, status, headers, config) {
                  console.log(".../api/mon");
                  
                  $scope.data = recordset
                 
              }).error(function (data, status, headers, config) {
                  console.log(data);
              });
          
      };  
      
      $scope.getRecommend = function(down_1, down_2, down_3, up_1, up_2, up_3) {
          if (up_1 < 0.999 || up_2 < 0.999 || up_3 < 0.999)
            return 'Up';
          else if (down_1 > 0.999 || down_2 > 0.999 || down_3 > 0.999)
            return 'Down';
          else
            return 'Stay'; 
      }   
     
      $scope.init();
  }]);
