-- ============================================
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
