#------------------------------------------------------------------------------
# Copyright 2016, 2017, Oracle and/or its affiliates. All rights reserved.
#
# Portions Copyright 2007-2015, Anthony Tuininga. All rights reserved.
#
# Portions Copyright 2001-2007, Computronix (Canada) Ltd., Edmonton, Alberta,
# Canada. All rights reserved.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# DatabaseChangeNotification.py
#   This script demonstrates using database change notification in Python, a
# feature that is available in Oracle 10g Release 2. Once this script is
# running, use another session to insert, update or delete rows from the table
# cx_Oracle.TestTempTable and you will see the notification of that change.
#
# This script requires cx_Oracle 5.3 and higher.
#------------------------------------------------------------------------------

from __future__ import print_function

import cx_Oracle
import threading
import time
import json
import requests

connection = cx_Oracle.Connection("test_user","oracle","172.21.6.198:1521/orclpdb.ibm.com",
        events = True)
cur=connection.cursor()
pending_requests=[]


def callWebService(notification):
	data={}
	data={"itemId":str(notification[0]),"quantity":notification[1],"poId":notification[5]}
	sql="select * from ITEM_MASTER where ITEM_ID='"+data["itemId"]+"'"
	for row in cur.execute(sql):
		result=tuple(row)
		data["supplier1"]=str(result[-3])
		data["supplier2"]=str(result[-2])
		data["supplier3"]=str(result[-1])

	print("DATA------>",data)
	try:
		req=requests.post("http://172.21.3.198:8081/addPO",json=data)
	except:
		print("Error")
		pending_requests.append(req)
		return
	print(req.text)


def handle_pending():
	for req in pending_requests:
		callWebService(req)
		pending_requests.remove(req)
		
def checkRequiredQuantity(notification):
	quantity_submitted=0
	notGotValue=False
	for i in range(2,5):
		if notification[i]!=None:
			quantity_submitted=quantity_submitted+notification[i]
		else:
			notGotValue=True
	if quantity_submitted>=notification[1] and str(notification[6]).lower()=="pending":
		closePO(str(notification[0]),str(notification[5]))
	elif notGotValue==False and str(notification[6]).lower()=="pending":
		closePO(str(notification[0]),str(notification[5]))
		

def closePO(itemId,poId):
	connect = cx_Oracle.connect("test_user","oracle","172.21.6.198:1521/orclpdb.ibm.com")
	cur = connect.cursor()	
	val=str(poId)+"_"+str(itemId)
	json_data={"itemId":itemId,"poId":poId}
	try:
		res=requests.post("http://172.21.3.198:8081/closePO",data=json_data)
	except:
		print("Error:",res.text)

	supplier_values={}
	response=requests.get("http://172.21.3.198:8081/PODetails").text
	data=json.loads(response)
	#print(data[0]["poId"])
	print(val)
	#a=filter((lambda x : val in x["poId"]),data)
	#print(a)
	for po in data:
		if po["poId"]==val:
			supplier_values["status"]=po["status"]
			for approve in po["approved"]:
				supplier_values[approve["supplier_name"].split("#")[1]]=str(approve["quantity"])


	result=tuple([x for x in cur.execute("SELECT SUPPLIER1,SUPPLIER2,SUPPLIER3 FROM ITEM_MASTER where ITEM_ID='"+itemId+"'")][0])
	supplier_id={}
	supplier_id["supplier1"]=str(result[0])
	supplier_id["supplier2"]=str(result[1])
	supplier_id["supplier3"]=str(result[2])

	for x in supplier_id:
		if supplier_id[x] not in supplier_values:
			supplier_values[supplier_id[x]]="0"
	print(supplier_id)
	print(supplier_values)

	cur.execute("UPDATE PO_DETAIL SET SUPPLIER1_QTY="+supplier_values[supplier_id["supplier1"]]+",SUPPLIER2_QTY="+supplier_values[supplier_id["supplier2"]]+",SUPPLIER3_QTY="+supplier_values[supplier_id["supplier3"]]+",STATUS='"+supplier_values["status"]+"' WHERE ITEM='"+itemId+"' and PO_NUMBER="+poId)

	connect.commit()
	cur.callproc("PO.update_po",keywordParameters={"po_id":poId})
	connect.commit()
	connect.close()
		
		
		
		
		
		
		
		
def callback(message):
    print("Message type:", message.type)
    print("Message database name:", message.dbname)
    print("Message tables:")
    update=False
    callFunc=callWebService
    for table in message.tables:
        print("--> Table Name:", table.name)
        print("--> Table Operation:", table.operation)
	if table.operation==4:
		update=True
		callFunc=checkRequiredQuantity
        if table.rows is not None:
            print("--> Table Rows:")
            for row in table.rows:
                print("--> --> Row RowId:", row.rowid)
                print("--> --> Row Operation:", row.operation)
		sql="select * FROM PO_DETAIL where ROWID ='"+row.rowid+"'"
		for row in cur.execute(sql):
			callFunc(tuple(row))
        print("=" * 60)


sub = connection.subscribe(callback = callback, timeout = 1800,
        qos = cx_Oracle.SUBSCR_QOS_ROWIDS)
print("Subscription:", sub)
print("--> Connection:", sub.connection)
print("--> Callback:", sub.callback)
print("--> Namespace:", sub.namespace)
print("--> Protocol:", sub.protocol)
print("--> Timeout:", sub.timeout)
print("--> Operations:", sub.operations)
print("--> Rowids?:", bool(sub.qos & cx_Oracle.SUBSCR_QOS_ROWIDS))
sub.registerquery('select * FROM PO_DETAIL')

while True:
    print("Waiting for notifications....")
    handle_pending()
    time.sleep(5)

