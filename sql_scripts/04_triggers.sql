-- ============================================================
-- SAP HANA Inventory Management - Triggers for Real-Time Updates
-- ============================================================

-- ============================================================
-- TRIGGER 1: Audit Trail for Inventory Updates
-- ============================================================
CREATE TRIGGER INVENTORY_MGMT.TR_INVENTORY_AUDIT_UPDATE
AFTER UPDATE ON INVENTORY_MGMT.INVENTORY
FOR EACH ROW
BEGIN
    INSERT INTO INVENTORY_MGMT.INVENTORY_AUDIT 
    (INVENTORY_ID, PRODUCT_ID, OLD_STOCK_QTY, NEW_STOCK_QTY, CHANGE_REASON, CHANGED_BY, CHANGED_DATE)
    VALUES
    (NEW.INVENTORY_ID, NEW.PRODUCT_ID, OLD.STOCK_QTY, NEW.STOCK_QTY, 'Stock Update', CURRENT_USER, CURRENT_TIMESTAMP);
END;

-- ============================================================
-- TRIGGER 2: Update Product Modified Date
-- ============================================================
CREATE TRIGGER INVENTORY_MGMT.TR_PRODUCT_MODIFIED_DATE
AFTER UPDATE ON INVENTORY_MGMT.PRODUCT
FOR EACH ROW
BEGIN
    UPDATE INVENTORY_MGMT.PRODUCT
    SET MODIFIED_DATE = CURRENT_DATE
    WHERE PRODUCT_ID = NEW.PRODUCT_ID;
END;

-- ============================================================
-- TRIGGER 3: Validate Stock Quantity (Non-negative Check)
-- ============================================================
CREATE TRIGGER INVENTORY_MGMT.TR_VALIDATE_STOCK_QTY
BEFORE INSERT ON INVENTORY_MGMT.INVENTORY
FOR EACH ROW
BEGIN
    IF NEW.STOCK_QTY < 0 THEN
        SIGNAL SQL_ERROR_CODE 10001 SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END;

-- ============================================================
-- TRIGGER 4: Validate Sales Quantity
-- ============================================================
CREATE TRIGGER INVENTORY_MGMT.TR_VALIDATE_SALES_QTY
BEFORE INSERT ON INVENTORY_MGMT.SALES
FOR EACH ROW
BEGIN
    IF NEW.QUANTITY <= 0 THEN
        SIGNAL SQL_ERROR_CODE 10002 SET MESSAGE_TEXT = 'Sales quantity must be positive';
    END IF;
    
    -- Auto-calculate sale amount if not provided
    IF NEW.SALE_AMOUNT IS NULL THEN
        SELECT (NEW.QUANTITY * P.UNIT_PRICE) INTO NEW.SALE_AMOUNT
        FROM INVENTORY_MGMT.PRODUCT P
        WHERE P.PRODUCT_ID = NEW.PRODUCT_ID;
    END IF;
END;

-- ============================================================
-- TRIGGER 5: Audit Trail for Inventory Inserts
-- ============================================================
CREATE TRIGGER INVENTORY_MGMT.TR_INVENTORY_AUDIT_INSERT
AFTER INSERT ON INVENTORY_MGMT.INVENTORY
FOR EACH ROW
BEGIN
    INSERT INTO INVENTORY_MGMT.INVENTORY_AUDIT 
    (INVENTORY_ID, PRODUCT_ID, OLD_STOCK_QTY, NEW_STOCK_QTY, CHANGE_REASON, CHANGED_BY, CHANGED_DATE)
    VALUES
    (NEW.INVENTORY_ID, NEW.PRODUCT_ID, 0, NEW.STOCK_QTY, 'Initial Stock Entry', CURRENT_USER, CURRENT_TIMESTAMP);
END;

COMMIT;
