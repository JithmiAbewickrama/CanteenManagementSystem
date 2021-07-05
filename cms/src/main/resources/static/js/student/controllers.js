'use strict';
/* Controllers */
var AppControllers = angular.module('AppControllers', []);

AppControllers.controller('AdminCtrl',
        function AdminCtrl($scope, $location, StudentResources,StudentService) {

            StudentResources.get({querytype: 'studentdetails'}, function (response) {
                console.log(response.data);
                $scope.student = response.data;
                StudentService.setDetails(response.data);

            });
            
            $scope.menu = [{name: 'Current Month', link: 'currentmonth'},
                {name: 'Previous Months', link: 'prevmonths'}, {name: 'Forum', link: 'forum'},
                {name: 'Rate Mess', link: 'ratemess'}, {name: 'Log Out', link: 'logout'}];
            
            $scope.current = "";

            $scope.navigate = function (link) {
                $scope.current = link;
                if (link == 'logout') {
                    location.href = "./logout.php";
                }
                $location.path(link);
            }
        }
);

