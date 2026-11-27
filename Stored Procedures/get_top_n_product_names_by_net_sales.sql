CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_product_names_by_net_sales`(
in_fiscal_year int ,
in_top_n int )
BEGIN
select 
prod_name as product_name ,
round(sum(net_sales)/1000000,2) as net_sales_mln 
from net_sales 
where fiscal_year = in_fiscal_year
group by product_name
order by net_sales_mln desc
limit in_top_n

 ;
END
