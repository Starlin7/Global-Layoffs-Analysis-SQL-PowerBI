-- exploratory data analysis

-- 1.company with highest layoff
select max(total_laid_off) from layoffs_staging2;

-- 2.companies with 100% layoff
select * from layoffs_staging2
where percentage_laid_off=1
order by total_laid_off desc;

-- 3.Total layoffs by company
select company,sum(total_laid_off) from layoffs_staging2
group by company
order by 2 desc;

-- 4.Total layoffs by industry
select industry,sum(total_laid_off) from layoffs_staging2
group by industry
order by 2 desc;

-- 5.Total layoffs by country
select country,sum(total_laid_off) from layoffs_staging2
group by country
order by 2 desc;

-- 6.Total layoffs each year
select year(`date`),sum(total_laid_off)from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- 7.Total layoffs each month and month by month progression
select substring(`date`,1,7) as `month`,sum(total_laid_off)from layoffs_staging2
where substring(`date`,6,2) is not null
group by `month`
order by 1 asc;

with Rolling_total as
(select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off from layoffs_staging2
where substring(`date`,6,2) is not null
group by `month`
order by 1 asc
)
select `month`,total_off,
sum(total_off) over (order by `month`)as rolling_total from Rolling_total;

-- 8.Top 5 companies with the highest layoff each year
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

with company_year (company,years,total_laid_off) as
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),
company_year_rank as
(
select *,dense_rank() over (partition by years order by total_laid_off desc) as ranking from company_year
where years is not null
)
select * from company_year_rank
where ranking <=5
order by years;
SELECT *
FROM layoffs;