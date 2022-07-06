SQL Project: Analyze FMCG's Sales Department

In this project, we will go through unreal FMCG's firm - A company distributes food, beer and beverage to mom-and-pop stores in Vietnam. In term as a member of Sales Analyst team, we'll answer some questions about current business situation of this firm.

We've asked for solving these tasks below:

Task 1: Quick view about total retailers, active retailers (rate), orders, Total GMV, promotion(GMV), refund stock(GMV).


select
c.month,
d.total_root_id,
c.active_root_id,
c.active_root_id::numeric/d.total_root_id::numeric as active_rate,
c.order,
round(c.booking_gmv/(case when 'USD' = 'VND' then 1 when c.month >= '2021-01-01' then 23000 else 22000 end),0) as booking_gmv,
round(f.delivered_gmv/(case when 'USD' = 'VND' then 1 when c.month >= '2021-01-01' then 23000 else 22000 end),0) as delivered_gmv,
round((c.sku_promotion + c.order_promotion)/(case when 'USD' = 'VND' then 1 when c.month >= '2021-01-01' then 23000 else 22000 end),0) as total_promotion,
round(f.oos_and_rf/(case when 'USD' = 'VND' then 1 when c.month >= '2021-01-01' then 23000 else 22000 end),0) as out_of_stock_and_refund
from
(select
date_trunc('month',date_of_order)::date as month,
count(distinct entity_id) as order,
sum(booking_gmv) as booking_gmv,
sum(shortage) as shortage,
sum(sku_promotion) as sku_promotion,
sum(order_promotion) as order_promotion,
count(distinct b.root_id) as active_root_id
from
(select so_number, warehouse_name, delivered_date, root_id , so_gross_booking,date_of_order, status, entity_id,city,vertical, branch, date_of_first_purchase::date,
sum(original_price*sku_qty_invoiced) as booking_gmv,
sum(sku_qty_refunded*original_price) as shortage,
sum(gross_sku_discount_tier_price + gross_sku_discount_promotion) as sku_promotion,
sum(gross_order_discount_adj_4_sku) as order_promotion
from core.f_retailer_transaction_detail
where (1 = 1)
and date_of_order <= '2022-06-30'
and vertical = 'FMCG' and status != 'cancel'
group by 1,2,3,4,5,6,7,8,9,10,11,12) b
group by 1) c
left join
(select month,  max(cnt) as total_root_id, count(month)
from
(select date_trunc('month',coalesce(date_of_first_purchase, date_of_first_booking)::date)::date as month,
 (count(*) over (order by coalesce(date_of_first_purchase, date_of_first_booking) rows UNBOUNDED PRECEDING) )
as cnt
from
core.d_retailer_management d11
left join
(select distinct root_id, type
from public.d_retailer_type) d12
on d11.root_id = d12.root_id
where (1 = 1)
and d11.vertical = 'FMCG'
and coalesce(date_of_first_purchase, date_of_first_booking)::date <= '2022-06-30'
) d1
group by 1
)d
on c.month = d.month

left join
(select date_trunc('month', delivered_date)::date as month,
sum((sku_qty_invoiced - sku_qty_refunded)* original_price) as delivered_gmv,
sum(selling_price*(sku_qty_invoiced - sku_qty_refunded) - net_sku_discount_promotion - net_order_discount_adj_4_sku) as net_delivered_gmv,
sum(sku_qty_refunded* original_price) as oos_and_rf
from core.f_retailer_transaction_detail f1
left join
(select distinct root_id, type
from public.d_retailer_type) f2
on f1.root_id = f2.root_id
where f1.status = 'complete' and f1.vertical = 'FMCG'
and delivered_date::date <= '2022-06-30'
group by 1) f
on c.month = f.month
where c.month is not null and c.month >= '2022-01-01' and c.month <= '2022-06-30'
order by 1 desc
