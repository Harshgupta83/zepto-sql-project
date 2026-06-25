
CREATE TABLE zepto(
	sku_id SERIAL PRIMARY KEY,
	Category VARCHAR(100),
	name VARCHAR(100) NOT NULL,
	mrp NUMERIC(10,2),
	discountPercent NUMERIC(10,2),
	availableQuantity INT,
	discountedSellingPrice NUMERIC(10,2),
	weightInGms INT,
	outOfStock BOOLEAN,
	quantity INT
);

SELECT * FROM zepto;

-- DATA EXPLORATION

-- count of rows
 SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto
LIMIT 10;

-- null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL;

-- different product categories
 SELECT DISTINCT category
 FROM zepto;

-- products in stock vs out of stock
 SELECT outofstock, COUNT(sku_id)
 FROM zepto
 GROUP BY outofstock;

-- product names present multiple times
 SELECT name, COUNT(sku_id)
 FROM zepto
 GROUP BY name
 HAVING COUNT(sku_id) > 1;

-- DATA CLEANING

-- product with price = 0
 SELECT * FROM zepto
 WHERE mrp = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- convert paise to rupees
 UPDATE zepto
 SET mrp = mrp/100.0,
 discountedsellingprice = discountedsellingprice/100.0;

-- 1) find the top 10 best-value products based on discount percentage.
 SELECT DISTINCT name, mrp, discountpercent AS max_discount
 FROM zepto
 ORDER BY discountpercent DESC
 LIMIT 10;

-- 2) what are the products high-MRP products but out of stock.
 SELECT DISTINCT name, mrp
 FROM zepto
 WHERE outofstock = true AND mrp > 300
 ORDER BY mrp DESC;

-- 3) calculate Estimated revenue for each product category.
 SELECT category, SUM(discountedsellingprice * availablequantity) AS total_revenue
 FROM zepto
 GROUP BY category
 ORDER BY total_revenue;

-- 4) find all the products where mrp is greater than rupee 500 & discount < 10%.
 SELECT DISTINCT name, mrp, discountpercent
 FROM zepto
 WHERE mrp > 500 AND discountpercent < 10;

-- 5) identify the top 5 categories offering the highest average discount percentage.
 SELECT DISTINCT category, ROUND(AVG(discountpercent),2)
 FROM zepto
 GROUP BY category
 ORDER BY ROUND(AVG(discountpercent),2) DESC
 LIMIT 5;
 

-- 6) Calculated price per gram for products above 100g and sort by best value.
 SELECT DISTINCT name, weightingms, discountedsellingprice, round(discountedsellingprice/weightingms,2) AS price_per_gram
 FROM zepto
 WHERE weightingms > 100
 ORDER BY price_per_gram;
 
-- 7) Group the products into categories like Low, Medium, and Bulk.
 SELECT DISTINCT name, weightingms,
 CASE WHEN weightingms < 1000 THEN 'Low'
      WHEN weightingms <5000 THEN 'Medium'
	  ELSE 'Bulk'
	  END AS weight_category
	  FROM zepto;

-- 8) what is the total inventory weight per category.
 SELECT DISTINCT category, SUM(weightingms * availablequantity) AS total_weight
 FROM zepto
 GROUP BY category
 ORDER BY total_weight;

































































