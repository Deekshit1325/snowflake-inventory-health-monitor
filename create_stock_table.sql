CREATE DATABASE INVENTORY_DB;
USE DATABASE INVENTORY_DB;
USE SCHEMA PUBLIC;
CREATE OR REPLACE TABLE STOCK_DAILY (
    location STRING,
    item STRING,
    opening_stock INT,
    received INT,
    issued INT,
    closing_stock INT,
    lead_time_days INT,
    stock_date DATE
);

INSERT INTO STOCK_DAILY VALUES
('Warehouse_A', 'Rice', 500, 100, 180, 420, 5, '2025-01-01'),
('Warehouse_A', 'Wheat', 300, 50, 120, 230, 7, '2025-01-01'),
('Warehouse_B', 'Rice', 200, 30, 90, 140, 4, '2025-01-01'),
('Warehouse_B', 'Oil', 150, 20, 70, 100, 6, '2025-01-01'),
('Warehouse_C', 'Rice', 100, 10, 60, 50, 3, '2025-01-01');

SELECT * FROM STOCK_DAILY;

SELECT
    location,
    item,
    closing_stock,
    lead_time_days,
    CASE
        WHEN closing_stock < (lead_time_days * 20)
        THEN '⚠️ LOW STOCK'
        ELSE 'OK'
    END AS stock_status
FROM STOCK_DAILY;

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

CREATE OR REPLACE VIEW STOCK_HEALTH_VIEW AS
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

SELECT * FROM STOCK_HEALTH_VIEW;
