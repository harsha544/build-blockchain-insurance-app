


var express = require('express');
var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');
var http = require("http");
var bodyParser = require('body-parser');
var path = require('path')
var router = express.Router();
var app = express();
oracledb.autoCommit = true;

/*pp.use(function(req, res, next) {

	  res.header("Access-Control-Allow-Origin", "*");

	  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

	  //next();

	}); */


var fs = require("fs");

var doconnect = function(cb) {
	  oracledb.getConnection(
	    {
	      user          : dbConfig.user,
	      password      : dbConfig.password,
	      connectString : dbConfig.connectString
	    },
	    cb);
	};
 


app.use(express.static(path.join(__dirname, 'public')));
//app.use(express.static(path.join(__dirname, 'public')));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get('/',function(req,res)
{
    //res.sendfile('index.html');
    res.sendFile(path.join(__dirname+'/home.html'));

});


app.get('/dummy',function(rq,rs)
		{
				console.log("dummy rendere");
				rs.sendFile(path.join(__dirname+'/dummy.html'));
		});
		

app.get('/create',function(req,res)
{
    //res.sendfile('index.html');
    res.sendFile(path.join(__dirname+'/supplier1.html'));

});


app.get('/search',function(req,res)
{
    //res.sendfile('index.html');
    //console.log(req.ponumber);
    
    res.sendFile(path.join(__dirname+'/search.html'));

    

});






app.post('/', function(request, response){
 
    response.sendFile(path.join(__dirname+'/index.html'));
});






app.post('/submit/po', function(req, res){
  
  var itemDetails = req.body;
  console.log(itemDetails[0].item);
  var cgst =0;
  var sgst = 0;
  var poval=0;
  for (var i=0; i< itemDetails.length;i++)
	  {
	  cgst = itemDetails[i].cgst + cgst;
	  sgst = itemDetails[i].sgst + sgst;
	  poval = itemDetails[i].poval + poval;
	  
	  }
  var totaltax = sgst + cgst;
  
  var po_numbers =  [];
  
   var po_number = 0;
   var po_num=null;
   
  
  
  var sql_query = "INSERT INTO PO_MASTER VALUES (po_seq.nextval , " + poval + ","+ sgst + "," + cgst + " ," + totaltax + "," + " 'PENDING')";  
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
				    sql_query, {},
				    	{autoCommit:true},
				    	function(err, result) {
				        if (err) {
				        	//console.log(po_num);
				          console.error(err.message);
				          //doRelease(connection);
				          return;
				        }
				        console.log("Rows inserted: " + result.rowsAffected);  
				         
				        
				      });
		    
		    
		    




			

			var options = {
			  autoCommit: true,   
			  
			  
			};
			
			var sql_multivalues = "INSERT ALL \n " ;
			
			for (var i = 0; i <itemDetails.length;i++)
			{
		
			sql_multivalues = sql_multivalues + " INTO PO_DETAIL (ITEM , QTY, PO_NUMBER , STATUS) VALUES (  '" + itemDetails[i].item + "' ," + itemDetails[i].quantity +" ," + "po_seq.currval" + "," + " 'PENDING' ) \n";
		
			}
			
			sql_multivalues = sql_multivalues + "SELECT 1 FROM DUAL ";
			console.log(sql_multivalues);
			

			/*connection.execute(sql_multivalues ,{}, options, function (err, result) {
			  if (err)
			    console.error(err + "execute many");
			  else {
			    console.log("Result is:", result);
			  }
			});*/
			
			connection.execute(
				      // The statement to execute
					sql_multivalues, {},
				    	{autoCommit:true},
				    	function(err, result) {
				        if (err) {
				        	//console.log(po_num);
				          console.error(err.message);
				          //doRelease(connection);
				          return;
				        }
				        console.log("Rows inserted: " + result.rowsAffected);  
				         
				        
				      });

			connection.execute(
				      // The statement to execute
					`select po_seq.currval from dual`, {}, {autoCommit:true},
				    	
				    	function(err, result) {
				        if (err) {
				        	//console.log(po_num);
				          console.error(err.message);
				          //doRelease(connection);
				          return;
				        }
				        console.log(result.rows);
				        var str = (result.rows).toString();
				        res.send(str.replace(/[{}]/g, ""));
				        
				      });

		  });

	
  
  //res.sendFile(path.join(__dirname+'/create_order.html'));
  

});


