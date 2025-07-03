use car_sales;
select * from carsales;

#how many cars were sold in each state
select state, count(*)
from carsales
Group by state;
#Most cars were sold in California followed by Texas 

#Popular cars by make and model
Select make, model, count(*)
from carsales
Group by make, model
Order by Count(*) desc;
# The most sold car is infiniti G Sedan followed by BMW 3 Series

#Avg sales prices for cars in each state
select state, avg(sellingprice) as avg_SP
from carsales
group by state
order by avg_SP desc;
#The average sales price are highest in Quebec followed by Tennessee

-- Create temporary table
create temporary table car_sales as
select
    'year' as man_year,
    make,
    model,
    trim,
    body,
    transmission,
    vin,
    state,
    'condition' as car_condition,
    odometer,
    color,
    interior,
    seller,
    mmr,
    sellingprice,
    saledate,
    mid(saledate, 12, 4) as sale_year,
    mid(saledate, 5, 3) as sale_monthname,
    mid(saledate, 9, 2) as sale_day,
    case mid(saledate, 5, 3)
        when 'Jan' then 1
        when 'Feb' then 2
        when 'Mar' then 3
        when 'Apr' then 4
        when 'May' then 5
        when 'Jun' then 6
        when 'Jul' then 7
        when 'Aug' then 8
        when 'Sep' then 9
        when 'Oct' then 10
        when 'Nov' then 11
        when 'Dec' then 12
        else null
    end as sale_month
from carsales;

-- Query data from temporary table to fing avg price per month
select 
    sale_year,
    sale_month,
    avg(sellingprice) as avg_SP
from car_sales
group by sale_year, sale_month
order by sale_year, sale_month;
# the highest avg_sale was in Jan 2014 followed by Dec 2014

# Highest sales by months
select sale_month, count(*)
from car_sales
group by sale_month
order by sale_month;
# most cars are sold in december followed by january

#Sales higher than the model average
select make,
model,
vin,
sale_year,
sale_month,
sellingprice,
avg_sp_model
from (select make,
model,
vin,
sale_year,
sale_month,
sellingprice,
avg(sellingprice) over (partition by make, model) as avg_sp_model
from car_sales) s
where sellingprice > avg_sp_model;

# sales by brand
select make,
count(distinct model) as num_models,
count(*) as num_sales,
min(sellingprice) as min_sp,
max(sellingprice) as max_sp
from car_sales
group by make
order by num_sales desc;
# most cars sold are of ford followed by chevrolet

