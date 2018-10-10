CREATE TABLE po_master (
po_number NUMBER NOT NULL,
po_value NUMBER,
cgst NUMBER,
sgst NUMBER,
total_tax NUMBER,
status CHAR(20),
PRIMARY KEY (po_number)
);
