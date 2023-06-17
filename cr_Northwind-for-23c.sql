-------------------------------------------------------------------------------
--- Create Northwind Objects in Oracle Database < 23c error-free.
--- Goal: First and re-installing is the same process.
--- Adapted: Friedhold Matz
-------------------------------------------------------------------------------

drop table 	IF EXISTS 	CATEGORIES 		cascade constraint;
drop table	IF EXISTS 	CUSTOMERS  		cascade constraint;
drop table	IF EXISTS 	EMPLOYEES  		cascade constraint;
drop table	IF EXISTS 	SUPPLIERS  		cascade constraint;
drop table	IF EXISTS 	SHIPPERS  		cascade constraint;
drop table	IF EXISTS 	PRODUCTS  		cascade constraint;
drop table	IF EXISTS 	ORDERS  		cascade constraint;
drop table	IF EXISTS 	ORDER_DETAILS  		cascade constraint;

drop sequence	IF EXISTS 	SEQ_NW_CATEGORIES;
drop sequence 	IF EXISTS 	SEQ_NW_CUSTOMERS;
drop sequence 	IF EXISTS 	SEQ_NW_EMPLOYEES;
drop sequence 	IF EXISTS 	SEQ_NW_SUPPLIERS;
drop sequence 	IF EXISTS 	SEQ_NW_SHIPPERS;
drop sequence 	IF EXISTS 	SEQ_NW_PRODUCTS;
drop sequence 	IF EXISTS 	SEQ_NW_ORDERS;

	
PROMPT 'Create CATEGORIES ---'
CREATE TABLE CATEGORIES
(
    CATEGORY_ID NUMBER(9) NOT NULL,
    CATEGORY_NAME VARCHAR2(15 BYTE) NOT NULL,
    DESCRIPTION VARCHAR2(2000 BYTE),
    PICTURE VARCHAR2(255 BYTE),
    CONSTRAINT PK_CATEGORIES PRIMARY KEY (CATEGORY_ID)
);

CREATE UNIQUE INDEX UIDX_CATEGORY_NAME ON CATEGORIES(CATEGORY_NAME);

CREATE SEQUENCE SEQ_NW_CATEGORIES  
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 9
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;

COMMENT ON COLUMN CATEGORIES.CATEGORY_ID IS 'Number automatically assigned to a new category.';
COMMENT ON COLUMN CATEGORIES.CATEGORY_NAME IS 'Name of food category.';
COMMENT ON COLUMN CATEGORIES.PICTURE IS 'A picture representing the food category.';


PROMPT 'Create CUSTOMERS ---'
CREATE TABLE CUSTOMERS
(
    CUSTOMER_ID NUMBER(9) NOT NULL,
    CUSTOMER_CODE VARCHAR2(5 BYTE) NOT NULL,
    COMPANY_NAME VARCHAR2(40 BYTE) NOT NULL,
    CONTACT_NAME VARCHAR2(30 BYTE),
    CONTACT_TITLE VARCHAR2(30 BYTE),
    ADDRESS VARCHAR2(60 BYTE),
    CITY VARCHAR2(15 BYTE),
    REGION VARCHAR2(15 BYTE),
    POSTAL_CODE VARCHAR2(10 BYTE),
    COUNTRY VARCHAR2(15 BYTE),
    PHONE VARCHAR2(24 BYTE),
    FAX VARCHAR2(24 BYTE),
    CONSTRAINT PK_CUSTOMERS PRIMARY KEY (CUSTOMER_ID)
);

CREATE UNIQUE INDEX UIDX_CUSTOMERS_CODE ON CUSTOMERS(CUSTOMER_CODE);
CREATE INDEX IDX_CUSTOMERS_CITY ON CUSTOMERS(CITY);
CREATE INDEX IDX_CUSTOMERS_COMPANY_NAME ON CUSTOMERS(COMPANY_NAME);
CREATE INDEX IDX_CUSTOMERS_POSTAL_CODE ON CUSTOMERS(POSTAL_CODE);
CREATE INDEX IDX_CUSTOMERS_REGION ON CUSTOMERS(REGION);

CREATE SEQUENCE SEQ_NW_CUSTOMERS
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 92
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;

COMMENT ON COLUMN CUSTOMERS.CUSTOMER_ID IS 'Unique five-character code based on customer name.';
COMMENT ON COLUMN CUSTOMERS.ADDRESS IS 'Street or post-office box.';
COMMENT ON COLUMN CUSTOMERS.REGION IS 'State or province.';
COMMENT ON COLUMN CUSTOMERS.PHONE IS 'Phone number includes country code or area code.';
COMMENT ON COLUMN CUSTOMERS.FAX IS 'Phone number includes country code or area code.';


