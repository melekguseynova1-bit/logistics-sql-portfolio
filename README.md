# logistics-sql-portfolio
SQL queries for logistics and warehouse analytics.  Inventory, shipments, picker productivity, cycle counting.
# Logistics SQL Portfolio

## About Me
Learning SQL for a career in logistics and warehouse analytics. 
This repository contains queries I wrote and debugged myself 
while practicing on simulated warehouse data.

## Skills
- SELECT, JOINs (INNER, LEFT), GROUP BY, HAVING
- CTEs (WITH clauses)
- Window Functions: RANK, LAG, LEAD, SUM OVER
- Date functions: DATEDIFF, INTERVAL
- String functions: UPPER, REPLACE, SUBSTRING_INDEX
- CASE WHEN for business logic
- UNION ALL for combining data

## Projects

### 1. Inventory Health Dashboard
Tracks empty bins, inventory aging, and low-stock alerts 
to identify dead stock and prioritize replenishment.
- File: `inventory_health.sql`

### 2. Warehouse Performance Report
Ranks picker productivity by shift, calculates running totals 
for dock door utilization, and measures carrier on-time delivery rates.
- File: `warehouse_performance.sql`

### 3. WMS Data Cleaning
Standardizes messy location codes and parses lot numbers 
into structured components for accurate reporting.
- File: `data_cleaning.sql`

### 4. Cycle Count Variance
Compares system inventory records against physical counts 
to identify shrinkage and discrepancies by location.
- File: `cycle_count.sql`

## Tools
- MySQL
- DB Fiddle / SQLite Online (for testing)

## Contact
melekintigam@gmail.com
