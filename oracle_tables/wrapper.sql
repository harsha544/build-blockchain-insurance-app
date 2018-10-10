SET serveroutput      ON
set pagesize 0
set trimspool on

SPOOL create_fresh_schema.log

prompt "----------Dropping tables---Please wait ------------------"

prompt "-------Dropping supplier_master---------------------------"
@wipe_supplier_master.sql
prompt "-------Dropping supplier_master done----------------------"
prompt "-------Dropping tax_master--------------------------------"
@wipe_tax_master.sql
prompt "-------Dropping tax_master done--------------"
prompt "-------Dropping size_master------------------"
@wipe_size_master.sql
prompt "-------Dropping size_master done-------------"
prompt "-------Dropping colour_master----------------"
@wipe_colour_master.sql
prompt "-------Dropping colour_master done-----------"
prompt "-------Dropping po_master--------------------"
@wipe_po_master.sql
prompt "-------Dropping po_master done---------------"
prompt "-------Dropping style_master-----------------"
@wipe_style_master.sql
prompt "-------Dropping style_master done------------"
prompt "-------Dropping po_detail--------------------"
@wipe_po_detail.sql
prompt "-------Dropping po_detail done---------------"
prompt "-------Dropping item_master------------------"
@wipe_item_master.sql
prompt "-------Dropping item_master done-------------"
prompt "-------WIPE COMPLETE-------------------------"
prompt "-------CREATING TABLES-----------------------"
prompt "-------Creating supplier_master--------------"
@create_supplier_master.sql
prompt "-------Creating supplier_master done---------"
prompt "-------Creating size_master------------------"
@create_size_master.sql
prompt "-------Creating size_master done-------------"
prompt "-------Creating color_master-----------------"
@create_color_master.sql
prompt "-------Creating color_master done------------"
prompt "-------Creating tax_master-------------------"
@create_tax_master.sql
prompt "-------Creating tax_master done--------------"
prompt "-------Creating style_master-----------------"
@create_style_master.sql
prompt "-------Creating style_master done------------"
prompt "-------Creating item_master------------------"
@create_item_master.sql
prompt "-------Creating item_master done-------------"
prompt "-------Creating po_master--------------------"
@create_po_master.sql
prompt "-------Creating po_master done---------------"
prompt "-------Creating po_detail--------------------"
@create_po_detail.sql
prompt "-------Creating po_detail done---------------"

prompt "-------CREATING TABLES COMPLETED-------------"
commit;
