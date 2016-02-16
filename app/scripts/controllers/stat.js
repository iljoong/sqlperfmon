'use strict';

/**
 * @ngdoc function
 * @name angAppApp.controller:ChartCtrl
 * @description
 * # ChartCtrl
 * Controller of the angAppApp
 */
var sqldbapiurl = "https://azsqlmon.ilkimase.p.azurewebsites.net";

/*
[
    {
        "end_time": "2016-02-05T06:14:15.790Z",
        "avg_cpu_percent": 0,
        "avg_data_io_percent": 0,
        "avg_log_write_percent": 0,
        "avg_memory_usage_percent": 5.54,
        "xtp_storage_percent": 0,
        "max_worker_percent": 0,
        "max_session_percent": 0,
        "dtu_limit": 5
    },
    ...
*/

angular.module('sqlmonAppApp')
  .controller('StatCtrl',['$scope', '$http', '$interval', 'adalAuthenticationService', '$filter',
  function ($scope, $http, $interval, adalProvider, $filter) {
   
      $scope.init = function () {
          
          $http.get(sqldbapiurl + '/api/stat')
              .success(function (recordset, status, headers, config) {
                  console.log(".../api/stat");

                  var labels = [];
                  var labels0 = [];
                  var data1 = [[]]; data1[0] = [];                 
                  var data2 = [[]]; data2[0] = [];
                  var data3 = [[]]; data3[0] = [];
                  var data4 = [[]]; data4[0] = [];
                  var data5 = [[]]; data5[0] = [];
                  
                  // get top 60 items                 
                  for (var i = 0; i < 60; i++) {
                      if (i % 4 == 0) {
                          labels.push($filter('date')(recordset[i].end_time, 'HH:mm:ss', '+0900') );
                      }
                      else {
                          labels.push('');
                      }
                      labels0.push('');
                      data1[0].push(recordset[i].avg_cpu_percent);
                      data2[0].push(recordset[i].avg_memory_usage_percent);
                      data3[0].push(recordset[i].avg_data_io_percent);
                      data4[0].push(recordset[i].max_session_percent);
                      data5[0].push(recordset[i].max_worker_percent);
                  }
               
                  /*recordset.forEach(function (element) {
                      labels.push(element.end_time);
                      data[0].push(element.avg_cpu_percent);
                      //data[1].push(element.avg_data_io_percent);
                      //data[2].push(element.avg_memory_usage_percent);


                  }, this);*/
            
                  $scope.labels = labels;
                  $scope.series = ['avg_cpu_percent'];
                  $scope.data = data1;
                  
                  $scope.labels0 = labels0;
                  $scope.series2 =  ['avg_memory_usage_percent'];
                  $scope.data2 = data2;
                  
                  $scope.labels0 = labels0;
                  $scope.series3 =  ['avg_data_io_percent'];
                  $scope.data3 = data3;

                  $scope.labels0 = labels0;
                  $scope.series4 =  ['max_session_percent'];
                  $scope.data4 = data4;

                  $scope.labels0 = labels0;
                  $scope.series5 =  ['max_worker_percent'];
                  $scope.data5 = data5;
                                    
                  //console.log(JSON.stringify(labels));
                  //console.log(JSON.stringify(data));
                 
              }).error(function (data, status, headers, config) {
                  console.log(data);
              });

         
          /*
          $scope.labels = ["January", "February", "March", "April", "May", "June", "July"];
          $scope.series = ['Series A', 'Series B'];
          $scope.data = [
              [65, 59, 80, 81, 56, 55, 40],
              [28, 48, 40, 19, 86, 27, 90]
          ];
          /**/
          
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
      
      var stopTime = null;
      $scope.setAuto = function () {
          $scope.autoref = !$scope.autoref;
          console.log($scope.autoref);

          if ($scope.autoref)
            stopTime = $interval(updateTime, 15000);
          else
            $interval.cancel(stopTime);
      }
      
      function updateTime() {
          $scope.init();
      }
      
      $scope.init();
  }]);
