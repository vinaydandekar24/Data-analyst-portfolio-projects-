select * from branch;
select * from customer;
select * from payment_mode;
select * from product;
select * from product_rating;
select * from product_sold;
select * from time_zone;


#@ Generic Questions
## 1.How many distinct cities are present in the dataset?
select distinct city from branch ;
-- 2.In which city is each branch situated?
select distinct branch , city from branch ;
#Product Analysis
-- 1.How many distinct product lines are there in the dataset?
select distinct product_line from product ; 

-- 2.What is the most common payment method?
select payment,count(payment) most_using_payment_method from payment_mode
group by payment order by count(payment)  desc   ;

-- 3.What is the most selling product line? 
select product_line, round(sum(total),2) from product
group by product_line order by sum(total) desc limit 1  ;

-- 4.What is the total revenue by month?

select t.month,round(sum(p.total),2) total_revenue from time_zone t inner join product p 
on t.transaction_id = p.transaction_id group by t.month order by sum(p.total) desc limit 1 ;

-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
select t.month,round(sum(ps.cogs),2) total_revenue from time_zone t inner join product_sold ps 
on t.transaction_id = ps.transaction_id group by t.month order by sum(cogs) desc limit 1 ;
select * from product_sold;
-- 6.Which product line generated the highest revenue?
select product_line , round(sum(total)) as revenue
from product
group by product_line order by sum(total) desc limit 1 ;

-- 7.Which city has the highest revenue?
select b.city , round(sum(p.total)) as revenue from branch b inner join product p
on b.transaction_id = p.transaction_id group by b.city order by sum(p.total) limit 1;

-- 9.Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,'based on whether its product are above the average.

 # total > avg(total)
 

select *from product ;
alter table product add column product_category varchar(25);
update product set product_category =
(select if(total >= (select avg(total)),"Good","Bad")) ;


select if(total >= (select avg(total) from product),"Good","Bad") from product;

select product_line,product_category, count(product_category) from product 
group by product_line ,product_category 
order by  count(product_category) desc 
limit 1;

-- 10.Which branch sold more products than average product sold?
select * from branch;
select * from product ;

select b.branch , sum(p.quantity) from branch b inner join product p 
on b.transaction_id = p.transaction_id group by b.branch  having sum(p.quantity) > avg(p.quantity) 
order by sum(p.quantity) desc limit 1 ;

-- 11.What is the most common product line by gender?
select * from customer;

select p.product_line, count(c.gender) from customer c inner join product p 
on c.transaction_id = p.transaction_id group by p.product_line order by count(c.gender) desc limit 1;

-- 12.What is the average rating of each product line?
select * from product_rating;
select p.product_line,round(avg(pr.rating),2) from product p inner join product_rating pr
on p.transaction_id = pr.transaction_id group by p.product_line order by round(avg(pr.rating),2) desc;

-- 1.Number of sales made in each time of the day per weekday
select * from time_zone ;
select day_name,time_of_day, count(branch.invoice_id) from time_zone  t inner join branch 
on t.transaction_id = branch.transaction_id group by day_name , time_of_day having day_name = (select day_name from
 time_zone where day_name != ('saturday','sunday')) ;

SELECT day_name,time_of_day,COUNT(branch.invoice_id) AS invoice_count FROM 
time_zone t INNER JOIN branch ON t.transaction_id = branch.transaction_id
WHERE day_name NOT IN ('Saturday', 'Sunday')GROUP BY day_name, time_of_day
order by invoice_count desc;

-- 2.Identify the customer type that generates the highest revenue.
select * from branch;

select customer_type , sum(total) as Total_revenue 
from customer inner join product 
on customer.transaction_id = product.transaction_id
group by  customer_type order by sum(total) desc ;


-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?

select * from product;
alter table product 
rename column `Tax _5%` to `tax_5%`;

	select branch.city,round(sum(`tax_5%`),2) from branch inner join product
	on branch.transaction_id = product.transaction_id
	group by branch.city order by sum(`tax_5%`) desc ; 

select * from customer;
select * from  product;
-- 1.How many unique customer types does the data have?
select distinct customer_type from customer;
-- 2.How many unique payment methods does the data have?
select distinct payment from payment_mode;
-- 3.Which is the most common customer type?
select customer_type , count(customer_type) from customer
group by customer_type order by count(customer_type) desc limit 1;
-- 4.Which customer type buys the most?
select customer_type, round(sum(total),2) from customer inner join product 
on customer.transaction_id = product.transaction_id 
group by customer_type order by sum(total) desc ;
-- 5.What is the gender of most of the customers?
select * from branch ;
select * from customer;
select gender , count(*) as total_customer from customer 
group by gender order by count(*) desc;

-- 6.What is the gender distribution per branch?
select  gender,branch,count(gender) from customer inner join branch 
on customer.transaction_id = branch.transaction_id 
group by branch,gender order by count(gender) desc ;

-- 7.Which time of the day do customers give most ratings?
select * from product_rating ;
select time_of_day from time_zone;
select time_of_day, count(rating) from time_zone inner join product_rating
on time_zone.transaction_id = product_rating.transaction_id
group by time_of_day order by count(*) ;
-- 8.Which day of the week has the best avg ratings?
select day_name, count(rating) from time_zone inner join product_rating
on time_zone.transaction_id = product_rating.transaction_id
group by day_name  order by count(rating) desc limit 1;