app.post('/getitemlist', function(req, res){
	  
	  //esponse.sendFile(path.join(__dirname+'/index.html'));
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
			      `SELECT item_id FROM item_master`,

			      // The callback function handles the SQL execution results
			      function(err, result) {
			        if (err) {
			          console.error(err.message);
			          //doRelease(connection);
			          return;
			        }
			        console.log(result.metaData); // 
			        console.log(result.rows);     // 
			        //doRelease(connection);
			        res.send(result.rows);
			        //console.log("sent");  
			        
			      });
			  });

			// Note: connections should always be released when not needed
			
	

	});

app.post('/getSupplierId',function(req,res){
	var supplier_name=req.body.name
	var query="SELECT SUPPLIER_ID FROM SUPPLIER_MASTER WHERE SUPPLIER_NAME='"+supplier_name+"'";
	console.log(query)
	        oracledb.getConnection(
                {
                  user  : dbConfig.user,
                  password : dbConfig.password,
                  connectString : dbConfig.connectString
                },
                    function(err, connection) {
                            if (err) {
                              console.error(err.message);
                              return;
                            }
                            connection.execute(
                              // The statement to execute
                              query,

                              // The callback function handles the SQL execution results
                             function(err, result) {
                                if (err) {
                                  console.error(err.message);
                                  //doRelease(connection);
                                  return;
                               }
                                console.log(result.metaData); // [ { name: 'DEPARTMENT_ID' }, { name: 'DEPARTMENT_NAME' } ]
                                console.log(result.rows[0][0]);     // [ [ 180, 'Construction' ] ]
                                //doRelease(connection);
                                res.send(result.rows);
                                //console.log("sent suppliers");

                              });

        });

	

});















app.post('/getSuppliersForItem',function(req,res){
	var supplier_id=req.body.supplier_id
	var query="SELECT * FROM PO_DETAIL where ITEM in (SELECT ITEM_ID FROM ITEM_MASTER where ITEM_MASTER.SUPPLIER1="+supplier_id+" OR ITEM_MASTER.SUPPLIER2="+supplier_id+" OR ITEM_MASTER.SUPPLIER3="+supplier_id+")"
	console.log(query)
	oracledb.getConnection(
		{
		  user	: dbConfig.user,
		  password : dbConfig.password,
		  connectString	: dbConfig.connectString
		},
		    function(err, connection) {
                            if (err) {
                              console.error(err.message);
                              return;
                            }
                            connection.execute(
                              // The statement to execute
                              query,

                              // The callback function handles the SQL execution results
                             function(err, result) {
                                if (err) {
                                  console.error(err.message);
                                  //doRelease(connection);
                                  return;
                               }
                                console.log(result.metaData); // [ { name: 'DEPARTMENT_ID' }, { name: 'DEPARTMENT_NAME' } ]
                                console.log(result.rows);     // [ [ 180, 'Construction' ] ]
                                res.send(result.rows);
                                //console.log("sent suppliers");
				connection.close()

                              });
	
	});
});





