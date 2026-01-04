# 📊 SQL Scripts - Inventory Management System

This folder contains comprehensive SQL scripts for the SAP HANA Inventory Management & Stock Optimization project.

## 📁 File Structure

### 1. **01_create_schema.sql**
- Creates the main schema: `INVENTORY_MGMT`
- Defines 4 core tables:
  - `PRODUCT` - Master product information
  - `INVENTORY` - Stock levels
  - `SALES` - Transaction history
  - `INVENTORY_AUDIT` - Change tracking
- Includes indexes for performance optimization
- Creates sequences for auto-increment IDs

**Run First!** This initializes the database structure.

---

### 2. **02_sample_data.sql**
- Inserts 10 sample products (Electronics, Accessories, Furniture)
- Populates inventory levels with realistic stock quantities
- Adds 15 sales transactions for analysis
- Includes edge cases:
  - Products below reorder level
  - High-selling items
  - Slow-moving products

**Run After:** `01_create_schema.sql`

---

### 3. **03_stored_procedures.sql**
- **SP_UPDATE_INVENTORY_AFTER_SALE** - Reduces stock after sale with validation
- **SP_CHECK_LOW_STOCK** - Identifies items needing reorder
- **SP_STOCK_VALUATION_REPORT** - Calculates inventory value
- **SP_SALES_VELOCITY_ANALYSIS** - Classifies fast/slow-moving products
- **SP_REORDER_RECOMMENDATIONS** - Suggests purchase quantities

**Usage:**
```sql
CALL INVENTORY_MGMT.SP_CHECK_LOW_STOCK();
CALL INVENTORY_MGMT.SP_SALES_VELOCITY_ANALYSIS(30);
```

---

### 4. **04_triggers.sql**
- **TR_INVENTORY_AUDIT_UPDATE** - Auto-logs inventory changes
- **TR_PRODUCT_MODIFIED_DATE** - Updates modification timestamp
- **TR_VALIDATE_STOCK_QTY** - Prevents negative stock
- **TR_VALIDATE_SALES_QTY** - Ensures valid sales data
- **TR_INVENTORY_AUDIT_INSERT** - Tracks new inventory entries

These run automatically on INSERT/UPDATE operations.

---

### 5. **05_analytics_views.sql**
Creates 7 pre-built analytical views:

| View Name | Purpose |
|-----------|---------|
| `V_LOW_STOCK_ALERT` | Dashboard for critical stock levels |
| `V_INVENTORY_VALUATION` | Stock value by product |
| `V_CATEGORY_SUMMARY` | Category-wise inventory analysis |
| `V_SALES_PERFORMANCE` | Product sales metrics |
| `V_WAREHOUSE_DISTRIBUTION` | Inventory across warehouses |
| `V_INVENTORY_AGING` | How long stock hasn't been updated |
| `V_FAST_MOVING_PRODUCTS` | High-velocity product analysis |

**Query directly:**
```sql
SELECT * FROM INVENTORY_MGMT.V_LOW_STOCK_ALERT;
SELECT * FROM INVENTORY_MGMT.V_SALES_PERFORMANCE;
```

---

### 6. **06_advanced_queries.sql**
Advanced analytics for business intelligence:

| Query | Use Case |
|-------|----------|
| Real-time Status Dashboard | Monitor current inventory health |
| ABC Analysis (Pareto) | Identify high-value products |
| Inventory Turnover | Measure product velocity |
| Economic Order Quantity | Calculate optimal order quantities |
| Monthly Sales Trends | Track revenue patterns |
| Dead Stock Analysis | Identify slow-moving items |
| Warehouse Efficiency | Compare warehouse performance |
| Stock-Out Revenue Risk | Quantify lost sales risk |

---

## 🚀 Execution Steps

### Step 1: Initialize Database
```sql
-- Run schema creation
@01_create_schema.sql
```

### Step 2: Load Sample Data
```sql
-- Insert test data
@02_sample_data.sql
```

### Step 3: Create Stored Procedures
```sql
-- Deploy business logic
@03_stored_procedures.sql
@04_triggers.sql
```

### Step 4: Create Analytics Layer
```sql
-- Build analytical views
@05_analytics_views.sql
```

### Step 5: Run Analytics Queries
```sql
-- Execute business intelligence queries
@06_advanced_queries.sql
```

---

## 📌 Common Use Cases

### Check Low Stock Items
```sql
CALL INVENTORY_MGMT.SP_CHECK_LOW_STOCK();
```

### Process a Sale
```sql
CALL INVENTORY_MGMT.SP_UPDATE_INVENTORY_AFTER_SALE(
    P_PRODUCT_ID => 101,
    P_QUANTITY_SOLD => 2,
    P_NEW_STOCK_QTY => ?,
    P_STATUS => ?
);
```

### Get Stock Valuation
```sql
CALL INVENTORY_MGMT.SP_STOCK_VALUATION_REPORT();
```

### Identify Fast-Moving Products
```sql
CALL INVENTORY_MGMT.SP_SALES_VELOCITY_ANALYSIS(30);  -- Last 30 days
```

### Get Reorder Recommendations
```sql
CALL INVENTORY_MGMT.SP_REORDER_RECOMMENDATIONS();
```

---

## 🎯 Key Features Demonstrated

✅ **Column-Store Tables** - SAP HANA's in-memory optimization  
✅ **Indexes** - Performance tuning for joins and filters  
✅ **Stored Procedures** - Encapsulated business logic  
✅ **Triggers** - Automated audit trail and validation  
✅ **Analytics Views** - Pre-built reporting layer  
✅ **Advanced Analytics** - ABC analysis, EOQ, inventory turnover  
✅ **Error Handling** - Validation and constraint enforcement  

---

## 💡 Learning Outcomes

- SAP HANA table design and optimization
- Complex SQL queries with window functions
- Stored procedures and PL/SQL logic
- Trigger-based automation
- Real-world inventory analytics
- Performance tuning techniques

---

## 📊 Sample Queries by Role

**For Warehouse Manager:**
```sql
SELECT * FROM INVENTORY_MGMT.V_LOW_STOCK_ALERT;
SELECT * FROM INVENTORY_MGMT.V_WAREHOUSE_DISTRIBUTION;
```

**For Supply Chain Analyst:**
```sql
CALL INVENTORY_MGMT.SP_SALES_VELOCITY_ANALYSIS(30);
SELECT * FROM INVENTORY_MGMT.V_FAST_MOVING_PRODUCTS;
```

**For Finance Team:**
```sql
CALL INVENTORY_MGMT.SP_STOCK_VALUATION_REPORT();
SELECT * FROM INVENTORY_MGMT.V_CATEGORY_SUMMARY;
```

**For Inventory Planner:**
```sql
CALL INVENTORY_MGMT.SP_REORDER_RECOMMENDATIONS();
SELECT * FROM INVENTORY_MGMT.V_INVENTORY_AGING;
```

---

## 🔗 Integration with Main Project

These scripts are referenced in the main README.md:
- **Database Design** section uses these table structures
- **Key SQL Queries** section shows samples from these scripts
- **How to Run** section directs users to these files

---

## ❓ Troubleshooting

**Schema not found?**
- Ensure all references use `INVENTORY_MGMT.` prefix

**Procedure not created?**
- Check for syntax errors in SQLSCRIPT sections
- Verify stored procedures created successfully

**Triggers not firing?**
- Triggers require INSERT/UPDATE operations to activate
- Check audit table for trigger logs

---

## 📞 Support

For questions on specific scripts, refer to comments in each file.  
All scripts are SAP HANA 2.0+ compatible.

---

**Happy Analytics! 📊** 🚀
