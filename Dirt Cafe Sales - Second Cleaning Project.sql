SELECT *
FROM dirty_cafe_sales;

-- 0. Make a Staging Table 
-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Null and Blank Values
-- 4. Remove Any Columns 





CREATE TABLE cafe_sales_staging
LIKE dirty_cafe_sales;

INSERT cafe_sales_staging
SELECT *
FROM dirty_cafe_sales;

SELECT * 
FROM cafe_sales_staging;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Transaction ID`) AS row_num
FROM cafe_sales_staging
ORDER BY 1;

SELECT DISTINCT `Item`
FROM cafe_sales_staging;

SELECT *
FROM cafe_sales_staging
WHERE `Item` = '' OR `Item` = 'UNKNOWN';

UPDATE cafe_sales_staging
SET `Transaction Date` = NULL 
WHERE `Transaction Date` = '';

UPDATE cafe_sales_staging
SET `Transaction Date` = NULL 
WHERE `Transaction Date` = 'ERROR';

UPDATE cafe_sales_staging
SET `Transaction Date` = NULL 
WHERE `Transaction Date` = 'UNKNOWN';

ALTER TABLE cafe_sales_staging
MODIFY COLUMN `Transaction Date` DATE;

ALTER TABLE cafe_sales_staging
DROP COLUMN `Item`;

ALTER TABLE cafe_sales_staging
MODIFY COLUMN `Price Per Unit` DECIMAL (10,2);

UPDATE cafe_sales_staging
SET `Total Spent` = NULL
WHERE `Total Spent` = 'UNKNOWN' OR `Total Spent` = 'ERROR' or `Total Spent` = '';


ALTER TABLE cafe_sales_staging
MODIFY COLUMN `Total Spent` DECIMAL (10,2);

SELECT `Quantity`, `Price Per Unit`, `Total Spent`,
(`Quantity` * `Price Per Unit`) AS `Total Spent`
FROM cafe_sales_staging;

UPDATE cafe_sales_staging
SET `Total Spent` = `Quantity` * `Price Per Unit`;

SELECT * 
FROM cafe_sales_staging;

UPDATE cafe_sales_staging
SET `Payment Method` = 'Other'
WHERE `Payment Method` IN ('UNKNOWN', 'ERROR', '');

SELECT `Payment Method`, COUNT(*) 
FROM cafe_sales_staging
GROUP BY `Payment Method`;

SELECT `Location`, COUNT(*) 
FROM cafe_sales_staging
GROUP BY `Location`;

UPDATE cafe_sales_staging
SET `Location` = 'Other'
WHERE `Location` IN ('UNKNOWN', 'ERROR');

UPDATE cafe_sales_staging
SET `Location` = NULL
WHERE `Location` = '';

ALTER TABLE cafe_sales_staging
RENAME COLUMN `Transaction ID` TO transaction_id;

ALTER TABLE cafe_sales_staging
RENAME COLUMN `Quantity` TO quantity;

ALTER TABLE cafe_sales_staging
RENAME COLUMN `Price Per Unit` TO price_per_unit;


ALTER TABLE cafe_sales_staging
RENAME COLUMN `Total Spent` TO total;

ALTER TABLE cafe_sales_staging
RENAME COLUMN `Payment Method` TO payment_method;

ALTER TABLE cafe_sales_staging
RENAME COLUMN `Location` TO location;

ALTER TABLE cafe_sales_staging
RENAME COLUMN `Transaction Date` TO transaction_date ;

SELECT * 
FROM cafe_sales_staging;




