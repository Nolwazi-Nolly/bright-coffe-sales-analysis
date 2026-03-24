--SELECT * FROM dbo.coffee;

SELECT 
transaction_id,
transaction_date,
transaction_time,
DATEPART(hour,transaction_time) Hour_of_day,
CASE 
   WHEN DATEPART(hour,transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
   WHEN DATEPART(hour,transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
   WHEN DATEPART(hour,transaction_time) >= 17 THEN 'Evening'
   END AS Time_classification,
transaction_qty,
store_location,
product_category,
unit_price,
unit_price * transaction_qty AS Revenue,
DATENAME(weekday,transaction_date) AS Day,
CASE 
   WHEN DATENAME(weekday,transaction_date) IN ('sunday','Saturday') THEN 'Weekend'
   ELSE 'Weekday'
END AS Day_classification,
DATENAME(month,transaction_date) Month,
DATEPART(quarter, transaction_date) Quarter
FROM dbo.coffee;
--------------------------------------------------------------------------------------------------------------------------------
 SELECT* 
      FROM(
SELECT store_location,
       product_category,
       SUM(transaction_qty) AS Total_sold,
       ROW_NUMBER() OVER (PARTITION BY store_location ORDER BY SUM(transaction_qty) DESC) AS Rank_number
       FROM dbo.coffee
       GROUP BY store_location, product_category
       )t WHERE Rank_number IN (1,9);
----------------------------------------------------------------------------------------------------------------------------------  
  SELECT product_category,
         COUNT(product_id) AS number_of_sales,
         SUM(unit_price * transaction_qty) AS total_revenue
         FROM dbo.coffee
         GROUP BY product_category
         ORDER BY total_revenue DESC;
