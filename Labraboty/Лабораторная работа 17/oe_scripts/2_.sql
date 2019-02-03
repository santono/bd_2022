CREATE TABLE promotions (
  promo_id NUMBER(6),
  promo_name VARCHAR2(20));

ALTER TABLE promotions
ADD CONSTRAINT promo_id_pk PRIMARY KEY (promo_id);
INSERT INTO promotions (promo_id, promo_name)
  VALUES (1, 'everyday low price');

INSERT INTO promotions (promo_id, promo_name)
  VALUES (2, 'blowout sale');


CREATE TABLE orders
    ( order_id           NUMBER(12)
    , order_date         TIMESTAMP WITH LOCAL TIME ZONE
CONSTRAINT order_date_nn NOT NULL
    , order_mode         VARCHAR2(8)
    , customer_id        NUMBER(6) CONSTRAINT order_customer_id_nn NOT NULL
    , order_status       NUMBER(2)
    , order_total        NUMBER(8,2)
    , sales_rep_id       NUMBER(6)
    , promotion_id       NUMBER(6)
    , CONSTRAINT         order_mode_lov
                         CHECK (order_mode in ('direct','online'))
    , constraint         order_total_min
                         check (order_total >= 0)
    ) ;

CREATE UNIQUE INDEX order_pk
ON orders (order_id) ;

ALTER TABLE orders
ADD ( CONSTRAINT order_pk
      PRIMARY KEY (order_id)
    );
CREATE TABLE inventories
  ( product_id         NUMBER(6)
  , warehouse_id       NUMBER(3) CONSTRAINT inventory_warehouse_id_nn NOT NULL
  , quantity_on_hand   NUMBER(8)
CONSTRAINT inventory_qoh_nn NOT NULL
  , CONSTRAINT inventory_pk PRIMARY KEY (product_id, warehouse_id)
  ) ;


CREATE TABLE product_information
    ( product_id          NUMBER(6)
    , product_name        VARCHAR2(50)
    , product_description VARCHAR2(2000)
    , category_id         NUMBER(2)
    , weight_class        NUMBER(1)
    , warranty_period     INTERVAL YEAR TO MONTH
    , supplier_id         NUMBER(6)
    , product_status      VARCHAR2(20)
    , list_price          NUMBER(8,2)
    , min_price           NUMBER(8,2)
    , catalog_url         VARCHAR2(50)
    , CONSTRAINT          product_status_lov
                          CHECK (product_status in ('orderable'
                                                  ,'planned'
                                                  ,'under development'
                                                  ,'obsolete')
                               )
    ) ;

ALTER TABLE product_information 
ADD ( CONSTRAINT product_information_pk PRIMARY KEY (product_id)
    );

CREATE TABLE product_descriptions
    ( product_id             NUMBER(6)
    , language_id            VARCHAR2(3)
    , translated_name        NVARCHAR2(50)
CONSTRAINT translated_name_nn NOT NULL
    , translated_description NVARCHAR2(2000)
CONSTRAINT translated_desc_nn NOT NULL
    );

CREATE UNIQUE INDEX prd_desc_pk
ON product_descriptions(product_id,language_id) ;

ALTER TABLE product_descriptions
ADD ( CONSTRAINT product_descriptions_pk
	PRIMARY KEY (product_id, language_id));

ALTER TABLE orders
ADD ( CONSTRAINT orders_sales_rep_fk
      FOREIGN KEY (sales_rep_id)
      REFERENCES employees(employee_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE orders
ADD ( CONSTRAINT orders_customer_id_fk
      FOREIGN KEY (customer_id)
      REFERENCES customers(customer_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE warehouses
ADD ( CONSTRAINT warehouses_location_fk
      FOREIGN KEY (location_id)
      REFERENCES locations(location_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE customers
ADD ( CONSTRAINT customers_account_manager_fk
      FOREIGN KEY (account_mgr_id)
      REFERENCES employees(employee_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE inventories
ADD ( CONSTRAINT inventories_warehouses_fk
      FOREIGN KEY (warehouse_id)
      REFERENCES warehouses (warehouse_id)
      ENABLE NOVALIDATE
    ) ;

ALTER TABLE inventories
ADD ( CONSTRAINT inventories_product_id_fk
      FOREIGN KEY (product_id)
      REFERENCES product_information (product_id)
    ) ;

ALTER TABLE order_items
ADD ( CONSTRAINT order_items_order_id_fk
      FOREIGN KEY (order_id)
      REFERENCES orders(order_id)
      ON DELETE CASCADE
enable novalidate
    ) ;

ALTER TABLE order_items
ADD ( CONSTRAINT order_items_product_id_fk
      FOREIGN KEY (product_id)
      REFERENCES product_information(product_id)
    ) ;

ALTER TABLE product_descriptions
ADD ( CONSTRAINT pd_product_id_fk
      FOREIGN KEY (product_id)
      REFERENCES product_information(product_id)
    ) ;


CREATE SEQUENCE orders_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;