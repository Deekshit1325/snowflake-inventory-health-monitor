CREATE OR REPLACE DYNAMIC TABLE STOCK_HEALTH_DT
TARGET_LAG = '1 day'
WAREHOUSE = COMPUTE_WH
AS
SELECT
  location,
  item,
  closing_stock,
  lead_time_days,
  CASE
    WHEN closing_stock < (lead_time_days * 20)
    THEN 'LOW STOCK'
    ELSE 'OK'
  END AS stock_status,
  CASE
    WHEN closing_stock < (lead_time_days * 20)
    THEN (lead_time_days * 20) - closing_stock
    ELSE 0
  END AS reorder_quantity
FROM STOCK_DAILY;

SELECT * FROM STOCK_HEALTH_DT;

CREATE OR REPLACE DYNAMIC TABLE STOCK_HEALTH_DT
WAREHOUSE = COMPUTE_WH
TARGET_LAG = '1 minute'
AS
SELECT
    location,
    item,
    closing_stock,
    lead_time_days,
    CASE
        WHEN closing_stock < (lead_time_days * 20) THEN 'LOW STOCK'
        ELSE 'OK'
    END AS stock_status,
    CASE
        WHEN closing_stock < (lead_time_days * 20)
        THEN (lead_time_days * 20) - closing_stock
        ELSE 0
    END AS reorder_quantity
FROM STOCK_DAILY;