app.post('/getsuppliers', function(req, res){
	  console.log(req.body);
	  
var query = "select i.item_name,s.SUPPLIER_NAME,k.SUPPLIER_NAME,m.SUPPLIER_NAME ,r.price ,t.cgst ,t.sgst from item_master i,supplier_master s,supplier_master k,supplier_master m,style_master r,tax_master t where i.SUPPLIER1=s.SUPPLIER_ID and i.SUPPLIER2=k.SUPPLIER_ID and i.SUPPLIER3=m.SUPPLIER_ID  and i.STYLE_ID=r.STYLE_ID and t.TAX_ID = r.TAX_ID and i.ITEM_ID = '"  + req.body + "'";	  
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
			      query,

			      // The callback function handles the SQL execution results
			      function(err, result) {
			        if (err) {
			          console.error(err.message);
			          //doRelease(connection);
			          return;
			        }
			        console.log(result.metaData); // [ { name: 'DEPARTMENT_ID' }, { name: 'DEPARTMENT_NAME' } ]
			        console.log(result.rows);     // [ [ 180, 'Construction' ] ]
			        doRelease(connection);
			        res.send(result.rows);
			        //console.log("sent suppliers");  
			        
			      });
			  });

			// Note: connections should always be released when not needed
			
	function doRelease(connection) {
		  connection.close(
		    function(err) {
		      if (err) {
		        console.error(err.message);
		      }
		    });
		}
	

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
					        
					        var table = result.rows;
					        
					        console.log(result);
					        doRelease(connection);
					        
					        var tmp_values= []; //declare objec
					       // for (var i=1;i<result.metaData.length;i++) {
					           // var tmp_values = [];
					            for (var l=1;l<table.length;l++) { 
					                tmp_values.push({ponumber:table[l][0] , sts: table[l][5]}); //label + value respectively
					            }
					            //jsonObj.push({key: csvAsArray[i][0], values: tmp_values}); //key
					            console.log(tmp_values);
					        
					        res.send(tmp_values);

					      });

			  });
	
	function doRelease(connection) {
		  connection.close(
		    function(err) {
		      if (err) {
		        console.error(err.message);
		      }
		    });
		}
			  
});

	app.post('/getSupplierNames', function(req, res){
	  

            
	  //esponse.sendFile(path.join(__dirname+'/index.html'));
	oracledb.getConnection(
			  {
			    user : dbConfig.user,
			    password : dbConfig.password,
			    connectString : dbConfig.connectString
			  },
			  function(err, connection) {
			    if (err) {
			      console.error(err.message);
			      return;
			    }
			    connection.execute(
			      // The statement to execute
			      `SELECT DISTINCT SUPPLIER_NAME FROM SUPPLIER_MASTER`,
			      // The callback function handles the SQL execution results
			      function(err, result) {
			        if (err) {
			          console.error(err.message);
			          //doRelease(connection);
			          return;
			        }
			        console.log(result.metaData); //
			        console.log(result.rows); //
			        res.send(result.rows);
					connection.close()
			        //console.log("sent");
			        
			      });
			  });
			// Note: connections should always be released when not needed
			
	
	});
	
	app.post('/updatePODetail', function(req, res){
	  var query="UPDATE PO_DETAIL SET SUPPLIER"+req.body.index+"_QTY="+req.body.quantity+" WHERE ITEM='"+req.body.itemId+"' and PO_NUMBER="+req.body.poId
	  //esponse.sendFile(path.join(__dirname+'/index.html'));
		console.log(query);
		oracledb.getConnection(
			  {
			    user : dbConfig.user,
			    password : dbConfig.password,
			    connectString : dbConfig.connectString
			  },
			  function(err, connection) {
			    console.log("Connected:");
			    if (err) {
			      console.error(err.message);
			      return;
			    }
			    connection.execute(
			      // The statement to execute
			      query,
			      // The callback function handles the SQL execution results
			      function(err, result) {
			        if (err) {
			          console.error(err.message);
			          //doRelease(connection);
			          return;
			       }
			        res.send("Sucessfully updated database");
				connection.close()
			        //console.log("sent");
			        
			      });
			  });
			// Note: connections should always be released when not needed
			
	
	});
	
	module.exports = router;
	var server=app.listen(8081,function() {});
