-- Intermediate SQL

-- 2: SQL COUNT
SELECT COUNT(low) As low
FROM tutorial.aapl_historical_stock_price;

SELECT COUNT(year) As year,
  COUNT(month) As month,
  COUNT(open) As open,
  COUNT(high) As high,
  COUNT(low) As low,
  COUNT(close) As close,
  COUNT(volume) As volume
FROM tutorial.aapl_historical_stock_price;

-- 3: SQL SUM
SELECT SUM(open) / COUNT(open) As avg_open
FROM tutorial.aapl_historical_stock_price;

-- 4: SQL MIN/MAX
SELECT MIN(low) AS min_price
FROM tutorial.aapl_historical_stock_price;

SELECT MAX(close - open) As highest_sharevalue
FROM tutorial.aapl_historical_stock_price;
