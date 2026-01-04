-- ============================================================
-- SAP HANA Inventory Management System - Sample Data
-- ============================================================

-- Insert sample PRODUCT data
INSERT INTO INVENTORY_MGMT.PRODUCT 
(PRODUCT_ID, PRODUCT_NAME, CATEGORY, UNIT_PRICE, REORDER_LEVEL) 
VALUES
(101, 'Laptop Dell XPS 13', 'Electronics', 899.99, 20),
(102, 'Monitor LG 27" 4K', 'Electronics', 399.99, 15),
(103, 'USB-C Cable 2m', 'Accessories', 12.99, 100),
(104, 'Wireless Mouse Logitech', 'Accessories', 49.99, 50),
(105, 'Mechanical Keyboard RGB', 'Accessories', 149.99, 30),
(106, 'Office Chair Ergonomic', 'Furniture', 299.99, 10),
(107, 'Standing Desk Adjustable', 'Furniture', 599.99, 8),
(108, 'Desk Lamp LED', 'Furniture', 79.99, 40),
(109, 'USB Hub 7-Port', 'Accessories', 39.99, 60),
(110, 'Webcam HD 1080p', 'Electronics', 89.99, 25);

-- Insert sample INVENTORY data
INSERT INTO INVENTORY_MGMT.INVENTORY 
(INVENTORY_ID, PRODUCT_ID, STOCK_QTY, WAREHOUSE_LOCATION, LAST_UPDATED) 
VALUES
(1001, 101, 15, 'Warehouse-A', '2025-12-15'),
(1002, 102, 8, 'Warehouse-A', '2025-12-15'),
(1003, 103, 250, 'Warehouse-B', '2025-12-18'),
(1004, 104, 45, 'Warehouse-B', '2025-12-18'),
(1005, 105, 32, 'Warehouse-A', '2025-12-16'),
(1006, 106, 5, 'Warehouse-C', '2025-12-10'),  -- Below reorder level
(1007, 107, 12, 'Warehouse-C', '2025-12-15'),
(1008, 108, 125, 'Warehouse-B', '2025-12-17'),
(1009, 109, 75, 'Warehouse-A', '2025-12-19'),
(1010, 110, 18, 'Warehouse-B', '2025-12-14');

-- Insert sample SALES data
INSERT INTO INVENTORY_MGMT.SALES 
(SALE_ID, PRODUCT_ID, QUANTITY, SALE_DATE, SALE_AMOUNT) 
VALUES
(5001, 101, 2, '2025-12-01', 1799.98),
(5002, 102, 1, '2025-12-02', 399.99),
(5003, 103, 5, '2025-12-03', 64.95),
(5004, 104, 3, '2025-12-04', 149.97),
(5005, 105, 2, '2025-12-05', 299.98),
(5006, 101, 1, '2025-12-06', 899.99),
(5007, 106, 1, '2025-12-07', 299.99),
(5008, 103, 10, '2025-12-08', 129.90),
(5009, 108, 4, '2025-12-09', 319.96),
(5010, 110, 2, '2025-12-10', 179.98),
(5011, 104, 5, '2025-12-11', 249.95),
(5012, 103, 8, '2025-12-12', 103.92),
(5013, 101, 1, '2025-12-13', 899.99),
(5014, 105, 3, '2025-12-14', 449.97),
(5015, 109, 2, '2025-12-15', 79.98);

COMMIT;
