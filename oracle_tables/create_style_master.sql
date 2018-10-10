CREATE TABLE style_master (
style_id VARCHAR2(100)NOT NULL,
color_id NUMBER,
size_id NUMBER,
style_name VARCHAR2(100),
tax_id NUMBER,
price number,
PRIMARY KEY (style_id),
FOREIGN KEY (color_id)
REFERENCES color_master (color_id),
FOREIGN KEY (size_id)
REFERENCES size_master (size_id) ,
FOREIGN KEY (tax_id)
REFERENCES tax_master(tax_id)
);
