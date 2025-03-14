-- DATA CLEANING


SELECT * 
FROM layoffs;


-- 1. Remove Duplicates 
-- 2. Standarize the Data
-- 3. Null Values or Blank Values 
-- 4. Remove Any Columns

-- Create a staging table so you dont get rid of any raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;
--

-- Creating a row if row num is 1 it is unique if row num 2 it is a duplicate 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- Shows the duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

-- Creating another staging table for row num
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- After doing that we can start to filter rows out
-- display the row_num greater than 1 meaning delete duplicates 
SELECT * 
FROM layoffs_staging2
;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- 2. STANDARDIZING THE DATA 
#Finding issues in data and fixing them

#removes the space infront of company and updating it
SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = (TRIM(company));

#Looking at the industry there are multiple of the same ones, rn we are updating crypto
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1
;

#Now go down the columns make sure everything is good location is good 
#Country has a dupe

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States.%';
#Removing the .
SELECT DISTINCT country, TRIM(TRAILING'.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING'.' FROM country)
WHERE country LIKE 'United States%';

-- Onto date
#changing date to a specific format

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y')
;

SELECT `date`
FROM layoffs_staging2
;
#Since its in the right format we can change the date type instead of text only do it on staging table
ALTER TABLE layoffs_staging2
modify column `date` DATE;

#Till now we looked at company, location, industry, date and country

-- 3.NULL AND BLANK DATA 
#Looking at null and blank industries
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS null
AND percentage_laid_off IS null;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

#Setting the blanks to NULL to make it easier
UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

#Filling in the one blank airbnb with the other airbnb industry
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;

#we are mostly finished we just have to determine if we need data thats null in total laid off and percentage 
#useless data we can delete
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

#Then we remove the row_num
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

