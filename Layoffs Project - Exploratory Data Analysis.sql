-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;                -- Cleaned Dataset


# Looking at the Max total laid off and percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; 

# Looking at companies that completely went under and the amount of employees laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off desc; 

# Looking at the total number of people laid off by company's.
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

# Looking at the date the data was collected
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

# The industries that got hit the most
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# Countries that got hit the most
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# The amount of people laid off by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT *
FROM layoffs_staging2;

# All the lay offs during the years
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


# Rolling total, MoM progression each year

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS Total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(Total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT company, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


## Ranking / Showing which companies had the biggest lay offs Year by Year

WITH Company_Year (company, years, total_laid_off) AS                                -- Creates a CTE called 'Company_Year' that calculates the total number of layoffs per company per year
(
SELECT company, YEAR(`date`), SUM(total_laid_off)                                    -- Select the company name, the year (extracted from the date column), and the sum of layoffs for that year
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)                                                       -- Groups the results by company and year so we get total layoffs per company for each year
), Company_Year_Rank AS                                                              -- Creates another CTE called 'Company_Year_Rank' to rank companies by total layoffs per year 
(SELECT *,                                                                           -- Select all columns from the previous CTE (Company_Year)                
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking       -- DENSE_RANK() to rank companies by total layoffs for each year (higher layoffs = better rank)
																					 -- The PARTITION BY clause ensures that the ranking is done separately for each year
                                                                                     -- The ORDER BY clause sorts companies by layoffs in descending order (highest layoffs first)
FROM Company_Year
WHERE years IS NOT NULL                                                              -- Ensures that the 'years' field is not NULL (we only want valid years)
)
SELECT *
FROM Company_Year_Rank                                    
WHERE Ranking <= 5;                                                                  -- Filter the results to only include companies ranked 1 through 5 for each year







