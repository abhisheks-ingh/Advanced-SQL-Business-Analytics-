CREATE DEFINER=`root`@`localhost` PROCEDURE `get_montly_gross_sales_for_customer`(in_customer_codes text)
BEGIN
select
      s.date,
            sum(round(sold_quantity*g.gross_price,2)) as monthly_sales
	from fact_sales_monthly s
	join fact_gross_price g
	on 
	    g.fiscal_year=get_fiscal_year(s.date) and
	    g.product_code=s.product_code
	where
       find_in_set(s.customer_code, in_customer_codes) >0
	group by date
	;
END