PROMPT 'EMPLOYEES ---'
CREATE TABLE EMPLOYEES
(
    EMPLOYEE_ID NUMBER(9) NOT NULL,
    LASTNAME VARCHAR2(20 BYTE) NOT NULL,
    FIRSTNAME VARCHAR2(10 BYTE) NOT NULL,
    TITLE VARCHAR2(30 BYTE),
    TITLE_OF_COURTESY VARCHAR2(25 BYTE),
    BIRTHDATE DATE,
    HIREDATE DATE,
    ADDRESS VARCHAR2(60 BYTE),
    CITY VARCHAR2(15 BYTE),
    REGION VARCHAR2(15 BYTE),
    POSTAL_CODE VARCHAR2(10 BYTE),
    COUNTRY VARCHAR2(15 BYTE),
    HOME_PHONE VARCHAR2(24 BYTE),
    EXTENSION VARCHAR2(4 BYTE),
    PHOTO VARCHAR2(255 BYTE),
    NOTES VARCHAR2(2000 BYTE),
    REPORTS_TO NUMBER(9),
    CONSTRAINT PK_EMPLOYEES PRIMARY KEY (EMPLOYEE_ID)
);

PROMPT 'Trigger ---'
CREATE INDEX IDX_EMPLOYEES_LASTNAME ON EMPLOYEES(LASTNAME);
CREATE INDEX IDX_EMPLOYEES_POSTAL_CODE ON EMPLOYEES(POSTAL_CODE);

-- Create a trigger to validate employee birthdate.
CREATE OR REPLACE TRIGGER TRG_EMP_BIRTHDATE
BEFORE INSERT OR UPDATE OF BIRTHDATE
ON EMPLOYEES 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
begin
    if :New.birthdate > trunc(sysdate) then
          RAISE_APPLICATION_ERROR (num => -20000, msg => 'Birthdate cannot be in the future');
    end if;
end;
/

CREATE SEQUENCE SEQ_NW_EMPLOYEES
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 10
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;

COMMENT ON COLUMN EMPLOYEES.EMPLOYEE_ID IS 'Number automatically assigned to new employee.';
COMMENT ON COLUMN EMPLOYEES.TITLE IS 'Employee''s title.';
COMMENT ON COLUMN EMPLOYEES.TITLE_OF_COURTESY IS 'Title used in salutations.';
COMMENT ON COLUMN EMPLOYEES.ADDRESS IS 'Street or post-office box.';
COMMENT ON COLUMN EMPLOYEES.REGION IS 'State or province.';
COMMENT ON COLUMN EMPLOYEES.HOME_PHONE IS 'Phone number includes country code or area code.';
COMMENT ON COLUMN EMPLOYEES.EXTENSION IS 'Internal telephone extension number.';
COMMENT ON COLUMN EMPLOYEES.PHOTO IS 'Picture of employee.';
COMMENT ON COLUMN EMPLOYEES.NOTES IS 'General information about employee''s background.';
COMMENT ON COLUMN EMPLOYEES.REPORTS_TO IS 'Employee''s supervisor.';


ALTER TABLE EMPLOYEES
ADD CONSTRAINT FK_REPORTS_TO FOREIGN KEY (REPORTS_TO) REFERENCES EMPLOYEES(EMPLOYEE_ID);


PROMPT 'SUPPLIERS ---'
CREATE TABLE SUPPLIERS
(
    SUPPLIER_ID NUMBER(9) NOT NULL,
    COMPANY_NAME VARCHAR2(40 BYTE) NOT NULL,
    CONTACT_NAME VARCHAR2(30 BYTE),
    CONTACT_TITLE VARCHAR2(30 BYTE),
    ADDRESS VARCHAR2(60 BYTE),
    CITY VARCHAR2(15 BYTE),
    REGION VARCHAR2(15 BYTE),
    POSTAL_CODE VARCHAR2(10 BYTE),
    COUNTRY VARCHAR2(15 BYTE),
    PHONE VARCHAR2(24 BYTE),
    FAX VARCHAR2(24 BYTE),
    HOME_PAGE VARCHAR2(500 BYTE),
    CONSTRAINT PK_SUPPLIERS PRIMARY KEY (SUPPLIER_ID)  
);

CREATE INDEX IDX_SUPPLIERS_COMPANY_NAME ON SUPPLIERS(COMPANY_NAME);
CREATE INDEX IDX_SUPPLIERS_POSTAL_CODE ON SUPPLIERS(POSTAL_CODE);


