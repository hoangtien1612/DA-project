-- SQL Project: Analyze FMCG's Sales Department

-- In this project, we will go through unreal FMCG's firm - A company distributes food, beer and beverage to mom-and-pop stores in Vietnam. In term as a member of Sales Analyst team, we'll answer some questions about current business situation of this firm.

-- We've asked for solving these tasks below:

-- Task 2: Top 10 products contributing the best revenue in a half year of 2022.

select
b.sku_id, b.sku_name,
sum(a.sku_qty_invoiced) as qty_ordered,
sum(case when a.status = 'complete' then a.sku_qty_invoiced - a.sku_qty_refunded end) as qty_delivered,
round(sum(a.sku_qty_invoiced*original_price - gross_sku_discount_tier_price - gross_sku_discount_promotion - gross_order_discount_adj_4_sku),0) as net_gmv_ordered,
round(sum(case when a.status = 'complete' then (a.sku_qty_invoiced - a.sku_qty_refunded)*selling_price - net_sku_discount_promotion - net_order_discount_adj_4_sku end),0) as net_gmv_delivered
from
core.f_retailer_transaction_detail a
left join
core.d_sku_management b
on a.sku_id = b.sku_id
where a.vertical = 'FMCG' and a.status != 'cancel'
and date_of_order >= '2022-01-01' and date_of_order <= '2022-06-30'
group by 1,2
order by net_gmv_ordered desc
limit 10



-- - Looking at the table, we can see beer, beverages, cooking ingredients are the products contributing the best revenue. That proves Vietnam's people tend to like using alcohol beverages whenever, even winter season. 
--   This is also a main point that the firm focused on and created promotions related to beer and beverages. Definitely, these are products with intense competition among competitors in the market.



