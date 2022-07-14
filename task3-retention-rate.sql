-- SQL Project: Analyze FMCG's Sales Department

-- In this project, we will go through unreal FMCG's firm - A company distributes food, beer and beverage to mom-and-pop stores in Vietnam. In term as a member of Sales Analyst team, we'll answer some questions about current business situation of this firm.

-- We've asked for solving these tasks below:

-- Task 3: Retention rate (new customers) in a half year of 2022.

SELECT
count(distinct a.root_id),
date_trunc('month',coalesce(date_of_first_purchase,date_of_first_booking)) as month,
(extract(month from coalesce(date_of_order,delivered_date)) - extract(month from coalesce(date_of_first_purchase,date_of_first_booking))) +
12 * (extract(month from coalesce(date_of_order,delivered_date)) - extract(year from coalesce(date_of_first_purchase,date_of_first_booking)))
as period
from core.f_retailer_transaction_detail a
inner join
(select root_id,date_of_first_booking

from core.d_retailer_management
where
vertical in ('FMCG')
and (1 = 1)

) b
on a.root_id = b.root_id
where
(1 = 1)
and case when 'complete' = 'full' then 'full' else status end = 'complete'


and coalesce(date_of_first_purchase,date_of_first_booking) is not null
and coalesce(date_of_first_purchase,date_of_first_booking)::date >= '2022-01-01' and coalesce(date_of_first_purchase,date_of_first_booking)::date <= '2022-06-30'
and a.vertical in ('FMCG') and a.status != 'cancel'
and a.date_of_order <= '2022-06-30'


-- - Looking at the table, we can see that approximately 40% of new customers on average didn't intend to place the second order. 
--   This is a group of retailers that includes retailers who placed a one-time order for personal or organizational purposes. 
--   But most of the customers didn't intend to place a second order from the firm. 
--   This is also one of the customer groups that the firm need to survey and concentrate on to reactivate them again.




