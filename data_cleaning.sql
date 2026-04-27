-- ============================================
-- WMS DATA CLEANING
-- ============================================

-- ============================================
-- Query 1: Location Code Standardization
-- Purpose: Clean inconsistent location codes and split into aisle, rack, bin
-- Skills: CTE, UPPER, REPLACE, LEFT, SUBSTRING, RIGHT
-- ============================================

with cleaned as (
    select 
        raw_loc_code,
        quantity,
        upper(replace(replace(raw_loc_code, '-', ''), ' ', '')) as clean_string
    from raw_locations
)
select 
    raw_loc_code,
    left(clean_string, 1) as clean_aisle,
    substring(clean_string, 2, 2) as clean_rack,
    right(clean_string, 2) as clean_bin,
    quantity
from cleaned
order by clean_aisle, clean_rack, clean_bin;

-- ============================================
-- Query 2: Lot Number Parsing
-- Purpose: Extract year, month, SKU, and batch from lot numbers
-- Skills: CTE, SUBSTRING_INDEX
-- ============================================

with parsed as (
    select 
        lot_number,
        quantity,
        substring_index(lot_number, '-', 1) as year,
        substring_index(substring_index(lot_number, '-', 2), '-', -1) as month,
        substring_index(substring_index(lot_number, '-', 3), '-', -1) as sku,
        substring_index(lot_number, '-', -1) as batch
    from inventory_lots
)
select 
    lot_number,
    year,
    month,
    sku,
    batch,
    quantity
from parsed
order by year desc, month desc;