CREATE SEQUENCE SEQ_NW_SUPPLIERS
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 30
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;

COMMENT ON COLUMN SUPPLIERS.SUPPLIER_ID IS 'Number automatically assigned to new supplier.';
COMMENT ON COLUMN SUPPLIERS.ADDRESS IS 'Street or post-office box.';
COMMENT ON COLUMN SUPPLIERS.REGION IS 'State or province.';
COMMENT ON COLUMN SUPPLIERS.PHONE IS 'Phone number includes country code or area code.';
COMMENT ON COLUMN SUPPLIERS.FAX IS 'Phone number includes country code or area code.';
COMMENT ON COLUMN SUPPLIERS.HOME_PAGE IS 'Supplier''s home page on World Wide Web.';


PROMPT 'shippers ---'
CREATE TABLE SHIPPERS
(
    SHIPPER_ID NUMBER(9) NOT NULL,
    COMPANY_NAME VARCHAR2(40 BYTE) NOT NULL,
    PHONE VARCHAR2(24 BYTE),
    CONSTRAINT PK_SHIPPERS PRIMARY KEY (SHIPPER_ID)
);


CREATE SEQUENCE SEQ_NW_SHIPPERS
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 4
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;

COMMENT ON COLUMN SHIPPERS.SHIPPER_ID IS 'Number automatically assigned to new shipper.';
COMMENT ON COLUMN SHIPPERS.COMPANY_NAME IS 'Name of shipping company.';
COMMENT ON COLUMN SHIPPERS.PHONE IS 'Phone number includes country code or area code.';


PROMPT 'PRODUCTS ---'
CREATE TABLE PRODUCTS
(
    PRODUCT_ID NUMBER(9) NOT NULL,
    PRODUCT_NAME VARCHAR2(40 BYTE) NOT NULL,
    SUPPLIER_ID NUMBER(9) NOT NULL,
    CATEGORY_ID NUMBER(9) NOT NULL,
    QUANTITY_PER_UNIT VARCHAR2(20 BYTE),
    UNIT_PRICE NUMBER(10,2) DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_UNIT_PRICE CHECK (Unit_Price>=0),
    UNITS_IN_STOCK NUMBER(9) DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_UNITS_IN_STOCK CHECK (Units_In_Stock>=0),
    UNITS_ON_ORDER NUMBER(9) DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_UNITS_ON_ORDER CHECK (Units_On_Order>=0),
    REORDER_LEVEL NUMBER(9) DEFAULT 0 NOT NULL CONSTRAINT CK_PRODUCTS_REORDER_LEVEL CHECK (Reorder_Level>=0),
    DISCONTINUED CHAR(1 BYTE) DEFAULT 'N' NOT NULL CONSTRAINT CK_PRODUCTS_DISCONTINUED CHECK (Discontinued in ('Y','N')),
    CONSTRAINT PK_PRODUCTS PRIMARY KEY (PRODUCT_ID),
    CONSTRAINT FK_CATEGORY_ID FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORIES(CATEGORY_ID),
    CONSTRAINT FK_SUPPLIER_ID FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIERS(SUPPLIER_ID)  
);
  
CREATE INDEX IDX_PRODUCTS_CATEGORY_ID ON PRODUCTS(CATEGORY_ID);
CREATE INDEX IDX_PRODUCTS_SUPPLIER_ID ON PRODUCTS(SUPPLIER_ID);


CREATE SEQUENCE SEQ_NW_PRODUCTS
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 78
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;
  
COMMENT ON COLUMN PRODUCTS.PRODUCT_ID IS 'Number automatically assigned to new product.';
COMMENT ON COLUMN PRODUCTS.SUPPLIER_ID IS 'Same entry as in Suppliers table.';
COMMENT ON COLUMN PRODUCTS.CATEGORY_ID IS 'Same entry as in Categories table.';
COMMENT ON COLUMN PRODUCTS.QUANTITY_PER_UNIT IS '(e.g., 24-count case, 1-liter bottle).';
COMMENT ON COLUMN PRODUCTS.REORDER_LEVEL IS 'Minimum units to maintain in stock.';
COMMENT ON COLUMN PRODUCTS.DISCONTINUED IS 'Yes means item is no longer available.';


