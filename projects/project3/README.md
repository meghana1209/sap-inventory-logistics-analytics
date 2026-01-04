# Project 3 — Inventory Management & Stock Optimization (SAP HANA)

Overview
-
Inventory Management and Stock Optimization implemented for SAP HANA. This project demonstrates schema design using column tables, SQLScript procedures, trigger examples, and analytical queries to identify low-stock, over-stock, and reorder points.

What it contains
-
- `hana_schema.sql` — HANA column table definitions for products, suppliers, locations, inventory, shipments, orders, and movements.
- `hana_functions.sql` — SQLScript procedure `CALCULATE_REORDER_POINT` and trigger example to keep inventory snapshots current.
- `analysis_queries.sql` — Key queries: products below reorder, fast vs slow movers, stock valuation.
- `sample_data_hana.sql` — Sample inserts to populate tables for testing.

Concepts used
-
- SAP HANA column tables
- SQLScript procedures
- Triggers (example merge-based pattern)
- Real-time analytics and lightweight materialization patterns

How to run (local HANA)
-
1. Load schema: `hdbsql -n <host:port> -u <user> -p <pass> -I hana_schema.sql`
2. Load sample data: `hdbsql -n <host:port> -u <user> -p <pass> -I sample_data_hana.sql`
3. Create procedures and triggers: `hdbsql -n <host:port> -u <user> -p <pass> -I hana_functions.sql`
4. Run analysis queries with `hdbsql` or a SQL client.

Resume bullets (example)
-
- Inventory Management & Stock Optimization using SAP HANA
  • Designed column-store schema and load strategy for real-time inventory analytics
  • Implemented SQLScript procedures to compute reorder points and safety stock
  • Built queries to flag stockouts, optimize reorder timing, and produce valuation reports
