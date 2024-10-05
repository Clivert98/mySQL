-- DATA CLEANING

-- VIEWING THE DATA
SELECT *
FROM layoffs; 

-- 1. REMOVE DUPLICATES
-- 2. STANDARDISE THE DATA
-- 3. NULL VALUES OR BLANK VALUES
-- 4. REMOVE ANY COLUMNS

-- 1. REMOVING DUPLICATES

-- CREATES TABLE WITH COLUMN NAMES LIKE LAYOFFS TABLE
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

-- INSERTING ROWS INTO THE NEW TABLE
INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- TO SEE ROWS THE CONTAIN DUPLICATES ROW NUMBER > 1
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- SPLICING TO JUST DHOW THE DUPLICATE ROWS
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
) 
SELECT *
From duplicate_cte
WHERE row_num > 1;

-- CONFIRMING THEY ARE DUPLICATES
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';
-- Can see that they are similar but they are not duplicates


-- CREATING A NEW TABLE (Table - Copy clipboard - Create statement) (Added row_number column - Integer type)
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
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- DELETING DUPLICATE ROWS
DELETE FROM layoffs_staging2 WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- 2. STANDARDISING DATA

-- TRIM - takes the white space off the end
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT company
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
-- Need to update Crypto Currency

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- UPDATED CRYPTOCURRENCY TO CRYPTO
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;
-- Need to look at location, country now

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country) # Trailing is coming at the end
WHERE country LIKE 'United States%';

-- NEED TO CHANGE DATA COLUMN FROM TEXT TO TIME SERIES
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') # String to date m/d/y
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; -- Always do on other table


-- 3. REMOVING NULL DATA AND MISSING VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2         
SET industry = NULL                 -- Setting all rows in Industry column with blank values to null values
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE  'AirBnB';

-- FINDING OUT COMPANIES THAT HAVE INDUSTRIES WHERE ITS NULL OR BLANK AND AN INDUSTRY THAT IS NOT NULL
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- NOW UPDATING TABLE
UPDATE layoffs_staging2 t1                       -- Updating the t1 table
JOIN layoffs_staging2 t2                          -- Joining on t2 where the company is the exact same
	ON t1.company = t2.company
SET t1.industry = t2.industry                     -- We're setting t1 industry to t2 industry
WHERE (t1.industry IS NULL OR t1.industry = '')   -- Where the t1 industry is null or blank
AND t2.industry IS NOT NULL;                      -- And t2 undustry is not null

 SELECT *
FROM layoffs_staging2
WHERE company LIKE  'Bally%';                     -- Only company that is not populated with null values



-- REMOVING ROWS WE DO NOT NEED
Select *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- DROPPING COLUMN FROM THE TABLE
SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;




