-- Data Cleaning projects 

select * from world_layoffs.layoffs;

-- 1.remove Duplicates
-- 2.standardize the Data
-- 3.Null values or blank values 
-- 4.Remove Any columns & rows 

-- Creating the duplicate tables for making the changes on it.
create table layoffs_staging
like world_layoffs.layoffs;

select * from layoffs_staging ;

insert layoffs_staging
select * from world_layoffs.layoffs ; 


-- checking the duplicates on the table--

select * , 
ROW_NUMBER () OVER(
partition by company , location , industry, total_laid_off, percentage_laid_off, `date`,stage,funds_raised_millions)as row_num
from layoffs_staging;


-- Using the comman table expresions for searching the duplicate values on the table --
with duplicate_cte as (
select * , 
ROW_NUMBER () OVER(
partition by company , location , industry, total_laid_off, percentage_laid_off, `date`,stage, country
,funds_raised_millions)as row_num
from layoffs_staging

) -- in their the select statement is searching the duplicate values that are written in the row_num =2 .
-- these are call the duplicate values onn the table .
select * 
from duplicate_cte
where row_num >1 ;

-- this statement are using for searching the duplicates are really exist or not on the table
select * from layoffs_staging
where company = 'cazoo' ;

-- creating the new table for deleteing the duplicate cata 
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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_staging2 
select * , 
ROW_NUMBER () OVER(
partition by company , location , industry, total_laid_off, percentage_laid_off, `date`,stage, country
,funds_raised_millions)as row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num >1;

DELETE from layoffs_staging2
where row_num >1;

-- all duplicate are deleted

-- the standardize the Data 
select company , trim(company) from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct(company) from layoffs_staging2;

select distinct(industry) 
from layoffs_staging2 
order by 1;

select *
from layoffs_staging2
where industry like 'Crypto%' ;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct(country)
from layoffs_staging2
order by 1 ;

select *
from layoffs_staging2
where country like 'United kingdom';

update layoffs_staging2
set country = 'United States'
where country like 'United States_';

select `date`, 
str_to_date(`date`, '%m/%d/%Y') 
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y') ;

alter table layoffs_staging2
modify column `date` date ;

select t1.industry,t2.industry from layoffs_staging2 t1
join layoffs_staging2 t2 
   on t1.company = t2.company
   where t1.industry is null 
   AND t2.industry is not null;

update layoffs_staging2 t1 
join layoffs_staging2 t2 
   on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null  
   AND t2.industry is not null;

update layoffs_staging2
set industry = null 
where industry = '';
   
select * from layoffs_staging2
where company like 'Airbnb';

select * 
from layoffs_staging2
;
   
DELETE 
from layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
   
ALTER TABLE  layoffs_staging2
drop column row_num;  
   

   