var myapp = angular.module("myApp", []);
/*myapp.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "main.htm",
        controller  : 'mainController'
    })
    .when("/retailer", {
        templateUrl : "retailer.htm",
        controller  : 'retailerController'
    })
    .when("/supplier", {
        templateUrl : "supplier.htm",
        controller: 'supplierController'
    });
    
});*/



myapp.controller('retailerController', function($scope) {
    $scope.items = ["item1", "item2", "item3","item11"];



    $scope.itemDetails = [
        
        {
            'item':'123',
            'supplier1':'Mai',
            'supplier2':'tu'
        }];
    
        $scope.addNew = function(itemDetail){
            $scope.itemDetails.push({ 
                'item': "", 
                'supplier1': "",
                'supplier2': "",
            });
        };
    
        $scope.remove = function(){
            var newDataList=[];
            $scope.selectedAll = false;
            angular.forEach($scope.itemDetails, function(selected){
                if(!selected.selected){
                    newDataList.push(selected);
                }
            }); 
            $scope.itemDetails = newDataList;
        };
    
    $scope.checkAll = function () {
        if (!$scope.selectedAll) {
            $scope.selectedAll = true;
        } else {
            $scope.selectedAll = false;
        }
        angular.forEach($scope.itemDetails, function(itemDetail) {
            itemDetail.selected = $scope.selectedAll;
        });
    };    
    





});











/*nRows=0;
function addRow()
{


   //alert("xc");


    nRows++;


   // alert(document.getElementById("item"));
   var item = document.getElementById("item").value;

  alert(item);

   var  tr= document.createElement("tr");
   var td1=document.CreateElement("label");
   var td2=document.CreateElement("input");
   var td3=document.CreateElement("label");
   var td4=document.CreateElement("input");
   var td5=document.CreateElement("label");
   var td6=document.CreateElement("input");

alert("fd");

   td4.name = "s1quantity" + nRows;
   td6.name = "s2quantity" + nRows;
   td2.name = "item" + nRows;


    td1.innerHTML= "Item" + nRows ;

   td3.innerHTML = "Supplier 1";

   td5.innerHTML = "Supplier 2";

   td2.type= "text";
   td2.value= item;
   td4.type="number";
   td6.type = "number";

    alert("fd");



   var t1= document.createElement("td");
   var t2= document.createElement("td");
   var t3= document.createElement("td");
   var t4= document.createElement("td");
   var t5= document.createElement("td");
   var t6= document.createElement("td");

   t1.appendChild(td1);
   t2.appendChild(td2);
   t3.appendChild(td3);
   t4.appendChild(td4);
   t5.appendChild(td5);
   t6.appendChild(td6);

   tr.appendChild(t1);
   tr.appendChild(t2);
   tr.appendChild(t3);
   tr.appendChild(t4);
   tr.appendChild(t5);
   tr.appendChild(t6);




  

}*/