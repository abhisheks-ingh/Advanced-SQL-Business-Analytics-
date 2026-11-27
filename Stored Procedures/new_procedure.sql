CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`(
in_fiscal_year int)
BEGIN
with forecast_err_table as (SELECT 
    s.customer_code,
    sum((forecast_quantity - sold_quantity)) AS net_err,
    sum((forecast_quantity - sold_quantity)) * 100 / sum(forecast_quantity) AS net_err_pct,
    sum(ABS(forecast_quantity - sold_quantity)) AS abs_err,
   sum( ABS(forecast_quantity - sold_quantity)) * 100 / sum(forecast_quantity) AS abs_err_pct
FROM
    gdb0041.fact_act_est s
    where s.fiscal_year = in_fiscal_year
    group by customer_code )
select
e.*,
c.customer,
c.market ,
if(abs_err_pct > 100 , 0 ,100-abs_err_pct) as forecast_accuracy
from forecast_err_table e
join dim_customer c 
using (customer_code)
order by forecast_accuracy desc;
END
