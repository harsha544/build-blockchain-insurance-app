var express = require('express');
var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');
var http = require("http");
var bodyParser = require('body-parser');
var path = require('path')
var router = express.Router();
var app = express();
oracledb.autoCommit = true;


var fs = require("fs");

//app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));


const cors = require('cors')

var corsOptions = [{
  origin: 'https://ajax.googleapis.com',
  optionsSuccessStatus: 200 
},
{origin: 'https://fonts.googleapis.com',
  optionsSuccessStatus: 200 },
{origin: 'https://maxcdn.bootstrapcdn.com',
  optionsSuccessStatus: 200 }

];




app.use(cors(corsOptions))

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get('/',function(req,res)
{
    //res.sendfile('index.html');
    res.sendFile(path.join(__dirname+'/create_order.html'));

});

app.get('/getpomaster',function(req,res){
	
	console.log("here");
	
	oracledb.getConnection(
			  {
			    user          : dbConfig.user,
			    password      : dbConfig.password,
			    connectString : dbConfig.connectString
			  },
			  function(err, connection) {
			    if (err) {
			      console.error(err.message);
			      return;
			    }
			    
			    connection.execute(
					      // The statement to execute
					      `SELECT * FROM PO_MASTER`,

					      // The callback function handles the SQL execution results
					      function(err, result) {
					        if (err) {
					          console.error(err.message);
					          //doRelease(connection);
					          return;
					        }
					        console.log(result.metaData); 
					        console.log(result.rows); 
					        var headers = result.metaData ;
					        var op = result.rows;
					        var obj = [];
					        
					        
					        for (var i = 0;i < op.length; i++) {
					            //objs.push(: rows[i].username
					        	for(var j = 0; j < headers.length;j++)
					        		{
					        		//obj.push({headers[j]:op[i][j]});
					        		console.log(headers[i]);
					        		console.log(op[i][j]);
					        		
					        		}
					        	
					        	
					        }
					        console.log(JSON.stringify(obj));
					        res.send(JSON.stringify(obj));

					      });

			  });
			  
});



//module.exports = router;
var server=app.listen(8085,function() {});

