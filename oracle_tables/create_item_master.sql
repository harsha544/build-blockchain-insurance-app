CREATE TABLE item_master (
item_id  VARCHAR2(100) NOT NULL,
item_name VARCHAR2(100),
style_id VARCHAR2(100),
supplier1 NUMBER,
supplier2 NUMBER,
supplier3 NUMBER,
PRIMARY KEY (item_id ),
FOREIGN KEY (supplier1)
REFERENCES supplier_master (supplier_id),
FOREIGN KEY (supplier2)
REFERENCES supplier_master (supplier_id),
FOREIGN KEY (supplier3)
REFERENCES supplier_master (supplier_id),
FOREIGN KEY (style_id)
REFERENCES style_master (style_id)
);
