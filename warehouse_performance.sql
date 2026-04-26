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
