select 
    us_state, 
    argMax(cat_id, amount) as top_cat_id,
    max(amount) as max_amount
from readings 
group by us_state 
order by us_state asc;