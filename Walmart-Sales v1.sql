/* 

									Walmart Salesn

		Approach Used: Dat Wrangling, Feature Engineering, Exploratory Data Analysis

*/


Select *
From PortfolioProject..WalmartSales


-- Adding New Column time_of_day


Select
	TIME,
	(
	CASE
		WHEN CAST(time as time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN CAST(time AS time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		Else 'Evening'
	END) As time_of_day
From
	PortfolioProject..WalmartSales


ALTER TABLE WalmartSales ADD time_of_day VARCHAR(20)


UPDATE WalmartSales
SET time_of_day = (
	CASE
		WHEN CAST(time as time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN CAST(time AS time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		Else 'Evening'
	END)



-- Adding A New Column day_name


Select
	date,
	DATENAME(WEEKDAY, date) as Day_name
From
	PortfolioProject..WalmartSales


ALTER TABLE WalmartSales ADD day_name VARCHAR(10)


UPDATE WalmartSales
SET day_name = DATENAME(WEEKDAY, date)



-- Adding A New Column month_name


Select
	date,
	DATENAME(MONTH, date) as month_name
From
	PortfolioProject..WalmartSales


ALTER TABLE WalmartSales ADD month_name VARCHAR(30)

UPDATE WalmartSales
SET month_name = DATENAME(MONTH, date)



-- How Many Unique Cities Does Walmart Have?


Select
	DISTINCT(city)
From
	PortfolioProject..WalmartSales



-- How Many Branches Does The Data Have?


Select
	DISTINCT(branch)
From
	PortfolioProject..WalmartSales



-- In Which City Is Each Branch?


Select
	DISTINCT(city),
	branch
From
	PortfolioProject..WalmartSales



-- How Many Uniques Product Lines Does The Data Have?


Select 
	COUNT(DISTINCT product_line)
From
	PortfolioProject..WalmartSales



-- What is the most common payment method?


Select 
	payment,
	COUNT(payment) as payment_method
From
	PortfolioProject..WalmartSales
Group by 
	payment
Order by
	payment_method DESC



-- What Is The Most Selling Product Line?


Select
	product_line,
	COUNT(product_line) as count_product_line
From
	PortfolioProject..WalmartSales
Group by
	Product_line
Order by
	count_product_line DESC



-- What Is The Total Revenue By Month?


Select
	month_name,
	ROUND(SUM(total),2) as Total_revenue
From
	PortfolioProject..WalmartSales
Group by
	month_name
Order by
	Total_revenue DESC



-- What Month Had The Largest COGS?


Select
	month_name,
	ROUND(SUM(cogs),2) as Total_cogs
From
	PortfolioProject..WalmartSales
Group by
	month_name
Order by
	Total_cogs DESC



-- Which Product Line Had The Largest Revenue


Select
	Product_line,
	ROUND(SUM(total),2) as Total_revenue
From
	PortfolioProject..WalmartSales
Group by
	Product_line
Order by
	Total_revenue DESC



-- What City Had The Largest Revenue


Select
	City,
	branch,
	ROUND(SUM(total), 2) as Total_revenue
From
	PortfolioProject..WalmartSales
Group by
	City,
	Branch
Order by
	Total_revenue DESC



-- What Product Line Had The Highest Average VAT?


Select
	Product_line,
	ROUND(AVG(Tax), 2) as avg_tax
From
	PortfolioProject..WalmartSales
Group by
	Product_line
Order by
	avg_tax DESC



-- Which Branch Sold More Products Than The Average Product Sold?


Select
	Branch,
	city,
	SUM(Quantity) as Total_quantity
From
	PortfolioProject..WalmartSales
Group by
	Branch, 
	city
Having SUM(quantity) > (Select AVG(quantity) From PortfolioProject..WalmartSales)
Order by
	Total_quantity DESC



-- What Is The Most Common Product Line By Gender?


Select
	gender,
	product_line,
	COUNT(gender) as Total_gender
From
	PortfolioProject..WalmartSales
Group by
	gender,
	product_line
Order by
	Total_gender DESC



-- What Is The Average Rating Of Each Product Line?


Select
	product_line,
	ROUND(AVG(Rating), 2) as avg_rating
From
	PortfolioProject..WalmartSales
Group by
	gender,
	product_line
Order by
	avg_rating DESC



-- Number Of Sales Made In Each Day Per Weekday


Select
	time_of_day,
	COUNT(*) AS Total_sales
From
	PortfolioProject..WalmartSales
Where
	day_name = 'FRIDAY'
Group by
	time_of_day
Order by
	Total_sales DESC



-- Fetch Each Product Line And Add A Column To Those Product

-- Line Showing "Good" or "Bad". Good If Its Greater Than Average Sales


SELECT 
	AVG(quantity) AS avg_qnty
FROM PortfolioProject..WalmartSales

	
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM PortfolioProject..WalmartSales
GROUP BY product_line



-- Which Customer Type Brought The Most Revenue


Select
	Customer_type,
	ROUND(SUM(total), 2) as total_revenue
From
	PortfolioProject..WalmartSales
Group by
	Customer_type
Order by
	total_revenue DESC



-- Which City Had The Highest Tax Percent/ VAT


Select
	branch,
	City,
	ROUND(AVG(Tax),2) as avg_VAT
From
	PortfolioProject..WalmartSales
Group by
	branch,
	City
Order by
	avg_VAT DESC



-- Which Customer Type Paid The Highest VAT?


Select
	Customer_type,
	ROUND(AVG(Tax), 2) as avg_VAT
From
	PortfolioProject..WalmartSales
Group by
	Customer_type
Order by
	avg_VAT DESC



-- How Many Unique Customer Types Does The Data Have?


Select
	DISTINCT(Customer_type)
From
	PortfolioProject..WalmartSales
Group by
	Customer_type



-- How many unique payment types does the data have?


Select
	DISTINCT(Payment)
From
	PortfolioProject..WalmartSales



-- Which Customer Type Bought The Most?


Select
	Customer_type,
	COUNT(*) As customer_count
From
	PortfolioProject..WalmartSales
Group by
	Customer_type
Order by
	customer_count DESC



-- What Is The Gender Of Most Of The Customer?


Select
	Gender,
	COUNT(*) AS gender_count
From
	PortfolioProject..WalmartSales
Group by
	Gender
Order by
	gender_count DESC



-- What Is The Gender Distribution Per Branch?


Select
	Gender,
	COUNT(*) AS gender_count
From
	PortfolioProject..WalmartSales
Where
	Branch = 'A' 
Group by
	Gender
Order by
	gender_count DESC



-- Which Time Of The Day Did Customers Give Most Ratings?


Select
	time_of_day,
	ROUND(AVG(Rating), 2) AS AVG_ratings
From
	PortfolioProject..WalmartSales
Group by
	time_of_day
Order by
	AVG_ratings DESC



-- Which Time Of The Day Did Customers Give Most Ratings Per Branch?


Select
	time_of_day,
	ROUND(AVG(Rating), 2) AS AVG_ratings
From
	PortfolioProject..WalmartSales
Where
	Branch = 'B'
Group by
	time_of_day
Order by
	AVG_ratings DESC



-- Which Day Of The week Had The Best Average Ratings?


Select
	day_name,
	ROUND(AVG(Rating), 2) AS AVG_ratings
From
	PortfolioProject..WalmartSales
Group by
	day_name
Order by
	AVG_ratings DESC



-- Which Day of The Week Had The Best Average Ratings Per Branch?


Select
	day_name,
	ROUND(AVG(Rating), 2) AS AVG_ratings
From
	PortfolioProject..WalmartSales
Where
	Branch = 'A'
Group by
	day_name
Order by
	AVG_ratings DESC



-- Total For Quantity, Unit Price, Total Revenue and COGS


Select
	ROUND(SUM(total),2) as Total_revenue,
	ROUND(SUM(Unit_price),2) as Total_unit_price,
	ROUND(SUM(Quantity),2) as Total_quantity,
	ROUND(SUM(Unit_price) * SUM(Quantity),2) As COGS
From
	PortfolioProject..WalmartSales
Order by
	COGS DESC



-- Looking At Adding VAT 5% To The COGS

-- NOTE: VAT is added to the COGS and this is what is billed to the customers


Select
	branch,
	city,
	cogs,
	ROUND((cogs * 0.05), 2) As VAT
From
	PortfolioProject..WalmartSales
Group by
	branch,
	city,
	cogs
Order by
	VAT DESC



-- Looking At The Total Gross Sales Per Branch


Select
	Branch,
	City,
	ROUND(AVG(Tax),2) As Total_VAT,
	ROUND(SUM(cogs),2) As Total_cogs,
	ROUND(SUM(Tax) + SUM(cogs), 2) As total_gross_sales
From
	PortfolioProject..WalmartSales
Group by
	Branch,
	City
Order by
	total_gross_sales DESC



-- Looking At The Total Gross Income Per Branch


Select
	Branch,
	City,
	ROUND(SUM(Total),2) As Total_Revenue,
	ROUND(SUM(cogs),2) As Total_cogs,
	ROUND(SUM(Total) - SUM(cogs), 2) As total_gross_income
From
	PortfolioProject..WalmartSales
Group by
	Branch,
	City
Order by
	total_gross_income DESC



-- Cities With Highest Quantities Compared To Total Revenue


Select
	Branch,
	City,
	MAX(Quantity) As Highest_Quantity,
	ROUND(MAX(total), 2) as Highest_Revenue,
	ROUND(MAX(quantity/total), 4) *100 As PercentQuantityTotal
From
	PortfolioProject..WalmartSales
Where
	Branch is not null
Group by
	Branch,
	City
Order by
	PercentQuantityTotal DESC



-- Looking At The Gross Margin Percent


Select
	branch,
	city,
	MAX(gross_income) as Highest_gross_income,
	ROUND(MAX(total), 2) as Highest_Revenue,
	ROUND(MAX(gross_income/total), 5) *100 As PercentGrossMargin
From
	PortfolioProject..WalmartSales
Where
	Branch is not null
Group by
	Branch,
	City
Order by
	PercentGrossMargin DESC
