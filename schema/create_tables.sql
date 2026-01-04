-- Schema for SAP Inventory & Logistics Analytics (PostgreSQL)
-- Creates core tables for products, suppliers, locations, inventory, shipments, orders, and movements

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku VARCHAR(64) NOT NULL UNIQUE,
    name TEXT NOT NULL,
    category VARCHAR(128),
    unit VARCHAR(32),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    contact_email TEXT,
    phone VARCHAR(32),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    code VARCHAR(32) NOT NULL UNIQUE,
    name TEXT NOT NULL,
    type VARCHAR(32), -- e.g., 'warehouse', 'store', 'dc'
    address TEXT,
    timezone VARCHAR(64),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE inventory (
    inventory_id BIGSERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    location_id INT NOT NULL REFERENCES locations(location_id) ON DELETE CASCADE,
    quantity NUMERIC(18,4) NOT NULL DEFAULT 0,
    reserved NUMERIC(18,4) NOT NULL DEFAULT 0,
    last_updated TIMESTAMPTZ DEFAULT now(),
    UNIQUE (product_id, location_id)
);

CREATE TABLE shipments (
    shipment_id BIGSERIAL PRIMARY KEY,
    shipment_ref VARCHAR(128) UNIQUE,
    supplier_id INT REFERENCES suppliers(supplier_id),
    origin_location_id INT REFERENCES locations(location_id),
    dest_location_id INT REFERENCES locations(location_id),
    expected_at TIMESTAMPTZ,
    arrived_at TIMESTAMPTZ,
    status VARCHAR(32), -- e.g., 'in_transit','arrived','cancelled'
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,
    order_ref VARCHAR(128) UNIQUE,
    order_type VARCHAR(32), -- 'customer','transfer','purchase'
    location_id INT REFERENCES locations(location_id),
    placed_at TIMESTAMPTZ DEFAULT now(),
    fulfilled_at TIMESTAMPTZ,
    status VARCHAR(32)
);

CREATE TABLE order_items (
    order_item_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity NUMERIC(18,4) NOT NULL,
    unit_price NUMERIC(18,4),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE inventory_movements (
    movement_id BIGSERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    from_location_id INT REFERENCES locations(location_id),
    to_location_id INT REFERENCES locations(location_id),
    quantity NUMERIC(18,4) NOT NULL,
    movement_type VARCHAR(64), -- 'receipt','consumption','transfer','adjustment'
    ref_id BIGINT, -- optionally link to shipment, order, etc.
    occurred_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for common analytical queries
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_location ON inventory(location_id);
CREATE INDEX idx_movements_product ON inventory_movements(product_id);
CREATE INDEX idx_movements_occurred_at ON inventory_movements(occurred_at);

-- End of schema
