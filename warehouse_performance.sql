-- ============================================
-- DATASET SETUP
-- ============================================

-- Picker Activity
CREATE TABLE picker_activity (
    activity_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    picker_id INTEGER,
    shift VARCHAR(20),
    order_id INTEGER,
    sku VARCHAR(20),
    quantity_picked INTEGER,
    pick_date DATE
);

INSERT INTO picker_activity (picker_id, shift, order_id, sku, quantity_picked, pick_date) VALUES
(101, 'Morning', 1001, 'Widget', 5, '2026-04-18'),
(101, 'Morning', 1002, 'Cable', 10, '2026-04-18'),
(102, 'Morning', 1003, 'Box', 20, '2026-04-18'),
(103, 'Afternoon', 1004, 'Tape', 8, '2026-04-18'),
(103, 'Afternoon', 1005, 'Widget', 12, '2026-04-18'),
(104, 'Afternoon', 1006, 'Cable', 15, '2026-04-18'),
(104, 'Afternoon', 1007, 'Box', 25, '2026-04-18');

-- Dock Activity
CREATE TABLE dock_activity (
    door_id INTEGER,
    activity_date DATE,
    pallets_processed INTEGER
);

INSERT INTO dock_activity VALUES
(1, '2026-04-01', 45),
(1, '2026-04-02', 52),
(1, '2026-04-03', 38),
(1, '2026-04-04', 60),
(2, '2026-04-01', 30),
(2, '2026-04-02', 28),
(2, '2026-04-03', 35),
(2, '2026-04-04', 32),
(3, '2026-04-01', 55),
(3, '2026-04-02', 60),
(3, '2026-04-03', 48),
(3, '2026-04-04', 50);

-- Shipments
CREATE TABLE shipments (
    shipment_id INTEGER PRIMARY KEY,
    carrier VARCHAR(20),
    promised_date DATE,
    actual_date DATE,
    pallets INTEGER
);

INSERT INTO shipments VALUES
(1, 'FedEx', '2026-04-01', '2026-04-01', 12),
(2, 'FedEx', '2026-04-03', '2026-04-05', 8),
(3, 'FedEx', '2026-04-05', '2026-04-04', 15),
(4, 'FedEx', '2026-04-07', '2026-04-10', 10),
(5, 'UPS', '2026-04-01', '2026-04-01', 20),
(6, 'UPS', '2026-04-03', '2026-04-03', 14),
(7, 'UPS', '2026-04-05', '2026-04-04', 18),
(8, 'UPS', '2026-04-07', '2026-04-07', 22),
(9, 'DHL', '2026-04-02', '2026-04-03', 16),
(10, 'DHL', '2026-04-04', '2026-04-04', 10),
(11, 'DHL', '2026-04-06', '2026-04-09', 8),
(12, 'DHL', '2026-04-08', '2026-04-08', 12);

-- ============================================
-- QUERIES BELOW
-- ============================================-- ============================================
-- WAREHOUSE PERFORMANCE REPORT
-- ============================================


-- ============================================
-- Query 1: Picker Ranking by Shift
-- Purpose: Rank pickers within each shift by total units picked
-- Skills: CTE, RANK() OVER, PARTITION BY
-- ============================================

with total_picked as (
    select picker_id, shift, sum(quantity_picked) as total
    from picker_activity
    group by picker_id, shift
)
select picker_id, shift, total,
       rank() over (partition by shift order by total desc) as rnk
from total_picked
order by shift, rnk;

-- ============================================
-- WAREHOUSE PERFORMANCE REPORT
-- ============================================

-- ============================================
-- Query 1: Picker Ranking by Shift
-- Purpose: Rank pickers within each shift by total units picked
-- Skills: CTE, RANK() OVER, PARTITION BY
-- ============================================

with total_picked as (
    select picker_id, shift, sum(quantity_picked) as total
    from picker_activity
    group by picker_id, shift
)
select picker_id, shift, total,
       rank() over (partition by shift order by total) as rnk
from total_picked
order by shift, rnk;

-- ============================================
-- Query 2: Running Total Per Dock Door
-- Purpose: Cumulative pallets processed per door over time
-- Skills: SUM() OVER, PARTITION BY, GROUP BY
-- ============================================

select door_id, activity_date, 
       sum(sum(pallets_processed)) over (partition by door_id order by activity_date) as total
from dock_activity
group by door_id, activity_date
order by door_id, activity_date;

-- ============================================
-- Query 3: Carrier Performance
-- Purpose: On-time vs late percentage by carrier
-- Skills: CTE, CASE WHEN, Window Function
-- ============================================

with carrier_performance as (
    select 
        carrier,
        case when actual_date <= promised_date then 'ON TIME' else 'LATE' end as statuss,
        count(*) as quantity
    from shipments
    group by carrier, statuss
)
select 
    carrier,
    statuss,
    quantity,
    round(quantity * 100.0 / sum(quantity) over (partition by carrier), 2) as percentage
from carrier_performance
order by carrier, statuss;
