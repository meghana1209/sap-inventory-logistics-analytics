-- HANA SQLScript procedures and trigger examples for reorder point and snapshots

-- Procedure: calculate_reorder_point
-- Parameters: product_id, lookback_days, service_factor (z-score for safety stock)
CREATE PROCEDURE CALCULATE_REORDER_POINT (
  IN IN_PRODUCT_ID BIGINT,
  IN IN_LOOKBACK_DAYS INT DEFAULT 30,
  IN IN_SERVICE_FACTOR DECIMAL(10,2) DEFAULT 1.65,
  OUT OUT_REORDER_POINT DECIMAL(18,4)
)
LANGUAGE SQLSCRIPT
AS
BEGIN
  DECLARE avg_daily_usage DECIMAL(18,4) := 0;
  DECLARE stddev_daily_usage DECIMAL(18,4) := 0;

  -- Compute daily usage from movements (consumption) in lookback window
  SELECT
    COALESCE(AVG(daily_qty),0), COALESCE(STDDEV_POP(daily_qty),0)
  INTO avg_daily_usage, stddev_daily_usage
  FROM (
    SELECT CAST(OCCURRED_AT AS DATE) AS d, SUM(QUANTITY) AS daily_qty
    FROM INVENTORY_MOVEMENTS
    WHERE PRODUCT_ID = :IN_PRODUCT_ID
      AND MOVEMENT_TYPE IN ('consumption','issue')
      AND OCCURRED_AT >= ADD_DAYS(CURRENT_TIMESTAMP, -:IN_LOOKBACK_DAYS)
    GROUP BY CAST(OCCURRED_AT AS DATE)
  );

  -- Safety stock = z * stddev * sqrt(lead_time)
  DECLARE lead_time INT := 7; -- fallback if product has no lead time configured
  SELECT COALESCE(LEAD_TIME_DAYS,7) INTO lead_time FROM PRODUCTS WHERE PRODUCT_ID = :IN_PRODUCT_ID;

  DECLARE safety_stock DECIMAL(18,4) := :IN_SERVICE_FACTOR * stddev_daily_usage * SQRT(LEAD_TIME);
  DECLARE demand_during_lead DECIMAL(18,4) := avg_daily_usage * LEAD_TIME;

  OUT_REORDER_POINT := CEIL(demand_during_lead + safety_stock);
END;

-- Example trigger: after insert on inventory_movements update last_updated in inventory
CREATE TRIGGER TRG_MOVEMENT_AFTER_INSERT
AFTER INSERT ON INVENTORY_MOVEMENTS
REFERENCING NEW ROW AS NEWROW
BEGIN
  MERGE INTO INVENTORY AS I
  USING (
    SELECT NEWROW.PRODUCT_ID AS PRODUCT_ID, COALESCE(NEWROW.TO_LOCATION_ID, NEWROW.FROM_LOCATION_ID) AS LOCATION_ID, NEWROW.QUANTITY AS QTY
  ) AS S
  ON I.PRODUCT_ID = S.PRODUCT_ID AND I.LOCATION_ID = S.LOCATION_ID
  WHEN MATCHED THEN
    UPDATE SET QUANTITY = I.QUANTITY + S.QTY, LAST_UPDATED = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN
    INSERT (PRODUCT_ID, LOCATION_ID, QUANTITY, LAST_UPDATED) VALUES (S.PRODUCT_ID, S.LOCATION_ID, S.QTY, CURRENT_TIMESTAMP);
END;
