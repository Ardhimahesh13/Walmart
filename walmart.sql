
SELECT * FROM "Walmart";

select count(*) from "Walmart";

-- to check the payment for different type of transactions 

select payment_method,
count(*)
from "Walmart"
group by payment_method ;

-- check total number of stores
select count(distinct branch) branch from "Walmart";

drop table "Walmart";

-- check max Quantity 
select max(quantity)from "Walmart"; 

--Business Problems

-- Find the different payment method and number of transactions, number of qty sold.

select payment_method,
       count(*)as no_of_payments,
	   sum(quantity) as no_of_qty_sold
from "Walmart"
 group by (payment_method)


 -- 2) identify the highest rated category in each branch ,displaying the branch , category and avg rating .

 select branch,category,
 avg(rating)as avg_rating,
 rank() over(partition by branch order by avg(rating)desc) as rank
 from "Walmart"
 group by branch,category;

 -- 3) indentify the busiest day for each branch based on the number of transactions.

select * 
from (select branch,
to_char(to_date(date,'DD/MM/YY'), 'day') as day_name,
count(*) as no_transactions ,
RANK() over(partition by branch order by count(*) desc)as rank
from "Walmart"
group by branch,day_name )
where rank = 1


-- 4) Calculate the total quantity of items sold per payment method . List payment_method and total_quantity.

SELECT * FROM "Walmart";

select payment_method,
count(*) as no_of_paymentMethod,
sum(quantity)as total_qty_sold
from "Walmart"
group by payment_method;

-- 5) Determine the average min and max rating of category for each city. list the city,average_rating,min_rating and max_rating.

select city ,category,
min(rating) as min_rating,
max(rating) as max_rating,
avg(rating) as avg_rating
from "Walmart"
group by city,category;


-- 6) Calculate the total profit for each category by considering total profit as (unit price * quantity * profit margin).List category and
-- total profit , ordered from highest to lowest.

select category,
sum(total)as total_revenue,
sum(total*profit_margin) as profit
from "Walmart"
group by category ;

-- 7) Determine the most common payment method for each Branch.Display branch and the preferred_payment_method.

with cte
as
(select branch,
payment_method,
count(*) as total_transactions,
rank() over(partition by branch order by count(*)desc) as rank
from "Walmart"
group by branch,payment_method )
select * from cte where rank = 1

--8) Categorize sales in to 3 groups morning,afternoon,evening
-- find out which of the shift and number of invoices

select * from "Walmart"

select branch,
case
		when extract (hour from(time::time)) < 12 then 'morning'
		when extract (hour from(time::time)) between 12 and 17 then 'afternoon'
		else 'evening'
	end day_time,
	count(*)
from "Walmart"
group by 1,2
order by 1,3

-- 9) identify 5 branchwith highest decrease ratio in revenue compare to last year(current year 2023 and last year 2022)

select *,
extract(year from to_date(date, 'DD/MM/YY')) as formated_date
from "Walmart"

--2022_revenue --

with revenue_2022
as
(
	select branch,
	sum(total)as revenue
	from "Walmart"
	where extract(year from to_date(date, 'DD/MM/YY')) = 2022
	group by 1
),

revenue_2023
as
(
select branch,
	sum(total)as revenue
	from "Walmart"
	where extract(year from to_date(date, 'DD/MM/YY')) = 2023
	group by 1
)

select ls.branch,
ls.revenue as last_year_revenue,
cs.revenue as cr_year_revenue,
	round(
	(ls.revenue - cs.revenue)::numeric/ls.revenue::numeric*100,2)
	as rev_dec_ratio
from revenue_2022 as ls
join
revenue_2023 as cs
ON ls.branch = cs.branch
where ls.revenue > cs.revenue
order by 4 desc
limit 5 

















