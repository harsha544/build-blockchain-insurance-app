var express = require('express');
var app = express();
var fs = require("fs");
var bodyParser = require('body-parser');
var request = require('request-promise');
var getRequest=require('request');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(function(req, res, next) {

  res.header("Access-Control-Allow-Origin", "*");

  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

  next();

});

app.post('/addPO', async function (req, res) {
   // Extract the recieved contents
       //data =  req.body;
       console.log( req.body );
	var data={
		  $class: "org.acme.trading.PO",
		  poId: req.body.poId.toString()+"_"+req.body.itemId.toString(),
 		  status: "Pending",
     		  item_name: req.body.itemId.toString(),
 		  quantity: req.body.quantity,
    		  supplier_names: [req.body.supplier1,req.body.supplier2,req.body.supplier3]

	}
	console.log(data)
	var options = {
        method: 'POST',
        uri: 'http://172.21.3.198:3000/api/PO',
        body: data,
        json: true // Automatically stringifies the body to JSON
    };
    
    var returndata;
    var sendrequest = await request(options)
    .then(function (parsedBody) {
        //console.log(parsedBody); // parsedBody contains the data sent back from the Flask server
        returndata = parsedBody; // do something with this data, here I'm assigning it to a variable.
    })
    .catch(function (err) {
        console.log("Error");
	res.end("Error")
    });
       res.end("Succesfully send data");
})

app.post('/addSupplier', async function (req, res) {
   // Extract the recieved contents
       //data =  req.body;
       //console.log( data );
        var data={
                    "$class": "org.acme.trading.Supplier",
  		    "supplier_name": req.body.supplierId
        }
        console.log(data)
        var options = {
        method: 'POST',
        uri: 'http://172.21.3.198:3000/api/Supplier',
        body: data,
        json: true // Automatically stringifies the body to JSON
    };

    var returndata;
    var sendrequest = await request(options)
    .then(function (parsedBody) {
        //console.log(parsedBody); // parsedBody contains the data sent back from the Flask server
        returndata = parsedBody; // do something with this data, here I'm assigning it to a variable.
    })
    .catch(function (err) {
        console.log("Error");
	res.end("Error")
    });
       res.end("Succesfully send data");
})




app.post('/itemBySupplier', async function (req, res) {
   // Extract the recieved contents
       //data =  req.body;
       //console.log( data );
        var data={
		  "$class": "org.acme.trading.Item_PO_Supplier",
  		  "quantity": req.body.quantity,
  		  "po": "resource:org.acme.trading.PO#"+req.body.poId.toString()+"_"+req.body.itemId.toString(),
  		  "item_name": req.body.itemId.toString(),
                  "supplier_name": "resource:org.acme.trading.Supplier#"+req.body.supplierId.toString()
                    
        }
        console.log(data)
        var options = {
        method: 'POST',
        uri: 'http://172.21.3.198:3000/api/Item_PO_Supplier',
        body: data,
        json: true // Automatically stringifies the body to JSON
    };

    var returndata;
    var sendrequest = await request(options)
    .then(function (parsedBody) {
        //console.log(parsedBody); // parsedBody contains the data sent back from the Flask server
        returndata = parsedBody; // do something with this data, here I'm assigning it to a variable.
    })
    .catch(function (err) {
        console.log("Error");
	res.end("Error");
    });
       res.end("Succesfully send data");
})







app.post('/closePO', async function (req, res) {
   // Extract the recieved contents
       //data =  req.body;
       //console.log( data );
        var data={
		   "$class": "org.acme.trading.ClosePO",
  		    "po": "resource:org.acme.trading.PO#"+req.body.poId.toString()+"_"+req.body.itemId.toString()
        }
        console.log(data)
        var options = {
        method: 'POST',
        uri: 'http://172.21.3.198:3000/api/ClosePO',
        body: data,
        json: true // Automatically stringifies the body to JSON
    };

    var returndata;
    var sendrequest = await request(options)
    .then(function (parsedBody) {
        //console.log(parsedBody); // parsedBody contains the data sent back from the Flask server
        returndata = parsedBody; // do something with this data, here I'm assigning it to a variable.
    })
    .catch(function (err) {
        console.log("Error");
	res.end("Error");
    });
       res.end("Succesfully send data");
})







app.get('/PODetails', async function (req, res) {
   // Extract the recieved contents
       //data =  req.body;
        var options = {
        method: 'GET',
        uri: 'http://172.21.3.198:3000/api/PO',
    };

    var returndata;
    var sendrequest = await request(options)
    .then(function (parsedBody) {
        //console.log(parsedBody); // parsedBody contains the data sent back from the Flask server
        returndata = parsedBody; // do something with this data, here I'm assigning it to a variable.
    })
    .catch(function (err) {
        console.log("Error");
    });
       console.log(returndata)
       res.end(returndata);
})










var server = app.listen(8081, function () {

  var host = server.address().address
  var port = server.address().port
  console.log("Example app listening at http://%s:%s", host, port)

})
