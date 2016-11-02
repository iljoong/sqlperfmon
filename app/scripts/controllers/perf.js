'use strict';

var sqldbapiurl = "<api url>";

angular.module('sqlmonAppApp')
  .controller('PerfCtrl',['$scope', '$http', '$interval', 'adalAuthenticationService', '$filter',
  function ($scope, $http, $interval, adalProvider, $filter) {
   
      $scope.init = function () {
          
          $http.get(sqldbapiurl + '/api/perf')
              .success(function (recordset, status, headers, config) {
                  console.log(".../api/perf");


                  var labels = [];
                  var data = [[]]; data[0] = [], data[1] = [] , data[2] = [];
                  var data1 = [[]]; data1[0] = [], data1[1] = [] , data1[2] = [];
                                    
                  // get top 60 items                 
                  for (var i = 0; i < recordset.length && i < 60; i++) {

                      labels.push( $filter('date')(recordset[i].timestamp, 'yyyy-MM-dd', '+0900') );
                      data[0].push(recordset[i].davg_avg_cpu_percent);
                      data[1].push(recordset[i].davg_max_session_percent);
                      data[2].push(recordset[i].davg_max_worker_percent);

                      data1[0].push(recordset[i].dmax_avg_cpu_percent);
                      data1[1].push(recordset[i].dmax_max_session_percent);
                      data1[2].push(recordset[i].dmax_max_worker_percent);
                  }
           
                  $scope.labels = labels;
                  $scope.series = ['davg_avg_cpu_percent', 'davg_max_session_percent', 'davg_max_worker_percent'];
                  $scope.data = data;

                  $scope.labels1 = labels;                  
                  $scope.series1= ['dmax_avg_cpu_percent', 'dmax_max_session_percent', 'dmax_max_worker_percent'];
                  $scope.data1 = data1;
                  
                 
              }).error(function (data, status, headers, config) {
                  console.log(data);
              });

          
          $scope.onClick = function (points, evt) {
              console.log(points, evt);
          };
          
          $scope.refreshData = function () {
              console.log("refreshed...");
              $scope.labels = null;
              $scope.series = null;
              $scope.data = null;
              $scope.init();
          };

      };
                
      $scope.init();
  }]);
