/* This script is a complement of an article, that you can check on my profile:
https://medium.com/@lmmfrederico
*/

-- This first query will compare stock price by day
WITH temp_table AS (
SELECT
	Date, 
	ROUND(Adj_Close, 2) AS actual_price,
	ROUND(LAG(Adj_Close, 1) OVER (
			ORDER BY Date), 2) AS one_day_before_price 	
FROM bac_stock
)
SELECT 
	Date, actual_price, one_day_before_price,
	-- The FORMAT function will display the values in percentage with the command 'P'
	FORMAT(
	(actual_price - one_day_before_price) / one_day_before_price, 
	'P') AS pct_change 
FROM temp_table;

-- The second query below will aggregate the average stock price for each month and compare the prices

WITH temp_table AS (
SELECT year_, month_, avg_month_price,
	ROUND(
-- We make the LAG using the calculated field we have done in the FROM statement
		LAG (avg_month_price, 1) OVER(
		ORDER BY year_, month_), 2) AS prev_avg_month_price
-- We need to add a subquery inside FROM to calculate the monthly average
FROM (
	SELECT year(Date) AS year_, month(Date) AS month_,
		ROUND(AVG(adj_close), 2) AS avg_month_price
	FROM bac_stock
	GROUP BY YEAR(Date), MONTH(Date)) x
)
SELECT year_, month_, avg_month_price, prev_avg_month_price,
	FORMAT(
		(avg_month_price - prev_avg_month_price) / prev_avg_month_price, 
		'P') AS pct_difference    
FROM temp_table
ORDER BY year_, month_; -- we use ORDER BY to correctly define the order of time