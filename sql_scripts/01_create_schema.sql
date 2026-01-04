-- ============================================================
-- SAP HANA Inventory Management System - Schema Creation
-- ============================================================

-- DROP SCHEMA IF EXISTS
DROP SCHEMA IF EXISTS INVENTORY_MGMT CASCADE;

-- CREATE NEW SCHEMA
CREATE SCHEMA INVENTORY_MGMT;

-- ============================================================
-- TABLE 1: PRODUCT
-- ============================================================
CREATE COLUMN TABLE INVENTORY_MGMT.PRODUCT (
    PRODUCT_ID INT NOT NULL PRIMARY KEY,
    PRODUCT_NAME NVARCHAR(100) NOT NULL,
    CATEGORY NVARCHAR(50) NOT NULL,
    UNIT_PRICE DECIMAL(10, 2) NOT NULL,
    REORDER_LEVEL INT NOT NULL,
    CREATED_DATE DATE DEFAULT CURRENT_DATE,
    MODIFIED_DATE DATE DEFAULT CURRENT_DATE
) WITH COMMENT = 'Master product information table';

-- Create index on category for faster filtering
CREATE INDEX IDX_PRODUCT_CATEGORY ON INVENTORY_MGMT.PRODUCT(CATEGORY);

-- ============================================================
-- TABLE 2: INVENTORY
-- ============================================================
CREATE COLUMN TABLE INVENTORY_MGMT.INVENTORY (
    INVENTORY_ID INT NOT NULL PRIMARY KEY,
    PRODUCT_ID INT NOT NULL,
    STOCK_QTY INT NOT NULL,
    LAST_UPDATED DATE DEFAULT CURRENT_DATE,
    WAREHOUSE_LOCATION NVARCHAR(50),
    FOREIGN KEY (PRODUCT_ID) REFERENCES INVENTORY_MGMT.PRODUCT(PRODUCT_ID)
) WITH COMMENT = 'Real-time inventory stock levels';

-- Create index on product_id for joins
CREATE INDEX IDX_INVENTORY_PRODUCT ON INVENTORY_MGMT.INVENTORY(PRODUCT_ID);
CREATE INDEX IDX_INVENTORY_STOCK ON INVENTORY_MGMT.INVENTORY(STOCK_QTY);

-- ============================================================
-- TABLE 3: SALES
-- ============================================================
CREATE COLUMN TABLE INVENTORY_MGMT.SALES (
    SALE_ID INT NOT NULL PRIMARY KEY,
    PRODUCT_ID INT NOT NULL,
    QUANTITY INT NOT NULL,
    SALE_DATE DATE NOT NULL,
    SALE_AMOUNT DECIMAL(12, 2),
    CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PRODUCT_ID) REFERENCES INVENTORY_MGMT.PRODUCT(PRODUCT_ID)
) WITH COMMENT = 'Sales transaction history';

-- Create indexes for performance
CREATE INDEX IDX_SALES_PRODUCT ON INVENTORY_MGMT.SALES(PRODUCT_ID);
CREATE INDEX IDX_SALES_DATE ON INVENTORY_MGMT.SALES(SALE_DATE);

-- ============================================================
-- TABLE 4: INVENTORY_AUDIT (for tracking changes)
-- ============================================================
CREATE COLUMN TABLE INVENTORY_MGMT.INVENTORY_AUDIT (
    AUDIT_ID INT NOT NULL IDENTITY,
    INVENTORY_ID INT NOT NULL,
    PRODUCT_ID INT NOT NULL,
    OLD_STOCK_QTY INT,
    NEW_STOCK_QTY INT,
    CHANGE_REASON NVARCHAR(200),
    CHANGED_BY NVARCHAR(50) DEFAULT CURRENT_USER,
    CHANGED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (AUDIT_ID)
) WITH COMMENT = 'Audit trail for inventory changes';

-- ============================================================
-- SEQUENCE for auto-increment IDs (if needed)
-- ============================================================
CREATE SEQUENCE INVENTORY_MGMT.SEQ_SALE_ID START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE INVENTORY_MGMT.SEQ_INVENTORY_ID START WITH 1001 INCREMENT BY 1;

COMMIT;
