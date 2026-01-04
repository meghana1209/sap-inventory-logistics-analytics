-- Sample data for SAP Inventory & Logistics Analytics
-- Minimal rows to test schema and queries

-- Products
INSERT INTO products (sku, name, category, unit) VALUES
('SKU-001','Widget A','Widgets','pcs'),
('SKU-002','Widget B','Widgets','pcs'),
('SKU-003','Gadget X','Gadgets','pcs');

-- Suppliers
INSERT INTO suppliers (name, contact_email, phone) VALUES
('Acme Supplies','supply@acme.example','+1-555-0100'),
('Global Parts','parts@global.example','+1-555-0200');

-- Locations
INSERT INTO locations (code, name, type, address, timezone) VALUES
('WH-001','Main Warehouse','warehouse','100 Supply St','UTC'),
('STORE-01','Retail Store 1','store','200 Market Ave','UTC');

-- Inventory
INSERT INTO inventory (product_id, location_id, quantity, reserved)
VALUES
(1,1,100,5),
(2,1,50,0),
(3,1,20,2),
(1,2,10,1);

-- Shipments
INSERT INTO shipments (shipment_ref, supplier_id, origin_location_id, dest_location_id, expected_at, status)
VALUES
('SHP-1001',1, NULL, 1, now() + interval '2 days','in_transit');

-- Orders and items
INSERT INTO orders (order_ref, order_type, location_id, placed_at, status)
VALUES
('ORD-9001','customer',2, now() - interval '1 day','fulfilled');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1,1,2,9.99),
(1,3,1,19.99);

-- Inventory movements
INSERT INTO inventory_movements (product_id, from_location_id, to_location_id, quantity, movement_type, ref_id)
VALUES
(1,1,2,10,'transfer',1),
(2,NULL,1,50,'receipt',NULL);

-- End of sample data
