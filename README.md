# Advanced SQL Business Performance Analysis

**Financial analytics · Customer, product & market performance · Supply chain forecasting**

A MySQL business analytics case study exploring how an international consumer technology business can use structured sales, customer, product, pricing, discount and forecast data to support commercial and operational decisions.

> **Data availability:** The underlying database and its records are **not published**. This repository contains selected SQL written for the project, a logical data-model overview, aggregate findings and selected MySQL Workbench screenshots.

## Project objectives

- Examine gross sales, discounts and the steps required to calculate net sales.
- Identify high-contributing markets, customers and products.
- Quantify customer contribution within each geographic region.
- Compare actual and forecast sales quantities to highlight demand-planning opportunities.
- Demonstrate reusable MySQL techniques including **joins, CTEs, views, functions and window functions**.

## Selected insights

### 1. Five markets contributed approximately 60.4% of FY2021 net sales

| Market | FY2021 net sales (millions) |
|---|---:|
| India | 278.04 |
| USA | 170.91 |
| South Korea |84.53 |
| Canada | 60.49 |
| United Kingdom | 59.33 |

Together, these markets contributed **497.35 million** in net sales. This is approximately **60.4%** of the **823.90 million** total derived from the customer-contribution report. These figures refer to the dataset's unspecified reporting currency; no currency symbol is assumed.

 
**Decision application:** prioritise market-level performance reviews and understand concentration in major sales territories.

### 2. The top three named customers accounted for around 31.5% of FY2021 net sales

| Customer label | Net sales (millions) |
|---|---:|
| Amazon | 39.94 |
| Atliq Exclusive | 29.16 |
| Atliq e Store | 18.74 |

Their combined contribution was approximately **31.47%**. Rankings here group by *customer name*, so similarly named customers across markets are consolidated rather than reported individually by customer code.


**Decision application:** investigate concentration among leading commercial partners and evaluate customer/account-level opportunities.

### 3. APAC represented the largest regional net sales contribution

| Region | FY2021 net sales (millions) | Approx. share |
|---|---:|---:|
| APAC | 442.00 | 53.6% |
| EU | 200.82 | 24.4% |
| NA | 177.94 | 21.6% |
| LATAM | 3.16 | 0.4% |

Regional totals were reconstructed by summing the exported region/customer results. Minor differences versus total customer sales arise from rounding to two decimal places. Here **NA means North America**, not a missing value.


**Decision application:** compare regional commercial reliance and prioritise local sales planning.

### 4. Product leadership varied substantially across divisions

The FY2021 top unit-volume product in each division was:

| Division | Top product | Units sold |
|---|---|---:|
| N & S | AQ Pen Drive DRC | 2,034,569 |
| P & A | AQ Gamers Ms | 2,477,098 |
| PC | AQ Digit | 135,092 |

These are **unit-volume** rankings, not revenue or margin rankings. The query uses `DENSE_RANK()` to rank products within divisions.


**Decision application:** support product-line and category planning using observed unit demand.

### 5. Forecasting accuracy showed meaningful differences among customers and markets

The FY2021 forecast report covered **209 customer codes**. Under the specific SQL metric used, the highest customer-level reported forecast accuracy was **47.23%** (Coolblue, Italy). The median reported accuracy was **41.59%**; nine Netherlands entries were shown at **0%** because their absolute error exceeded 100% of forecast quantity and the query caps negative accuracy at zero.

**Metric definition:** `forecast_accuracy = IF(abs_error_pct > 100, 0, 100 - abs_error_pct)`, where `abs_error_pct` divides the sum of absolute forecast errors by forecast quantity. This is the *project's defined measure*, not a claim that all organisations use the same accuracy definition.


**Decision application:** review forecast methodology for persistently high-error customer/market combinations, particularly before inventory allocation decisions.

### 6. Gross sales and discount reporting are reproducible across different queries

For the selected customer in FY2021, the detailed sales and pre-invoice discount extracts each returned **3,006 rows**, with **23.22 million** total gross sales. The monthly gross sales report reconciles to the same total for the FY2021 dates present in the data. The example customer had a **30.25%** pre-invoice discount in the exported rows; this is **not** the final net sales value, as post-invoice deductions are additional.

Only **nine monthly periods** appear in the FY2021 extract, so missing periods should not be treated as zero sales without further checks.

## SQL work included

| File | Business question | SQL techniques |
|---|---|---|
| [F1 — Detailed gross sales](Stored Procedures/monthly_gross_sales_for_customer.sql) | What are the selected customer's product-level gross sales? | Multi-table joins, fiscal-year function, arithmetic |
| [F2 — Monthly gross sales](sql/01_financial/F2_monthly_gross_sales.sql) | How do gross sales vary month by month? | Joins, aggregation, `GROUP BY` |
| [C1 — Pre-invoice discounts](sql/02_commercial/C1_pre_invoice_discounts.sql) | How are pre-invoice discounts associated with sales? | Multi-table joins, composite join conditions |
| [C2 — Top markets](sql/02_commercial/C2_top_five_markets.sql) | Which markets lead FY2021 net sales? | Views, aggregation, sorting |
| [C3 — Customer contribution](sql/02_commercial/C3_customer_net_sales_share.sql) | Which customers contribute most to net sales? | CTEs, window functions |
| [C4 — Regional customer contribution](sql/02_commercial/C4_customer_share_by_region.sql) | How is customer revenue distributed within each region? | CTEs, `PARTITION BY` |
| [C5 — Leading products](sql/02_commercial/C5_top_products_by_division.sql) | Which products lead on unit sales by division? | CTEs, `DENSE_RANK()` |
| [S1 — Forecast accuracy](sql/03_supply_chain/S1_forecast_accuracy.sql) | How closely do forecasts reflect actual sales? | Joins, conditional expressions, CTEs |

The project includes SQL queries covering **financial, commercial and supply chain analytics**, supported by reusable functions, views and intermediate tables.

Supporting SQL definitions are organised under [`sql/00_prerequisites/`](sql/00_prerequisites/), with additional information on database dependencies and execution requirements available in [`docs/execution_notes.md`](docs/execution_notes.md).

## Data model

The original model contains **two dimension tables** (`dim_customer`, `dim_product`) and **seven fact tables** supporting sales, forecasts, gross prices, discounts and costs. Keys are linked logically in analytical joins; explicit foreign-key constraints are not defined in the provided database schema. A forecast-versus-actual helper table and net-sales reporting views are additional objects created during the analytical workflow.

See [`docs/data_model.md`](docs/data_model.md) for the table overview and relationships.

## Tools

**MySQL · MySQL Workbench · SQL**

## Interpretation and limitations

- Analysis is based on the exported results of selected queries, **not** independent execution of the SQL in a separate MySQL instance.
- Net sales and unit quantity are distinct measures. Product rankings shown here are based on **units sold**, not profit.
- Reported monetary values are in **millions of the dataset's unspecified reporting currency**.
- Results are historical observations within the project dataset, not verified external commercial performance.
- Recommendations are potential business applications, not outcomes demonstrated by the data.
- The original database and exported result CSV files are **not included** in this repository.

---

*SQL business analytics portfolio project — financial, commercial and demand-planning reporting.*
