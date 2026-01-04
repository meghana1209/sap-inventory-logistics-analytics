-- Analysis queries for inventory & logistics

-- 1) Total inventory by product (across all locations)
SELECT p.product_id, p.sku, p.name, SUM(i.quantity) AS total_quantity
FROM products p
JOIN inventory i ON i.product_id = p.product_id
GROUP BY p.product_id, p.sku, p.name
ORDER BY total_quantity DESC;

-- 2) Inventory by location for a product
-- :product_id parameterize as needed
SELECT l.location_id, l.code, l.name, i.quantity, i.reserved
FROM inventory i
JOIN locations l ON l.location_id = i.location_id
WHERE i.product_id = 1
ORDER BY i.quantity DESC;

-- 3) Stockouts (products with zero across all locations)
SELECT p.product_id, p.sku, p.name
FROM products p
LEFT JOIN (
  SELECT product_id, SUM(quantity) AS qty FROM inventory GROUP BY product_id
) t ON t.product_id = p.product_id
WHERE COALESCE(t.qty,0) = 0;

-- 4) Inventory aging: last movement per product
SELECT im.product_id, p.sku, MAX(im.occurred_at) AS last_movement
FROM inventory_movements im
JOIN products p ON p.product_id = im.product_id
GROUP BY im.product_id, p.sku
ORDER BY last_movement ASC;

-- 5) Turnover: inbound vs outbound quantities in a date range
-- Adjust dates as needed
SELECT
  SUM(CASE WHEN movement_type IN ('receipt') THEN quantity ELSE 0 END) AS inbound_qty,
  SUM(CASE WHEN movement_type IN ('consumption') THEN quantity ELSE 0 END) AS outbound_qty
FROM inventory_movements
WHERE occurred_at >= now() - interval '30 days';

-- 6) Pending inbound shipments
SELECT s.shipment_id, s.shipment_ref, s.expected_at, s.status, sup.name AS supplier
FROM shipments s
LEFT JOIN suppliers sup ON sup.supplier_id = s.supplier_id
WHERE s.status = 'in_transit' OR s.expected_at > now()
ORDER BY s.expected_at ASC;

-- 7) Top suppliers by receipts (30 days)
SELECT sup.supplier_id, sup.name, COUNT(s.shipment_id) AS shipments
FROM shipments s
JOIN suppliers sup ON sup.supplier_id = s.supplier_id
WHERE s.expected_at >= now() - interval '30 days'
GROUP BY sup.supplier_id, sup.name
ORDER BY shipments DESC;

-- End queries
