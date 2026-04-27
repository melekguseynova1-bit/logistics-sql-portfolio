-- ============================================
-- CYCLE COUNT VARIANCE REPORT
-- ============================================

-- ============================================
-- Query: System vs Physical Count
-- Purpose: Compare WMS inventory records to physical counts
-- Skills: JOIN, CASE WHEN
-- ============================================

select 
    s.sku,
    s.loc_id,
    s.system_qty,
    p.counted_qty,
    p.counted_qty - s.system_qty as variance,
    case 
        when p.counted_qty - s.system_qty = 0 then 'MATCH'
        when p.counted_qty - s.system_qty > 0 then 'OVER'
        when p.counted_qty - s.system_qty >= -5 then 'SHORT'
        when p.counted_qty - s.system_qty < -5 then 'MAJOR LOSS'
    end as status
from system_inventory s
join physical_count p on s.sku = p.sku and s.loc_id = p.loc_id
order by variance asc;
