var async = require('async');
var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');

var doconnect = function(cb) {
  oracledb.getConnection(
    {
      user          : dbConfig.user,
      password      : dbConfig.password,
      connectString : dbConfig.connectString
    },
    cb);
};

var dorelease = function(conn) {
  conn.close(function (err) {
    if (err)
      console.error(err.message);
  });
};

var dodrop = function (conn, cb) {
  conn.execute(
    `BEGIN
       EXECUTE IMMEDIATE 'DROP TABLE test';
       EXCEPTION WHEN OTHERS THEN
       IF SQLCODE <> -942 THEN
         RAISE;
       END IF;
     END;`,
    function(err) {
      if (err) {
        return cb(err, conn);
      } else {
        console.log("Table dropped");
        return cb(null, conn);
      }
    });
};

var docreate = function (conn, cb) {
  conn.execute(
    "CREATE TABLE test (id NUMBER, name VARCHAR2(20))",
    function(err) {
      if (err) {
        return cb(err, conn);
      } else {
        console.log("Table created");
        return cb(null, conn);
      }
    });
};

var doinsert1 = function (conn, cb) {
  conn.execute(
    "INSERT INTO test VALUES (:id, :nm)",
    { id : {val: 1 }, nm : {val: 'Chris'} },  // 'bind by name' syntax
    function(err, result) {
      if (err) {
        return cb(err, conn);
      } else {
        console.log("Rows inserted: " + result.rowsAffected);  // 1
        return cb(null, conn);
      }
    });
};

var doinsert2 = function (conn, cb) {
  conn.execute(
    "INSERT INTO test VALUES (:id, :nm)",
    [[2, 'Alison'], [3,'ALISON AGAIN']], // 'bind by position' syntax
    function(err, result) {
      if (err) {
        return cb(err, conn);
      } else {
        console.log("Rows inserted: " + result.rowsAffected);  // 1
        return cb(null, conn);
      }
    });
};

var doupdate = function (conn, cb) {
  conn.execute(
    "UPDATE test SET name = :nm",
    ['Bambi'],
    { autoCommit: true },  // commit once for all DML in the script
    function(err, result) {
      if (err) {
        return cb(err, conn);
      } else {
        console.log("Rows updated: " + result.rowsAffected); // 2
        return cb(null, conn);
      }
    });
};

async.waterfall(
  [
    doconnect,
    dodrop,
    docreate,
    doinsert1,
    doinsert2,
    doupdate,
    dodrop  // comment this out if you want to verify the data later
  ],
  function (err, conn) {
    if (err) { console.error("In waterfall error cb: ==>", err, "<=="); }
    if (conn)
      dorelease(conn);
});
