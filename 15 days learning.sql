with cte as (select t1.submission_date,t0.hacker_id,t0.name,count(t1.submission_id) as cnt
            from hackers t0
            left join submissions t1 on t1.hacker_id = t0.hacker_id
            group by t1.submission_date,t0.hacker_id,t0.name)

, cte2 as (select submission_date,hacker_id,name,
          count(submission_date) over (partition by hacker_id order by submission_date rows between UNBOUNDED PRECEDING AND CURRENT ROW ) as cnt_id,
          datediff(day,'2016-03-01',submission_date) + 1 as cnt_day from cte)

, cte3 as (select submission_date,count(distinct hacker_id) as total_id from cte2
           where cnt_id = cnt_day
          group by submission_date
          )

, cte4 as (select submission_date,hacker_id,name,cnt,
          row_number () over (partition by submission_date order by cnt desc,hacker_id asc) as ranker from cte)
           
select cte3.submission_date,cte3.total_id,cte4.hacker_id,cte4.name from cte3
           join cte4 on cte4.submission_date = cte3.submission_date
           where ranker = 1
           