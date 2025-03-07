/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

--calculate total sales per month
select datetrunc(month, order_date) as order_date, 
sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
order by datetrunc(month, order_date)

--running total of sales over time
select
order_date,
total_sales,
sum(total_sales) over (partition by year(order_date) order by order_date) as running_total_sales
from
(
select datetrunc(month, order_date) as order_date, 
sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
) t

--moving average price over time
select
order_date,
avg_price,
avg(avg_price) over (order by order_date) as moving_avg_price
from
(
select datetrunc(year, order_date) as order_date, 
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by datetrunc(year, order_date)
) t