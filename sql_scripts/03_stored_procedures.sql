-- ============================================================
-- SAP HANA Inventory Management - Stored Procedures
-- ============================================================

-- ============================================================
-- PROCEDURE 1: Update Inventory After Sale
-- ============================================================
CREATE PROCEDURE INVENTORY_MGMT.SP_UPDATE_INVENTORY_AFTER_SALE(
    IN P_PRODUCT_ID INT,
    IN P_QUANTITY_SOLD INT,
    OUT P_NEW_STOCK_QTY INT,
    OUT P_STATUS NVARCHAR(100)
)
LANGUAGE SQLSCRIPT
AS
BEGIN
    DECLARE V_CURRENT_STOCK INT;
    DECLARE V_REORDER_LEVEL INT;
    
    -- Get current stock
    SELECT STOCK_QTY INTO V_CURRENT_STOCK
    FROM INVENTORY_MGMT.INVENTORY
    WHERE PRODUCT_ID = P_PRODUCT_ID;
    
    -- Check if sufficient stock
    IF V_CURRENT_STOCK >= P_QUANTITY_SOLD THEN
        -- Update inventory
        UPDATE INVENTORY_MGMT.INVENTORY
        SET STOCK_QTY = STOCK_QTY - P_QUANTITY_SOLD,
            LAST_UPDATED = CURRENT_DATE
        WHERE PRODUCT_ID = P_PRODUCT_ID;
        
        -- Get updated stock
        SELECT STOCK_QTY INTO P_NEW_STOCK_QTY
        FROM INVENTORY_MGMT.INVENTORY
        WHERE PRODUCT_ID = P_PRODUCT_ID;
        
        P_STATUS := 'Sale processed successfully';
    ELSE
        P_STATUS := 'Insufficient stock available';
        P_NEW_STOCK_QTY := V_CURRENT_STOCK;
    END IF;
    
END;

-- ============================================================
-- PROCEDURE 2: Check Low Stock Items
-- ============================================================
CREATE PROCEDURE INVENTORY_MGMT.SP_CHECK_LOW_STOCK()
LANGUAGE SQLSCRIPT
RESULT (PRODUCT_ID INT, PRODUCT_NAME NVARCHAR(100), STOCK_QTY INT, REORDER_LEVEL INT, STATUS NVARCHAR(50))
AS
BEGIN
    RETURN
        SELECT P.PRODUCT_ID,
               P.PRODUCT_NAME,
               I.STOCK_QTY,
               P.REORDER_LEVEL,
               CASE 
                   WHEN I.STOCK_QTY < P.REORDER_LEVEL THEN 'CRITICAL'
                   WHEN I.STOCK_QTY <= (P.REORDER_LEVEL * 1.5) THEN 'LOW'
                   ELSE 'NORMAL'
               END AS STATUS
        FROM INVENTORY_MGMT.PRODUCT P
        JOIN INVENTORY_MGMT.INVENTORY I ON P.PRODUCT_ID = I.PRODUCT_ID
        WHERE I.STOCK_QTY <= (P.REORDER_LEVEL * 1.5)
        ORDER BY STATUS DESC, I.STOCK_QTY ASC;
END;

-- ============================================================
-- PROCEDURE 3: Generate Stock Valuation Report
-- ============================================================
CREATE PROCEDURE INVENTORY_MGMT.SP_STOCK_VALUATION_REPORT()
LANGUAGE SQLSCRIPT
RESULT (PRODUCT_NAME NVARCHAR(100), CATEGORY NVARCHAR(50), STOCK_QTY INT, UNIT_PRICE DECIMAL(10,2), TOTAL_VALUE DECIMAL(14,2))
AS
BEGIN
    RETURN
        SELECT P.PRODUCT_NAME,
               P.CATEGORY,
               I.STOCK_QTY,
               P.UNIT_PRICE,
               (I.STOCK_QTY * P.UNIT_PRICE) AS TOTAL_VALUE
        FROM INVENTORY_MGMT.PRODUCT P
        JOIN INVENTORY_MGMT.INVENTORY I ON P.PRODUCT_ID = I.PRODUCT_ID
        ORDER BY TOTAL_VALUE DESC;
END;

-- ============================================================
-- PROCEDURE 4: Calculate Sales Velocity (Fast/Slow Moving)
-- ============================================================
CREATE PROCEDURE INVENTORY_MGMT.SP_SALES_VELOCITY_ANALYSIS(
    IN P_DAYS INT DEFAULT 30
)
LANGUAGE SQLSCRIPT
RESULT (PRODUCT_ID INT, PRODUCT_NAME NVARCHAR(100), TOTAL_SALES INT, AVG_DAILY_SALES DECIMAL(10,2), VELOCITY NVARCHAR(20))
AS
BEGIN
    RETURN
        SELECT P.PRODUCT_ID,
               P.PRODUCT_NAME,
               COALESCE(SUM(S.QUANTITY), 0) AS TOTAL_SALES,
               COALESCE(SUM(S.QUANTITY) / P_DAYS, 0) AS AVG_DAILY_SALES,
               CASE 
                   WHEN COALESCE(SUM(S.QUANTITY), 0) > 5 THEN 'Fast-Moving'
                   WHEN COALESCE(SUM(S.QUANTITY), 0) BETWEEN 2 AND 5 THEN 'Medium-Moving'
                   ELSE 'Slow-Moving'
               END AS VELOCITY
        FROM INVENTORY_MGMT.PRODUCT P
        LEFT JOIN INVENTORY_MGMT.SALES S ON P.PRODUCT_ID = S.PRODUCT_ID
        AND S.SALE_DATE >= ADD_DAYS(CURRENT_DATE, -P_DAYS)
        GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME
        ORDER BY TOTAL_SALES DESC;
END;

-- ============================================================
-- PROCEDURE 5: Get Reorder Recommendations
-- ============================================================
CREATE PROCEDURE INVENTORY_MGMT.SP_REORDER_RECOMMENDATIONS()
LANGUAGE SQLSCRIPT
RESULT (PRODUCT_ID INT, PRODUCT_NAME NVARCHAR(100), CURRENT_STOCK INT, REORDER_QTY INT, ESTIMATED_COST DECIMAL(14,2))
AS
BEGIN
    RETURN
        SELECT P.PRODUCT_ID,
               P.PRODUCT_NAME,
               I.STOCK_QTY AS CURRENT_STOCK,
               (P.REORDER_LEVEL * 2) - I.STOCK_QTY AS REORDER_QTY,
               ((P.REORDER_LEVEL * 2) - I.STOCK_QTY) * P.UNIT_PRICE AS ESTIMATED_COST
        FROM INVENTORY_MGMT.PRODUCT P
        JOIN INVENTORY_MGMT.INVENTORY I ON P.PRODUCT_ID = I.PRODUCT_ID
        WHERE I.STOCK_QTY < P.REORDER_LEVEL
        ORDER BY ESTIMATED_COST DESC;
END;

COMMIT;
