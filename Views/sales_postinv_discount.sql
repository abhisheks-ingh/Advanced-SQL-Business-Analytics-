CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sales_postinv_discount` AS
    SELECT 
        `s`.`date` AS `date`,
        `s`.`fiscal_year` AS `fiscal_year`,
        `s`.`customer_code` AS `customer_code`,
        `s`.`market` AS `market`,
        `s`.`product_code` AS `product_code`,
        `s`.`prod_name` AS `prod_name`,
        `s`.`variant` AS `variant`,
        `s`.`sold_quantity` AS `sold_quantity`,
        `s`.`gross_price_total` AS `gross_price_total`,
        `s`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`,
        (`pos`.`discounts_pct` + `pos`.`other_deductions_pct`) AS `post_invoice_discount_pct`,
        (ROUND((1 - `s`.`pre_invoice_discount_pct`), 0) * `s`.`gross_price_total`) AS `net_invoice_sales`
    FROM
        (`sales_preinv_discount` `s`
        JOIN `fact_post_invoice_deductions` `pos` ON (((`pos`.`date` = `s`.`date`)
            AND (`pos`.`customer_code` = `s`.`customer_code`)
            AND (`pos`.`product_code` = `s`.`product_code`))))
