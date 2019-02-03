CREATE TABLE customers
    ( customer_id        NUMBER(6)
    , cust_first_name    VARCHAR2(20) CONSTRAINT cust_fname_nn NOT NULL
    , cust_last_name     VARCHAR2(20) CONSTRAINT cust_lname_nn NOT NULL
    , cust_address       cust_address_typ
    , phone_numbers      phone_list_typ
    , nls_language       VARCHAR2(3)
    , nls_territory      VARCHAR2(30)
    , credit_limit       NUMBER(9,2)
    , cust_email         VARCHAR2(30)
    , account_mgr_id     NUMBER(6)
    , cust_geo_location  MDSYS.SDO_GEOMETRY
    , CONSTRAINT         customer_credit_limit_max
                         CHECK (credit_limit <= 5000)
    , CONSTRAINT         customer_id_min
                         CHECK (customer_id > 0)
    ) ;
CREATE UNIQUE INDEX customers_pk
   ON customers (customer_id) ;
ALTER TABLE customers
ADD ( CONSTRAINT customers_pk
      PRIMARY KEY (customer_id)
    ) ;
CREATE TABLE warehouses
    ( warehouse_id       NUMBER(3)
    , warehouse_spec     SYS.XMLTYPE
    , warehouse_name     VARCHAR2(35)
    , location_id        NUMBER(4)
    , wh_geo_location    MDSYS.SDO_GEOMETRY
    ) ;
CREATE UNIQUE INDEX warehouses_pk
ON warehouses (warehouse_id) ;

ALTER TABLE warehouses
ADD (CONSTRAINT warehouses_pk PRIMARY KEY (warehouse_id)
    );
CREATE TABLE order_items
    ( order_id           NUMBER(12)
    , line_item_id       NUMBER(3)  NOT NULL
    , product_id         NUMBER(6)  NOT NULL
    , unit_price         NUMBER(8,2)
    , quantity           NUMBER(8)
    ) ;

CREATE UNIQUE INDEX order_items_pk
ON order_items (order_id, line_item_id) ;

CREATE UNIQUE INDEX order_items_uk
ON order_items (order_id, product_id) ;

ALTER TABLE order_items
ADD ( CONSTRAINT order_items_pk PRIMARY KEY (order_id, line_item_id)
    );