PROMPT 'ORDERS ---'
CREATE TABLE ORDERS
(
    ORDER_ID NUMBER(9) NOT NULL,
    CUSTOMER_ID NUMBER(9) NOT NULL,
    EMPLOYEE_ID NUMBER(9) NOT NULL,
    ORDER_DATE DATE NOT NULL,
    REQUIRED_DATE DATE,
    SHIPPED_DATE DATE,
    SHIP_VIA NUMBER(9),
    FREIGHT NUMBER(10,2) DEFAULT 0,
    SHIP_NAME VARCHAR2(40 BYTE),
    SHIP_ADDRESS VARCHAR2(60 BYTE),
    SHIP_CITY VARCHAR2(15 BYTE),
    SHIP_REGION VARCHAR2(15 BYTE),
    SHIP_POSTAL_CODE VARCHAR2(10 BYTE),
    SHIP_COUNTRY VARCHAR2(15 BYTE),
    CONSTRAINT PK_ORDERS PRIMARY KEY (ORDER_ID),
    CONSTRAINT FK_CUSTOMER_ID FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),  
    CONSTRAINT FK_EMPLOYEE_ID FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),  
    CONSTRAINT FK_SHIPPER_ID FOREIGN KEY (SHIP_VIA) REFERENCES SHIPPERS(SHIPPER_ID)  
);

CREATE INDEX IDX_ORDERS_CUSTOMER_ID ON ORDERS(CUSTOMER_ID);
CREATE INDEX IDX_ORDERS_EMPLOYEE_ID ON ORDERS(EMPLOYEE_ID);
CREATE INDEX IDX_ORDERS_SHIPPER_ID ON ORDERS(SHIP_VIA);
CREATE INDEX IDX_ORDERS_ORDER_DATE ON ORDERS(ORDER_DATE);
CREATE INDEX IDX_ORDERS_SHIPPED_DATE ON ORDERS(SHIPPED_DATE);
CREATE INDEX IDX_ORDERS_SHIP_POSTAL_CODE ON ORDERS(SHIP_POSTAL_CODE);


CREATE SEQUENCE SEQ_NW_ORDERS
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 11018
    INCREMENT BY 1
    NOCYCLE
    NOCACHE
    NOORDER;

COMMENT ON COLUMN ORDERS.ORDER_ID IS 'Unique order number.';
COMMENT ON COLUMN ORDERS.CUSTOMER_ID IS 'Same entry as in Customers table.';
COMMENT ON COLUMN ORDERS.EMPLOYEE_ID IS 'Same entry as in Employees table.';
COMMENT ON COLUMN ORDERS.SHIP_VIA IS 'Same as Shipper ID in Shippers table.';
COMMENT ON COLUMN ORDERS.SHIP_NAME IS 'Name of person or company to receive the shipment.';
COMMENT ON COLUMN ORDERS.SHIP_ADDRESS IS 'Street address only -- no post-office box allowed.';
COMMENT ON COLUMN ORDERS.SHIP_REGION IS 'State or province.';


PROMPT 'ORDER_DETAILS ---'
CREATE TABLE ORDER_DETAILS
(
    ORDER_ID NUMBER(9) NOT NULL,
    PRODUCT_ID NUMBER(9) NOT NULL,
    UNIT_PRICE NUMBER(10,2) DEFAULT 0 NOT NULL CONSTRAINT CK_ORDER_DETAILS_UNIT_PRICE CHECK (Unit_Price>=0),
    QUANTITY NUMBER(9) DEFAULT 1 NOT NULL CONSTRAINT CK_ORDER_DETAILS_QUANTITY CHECK (Quantity>0),
    DISCOUNT NUMBER(4,2) DEFAULT 0 NOT NULL CONSTRAINT CK_ORDER_DETAILS_DISCOUNT CHECK (Discount between 0 and 1),
    CONSTRAINT PK_ORDER_DETAILS PRIMARY KEY (ORDER_ID, PRODUCT_ID),
    CONSTRAINT FK_ORDER_ID FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ORDER_ID),
    CONSTRAINT FK_PRODUCT_ID FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS (PRODUCT_ID)
);

CREATE INDEX IDX_ORDER_DETAILS_ORDER_ID ON ORDER_DETAILS(ORDER_ID);
CREATE INDEX IDX_ORDER_DETAILS_PRODUCT_ID ON ORDER_DETAILS(PRODUCT_ID);
COMMENT ON COLUMN ORDER_DETAILS.ORDER_ID IS 'Same as Order ID in Orders table.';
COMMENT ON COLUMN ORDER_DETAILS.PRODUCT_ID IS 'Same as Product ID in Products table.';


PROMPT 'Drop proc drop_object ---'
BEGIN 
    EXECUTE IMMEDIATE 'drop procedure drop_object'; 
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT '--- ENDE ---'
