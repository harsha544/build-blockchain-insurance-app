create or replace PACKAGE BODY PO AS  
   
   PROCEDURE update_po(po_id IN PO_DETAIL.PO_NUMBER%TYPE) IS 
   
     rejectedstatus boolean;
     pendingstatus boolean;
     
     CURSOR c_po_items is 
      SELECT  status  FROM po_detail where PO_DETAIL.PO_NUMBER=po_id;
    
   BEGIN
      rejectedstatus:=false;
      pendingstatus:=false;
      for n in c_po_items loop
      if(n.status='Rejected')
      then
      rejectedstatus :=true;
      update po_master set po_master.status='Rejected' where PO_NUMBER=po_id;
      commit;
      EXIT;
      end if;
      if( rejectedstatus=false AND n.status='Pending')
      then
      pendingstatus:=true;
      update po_master set po_master.status='Pending' where PO_NUMBER=po_id;
      commit;
      end if;
      end loop;
      
      if(pendingstatus=false AND rejectedstatus=false)
      then
      update po_master set po_master.status='Approved' where PO_NUMBER=po_id;
      commit;
      end if;
      
   END update_po; 
END PO;