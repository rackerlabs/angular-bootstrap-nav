angular.module("bootstrap.navbar", ['ngRoute', 'ngSanitize'])
.controller('NavCtr', [
  "$scope"
  "$location"
  "$route"
  NavCtr = ($scope, $location, $route) ->

    $scope.navClass = (page) ->
      currentRoute = $location.path().substring(1).split("/")[0]
      (if page is currentRoute then "active" else "")

    $scope.routes = []
    angular.forEach $route.routes, (value) ->
      if value.navitem
        routeitem = {}
        routeitem.path = value.originalPath
        routeitem.name = value.name
        routeitem.templateUrl = value.templateUrl
        routeitem.controller = value.controller
        $scope.routes.push routeitem

    $scope.type = (type) ->
      if type != undefined
        "select"
      else
        "button"

    $scope.isCollapsed = true
])
.directive("bootstrapNav", ->
  "use strict"
  restrict: "AE"
  replace: true
  transclude: false
  scope:
    'titleLink': '@?',
    'title': "@?",
    'logo': '=?',
    'searchInput': '=?',
    'searchSelect': '=?'
    'searchButton': '=?'
  controller: 'NavCtr'
  templateUrl: 'angular-bootstrap-nav.html'
)
