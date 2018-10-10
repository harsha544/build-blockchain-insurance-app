CREATE TABLE po_detail (
item VARCHAR2(100),
qty NUMBER,
po_number NUMBER NOT NULL,
supplier1_qty NUMBER,
supplier2_qty NUMBER,
supplier3_qty NUMBER,
status VARCHAR2(20),
PRIMARY KEY (po_number),
FOREIGN KEY (item)
REFERENCES item_master(item_id),
FOREIGN KEY (po_number)
REFERENCES po_master(po_number)
);
