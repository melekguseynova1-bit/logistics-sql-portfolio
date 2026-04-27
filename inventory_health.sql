-- ============================================
-- DATASET SETUP
-- ============================================

-- Locations (warehouse shelves)
CREATE TABLE locations (
    loc_id INTEGER PRIMARY KEY,
    aisle VARCHAR(5),
    rack VARCHAR(5),
    bin VARCHAR(10),
    zone VARCHAR(20)
);

INSERT INTO locations VALUES
(1, 'A', '01', 'A1-01', 'FAST-PICK'),
(2, 'A', '01', 'A1-02', 'FAST-PICK'),
(3, 'A', '02', 'A2-01', 'FAST-PICK'),
(4, 'B', '01', 'B1-01', 'FAST-PICK'),
(5, 'B', '01', 'B1-02', 'RESERVE'),
(6, 'B', '02', 'B2-01', 'RESERVE'),
(7, 'C', '01', 'C1-01', 'BULK'),
(8, 'C', '02', 'C2-01', 'BULK');

-- Inventory (current stock by location)
CREATE TABLE inventory (
    inv_id INTEGER PRIMARY KEY,
    sku VARCHAR(20),
    loc_id INTEGER,
    quantity INTEGER
);

INSERT INTO inventory VALUES
(1, 'WIDGET-A', 1, 25),
(2, 'WIDGET-A', 2, 30),
(3, 'WIDGET-A', 5, 150),
(4, 'WIDGET-B', 3, 12),
(5, 'GADGET-X', 4, 0),
(6, 'CABLE-USB', 6, 200),
(7, 'BOX-MD', 7, 500),
(8, 'LABEL-RL', 8, 75);

-- Inventory Receipts (for aging report)
CREATE TABLE inventory_receipts (
    receipt_id INTEGER PRIMARY KEY,
    sku VARCHAR(20),
    quantity INTEGER,
    receipt_date DATE
);

INSERT INTO inventory_receipts VALUES
(1, 'WIDGET-A', 100, '2026-01-15'),
(2, 'CABLE-USB', 200, '2026-02-20'),
(3, 'WIDGET-A', 50, '2026-03-10'),
(4, 'BOX-MD', 500, '2025-06-01'),
(5, 'TAPE-ROLL', 75, '2026-04-01'),
(6, 'WIDGET-A', 30, '2026-04-10'),
(7, 'LABEL-RL', 150, '2025-11-15'),
(8, 'CABLE-USB', 100, '2026-03-25');

-- ============================================
-- QUERIES BELOW
-- ============================================-- ============================================


-- Query: Inventory Aging Report
-- Purpose: Identify dead stock by days in warehouse
-- Skills: CTE, DATEDIFF, CASE WHEN
-- ============================================

with total_days as (
    select receipt_id, sku, receipt_date, 
           DATEDIFF(CURDATE(), receipt_date) as days_in_wh
    from inventory_receipts
)
select *,
       case 
           when days_in_wh >= 180 then 'DEAD STOCK' 
           when days_in_wh >= 90 then 'AGED' 
           when days_in_wh >= 30 then 'SLOW' 
           else 'FRESH' 
       end as cur_status
from total_days
order by days_in_wh desc;


-- ============================================
-- INVENTORY HEALTH DASHBOARD
-- ============================================

-- ============================================
-- Query 1: Empty Fast-Pick Bins
-- Purpose: Find empty locations in the fast-pick zone
-- Skills: LEFT JOIN, WHERE IS NULL
-- ============================================

select l.loc_id, aisle, inv_id, zone
from locations l
left join inventory i on l.loc_id = i.loc_id
where i.inv_id is null and zone = 'FAST-PICK';


-- ============================================
-- Query 2: Total Inventory Per Aisle
-- Purpose: Count total items on each aisle, including zeros
-- Skills: LEFT JOIN, SUM, COALESCE, GROUP BY
-- ============================================

select l.aisle, coalesce(sum(quantity), 0) as total
from locations l
left join inventory i on l.loc_id = i.loc_id
group by l.aisle;
