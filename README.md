# Ecommerce Sales Analysis with SQL (PostgreSQL)

**Author:** Tushar Rawte, Data Analyst

## Project Overview

An end-to-end data analytics project analyzing **40,000 orders, 10,000 customers, and 100,000 sessions** from a PostgreSQL ecommerce database. The project answers core executive questions around **revenue health, order dynamics, customer value, retention, conversion, and growth opportunities**.

## Key Business Insights

1. **Revenue Volatility:** Revenue peaked at **₹10.43 Cr in April**, growing **+82.20% MoM**, before declining **-40.85% in May** and **-73.32% in June**. The four-month period is too short to establish seasonality, but the trajectory signals significant volume volatility.

2. **Volume-Driven Revenue:** Monthly AOV remained relatively stable at approximately **₹6.2K–₹6.4K**, indicating that major revenue movements were driven primarily by **order volume rather than basket size**.

3. **Customer Concentration:** **VIP buyers (5+ orders)** represent only **26.14% of customers but generate 78.19% of customer revenue**, with average customer spend of approximately **₹75.7K**.

4. **Retention Opportunity:** **49.99% of customers are one-time buyers**, contributing only **12.42% of revenue**. Converting first-time buyers into second-time buyers represents a major growth opportunity.

5. **Conversion:** **28.70% of 100,000 sessions converted into orders**, leaving substantial scope for funnel optimization.

6. **Returns:** Approximately **4.01% of orders had a return request**, with late delivery, damaged items, and missing parts among the leading return reasons.

## Project Structure

```text
├── README.md
├── sql/
│   ├── 01_business_overview.sql
│   ├── 02_customer_analysis.sql
│   ├── 03_revenue_analysis.sql
│   ├── 04_product_analysis.sql
│   ├── 05_conversion_analysis.sql
│   └── 06_returns_analysis.sql
├── findings/
│   └── 00_executive_summary.md
└── docs/
    └── data_dictionary.md
```

## What I Would Analyze Next

The next phase would move from **descriptive analytics to diagnostic and predictive analytics**:

- Decompose revenue decline into traffic, conversion, inventory, payment, and marketing drivers.
- Build **1st → 2nd → 3rd → VIP** customer cohorts and measure retention/LTV.
- Evaluate marketing channels using **CAC, repeat revenue, and customer LTV** rather than first-order acquisition alone.
- Quantify revenue leakage from refunds, returns, discounts, and failed payments.
- Develop RFM and **repurchase-propensity segments** to prioritize customers by expected value.

## How to Reproduce

1. Connect to PostgreSQL using VS Code + SQLTools.
2. Run the SQL scripts sequentially from the `sql/` directory.
3. Set the schema before running queries:

```sql
SET search_path TO ecom;
```

## Skills Demonstrated

**PostgreSQL:** CTEs · JOINs · CASE · Aggregations · `COUNT(DISTINCT)` · Window Functions · `LAG()` · `SUM() OVER()` · Date Analysis

**Analytics:** Revenue Analysis · AOV · MoM Growth · Customer Segmentation · Retention · Conversion · Product Performance · Returns Analysis · Business Recommendations
