create or replace PACKAGE PO AS 
   PROCEDURE update_po(po_id PO_DETAIL.PO_NUMBER%TYPE); 
END PO;