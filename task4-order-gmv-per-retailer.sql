-- SQL Project: Analyze FMCG's Sales Department

-- In this project, we will go through unreal FMCG's firm - A company distributes food, beer and beverage to mom-and-pop stores in Vietnam. In term as a member of Sales Analyst team, we'll answer some questions about current business situation of this firm.

-- We've asked for solving these tasks below:

-- Task 4: Number of orders, revenue per each retailer in a half year of 2022.



select month, avg(order_cnt) as order_cnt, avg(booking_gmv/(case when month < '2021-01-01' then 22000 else 23000 end)) as booking_gmv
from
(select date_trunc('month', case when 'booking' = 'booking' then date_of_order else delivered_date end)::date as month,
root_id,
count(distinct so_number) as order_cnt,
sum(original_price*sku_qty_invoiced) as booking_gmv
from core.f_retailer_transaction_detail
where (1 = 1) 
and date_of_order >= '2022-01-01' and date_of_order  <= '2022-06-30'
and vertical = 'FMCG' and status != 'cancel'
group by 1,2 ) a1
inner join
(select distinct root_id
from
core.d_retailer_management
where
(1 = 1)
and vertical = 'FMCG'
) b
on a1.root_id = b.root_id
group by 1



-- - Looking at the table, we can see that January is the highest month having the most orders in a half year of 2022 
--   because it's time that almost retailers wanted to import goods such as beer, beverages and confectionary for their best season - Vietnam's Tet Holiday. 
--   We can affirm that even revenue per retailer didn't have dramatical growth but total revenue in the firm has still increased stablely. That proves the firm has concentrated on expanding new customers.





