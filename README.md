# 📦 Inventory Management & Stock Optimization using SAP HANA

## 📌 Project Overview

This project demonstrates a **real-time inventory management system** built using **SAP HANA in-memory database**.
It helps organizations track stock levels, identify low-stock and over-stock items, and calculate optimal reorder points using fast, in-memory analytics.

The project is designed to showcase **SAP HANA SQL, database modeling, and real-time analytics**, making it suitable for **SAP Associate / HANA Developer roles**.

---

## 🎯 Objectives

* Track real-time product inventory levels
* Identify products below reorder level
* Classify fast-moving and slow-moving products
* Generate stock valuation reports
* Demonstrate SAP HANA's in-memory performance

---

## 🛠️ Technology Stack

* **Database:** SAP HANA Express Edition
* **Language:** SAP HANA SQL
* **Tools:** SAP HANA Studio / SAP Business Application Studio
* **OS:** Windows / Linux

---

## 🗂️ Database Design

### Tables Used

#### 1. PRODUCT

| Column Name   | Data Type     | Description         |
| ------------- | ------------- | ------------------- |
| PRODUCT_ID    | INT           | Unique product ID   |
| PRODUCT_NAME  | NVARCHAR(100) | Product name        |
| CATEGORY      | NVARCHAR(50)  | Product category    |
| UNIT_PRICE    | DECIMAL(10,2) | Price per unit      |
| REORDER_LEVEL | INT           | Minimum stock level |

#### 2. INVENTORY

| Column Name  | Data Type | Description         |
| ------------ | --------- | ------------------- |
| INVENTORY_ID | INT       | Inventory record ID |
| PRODUCT_ID   | INT       | Foreign key         |
| STOCK_QTY    | INT       | Available stock     |
| LAST_UPDATED | DATE      | Last update date    |

#### 3. SALES

| Column Name | Data Type | Description         |
| ----------- | --------- | ------------------- |
| SALE_ID     | INT       | Sale transaction ID |
| PRODUCT_ID  | INT       | Product sold        |
| QUANTITY    | INT       | Quantity sold       |
| SALE_DATE   | DATE      | Date of sale        |

---

## ⚙️ Features Implemented

✔ Real-time stock monitoring
✔ Low-stock and over-stock identification
✔ Reorder point calculation
✔ Fast-moving vs slow-moving item analysis
✔ Inventory valuation reporting

---

## 📊 Key SQL Queries

### 🔹 Products Below Reorder Level

```sql
SELECT P.PRODUCT_NAME, I.STOCK_QTY, P.REORDER_LEVEL
FROM PRODUCT P
JOIN INVENTORY I ON P.PRODUCT_ID = I.PRODUCT_ID
WHERE I.STOCK_QTY < P.REORDER_LEVEL;
```

---

### 🔹 Fast-Moving vs Slow-Moving Products

```sql
SELECT PRODUCT_ID,
       SUM(QUANTITY) AS TOTAL_SALES
FROM SALES
GROUP BY PRODUCT_ID
ORDER BY TOTAL_SALES DESC;
```

---

### 🔹 Stock Valuation Report

```sql
SELECT P.PRODUCT_NAME,
       I.STOCK_QTY,
       P.UNIT_PRICE,
       (I.STOCK_QTY * P.UNIT_PRICE) AS STOCK_VALUE
FROM PRODUCT P
JOIN INVENTORY I ON P.PRODUCT_ID = I.PRODUCT_ID;
```

---

## 🧠 SAP HANA Concepts Used

* Column-store tables
* SAP HANA SQL
* Joins and aggregations
* Stored procedures
* Triggers for real-time updates
* In-memory analytics

---

## 🚀 How to Run This Project

1. Install **SAP HANA Express Edition**
2. Open **SAP HANA Studio**
3. Create schema and tables using provided SQL scripts
4. Insert sample data
5. Execute analytics queries
6. View real-time results

---

## 📈 Results & Insights

* Enabled instant identification of low-stock products
* Improved inventory decision-making using real-time analytics
* Demonstrated faster query execution using in-memory processing

---

## 📚 Learning Outcomes

* Hands-on experience with SAP HANA architecture
* Strong understanding of inventory analytics
* Practical exposure to enterprise-level database design
* Resume-ready SAP HANA project

---

## 🔮 Future Enhancements

* Integration with SAP Fiori dashboard
* Predictive reorder point calculation
* Supplier performance analysis

---

## 👩‍💻 Author

**Meghana B**
Final-year BE – Artificial Intelligence & Data Science
Aspiring SAP HANA / SAP Associate Consultant

---

## ⭐ Why This Project Matters

This project reflects **real-world supply chain analytics** and demonstrates skills relevant to **SAP HANA Associate, BASIS, and Data Analytics roles**, making it ideal for campus placements and entry-level SAP positions.
