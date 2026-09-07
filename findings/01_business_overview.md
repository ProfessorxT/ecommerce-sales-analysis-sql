ness Overview & Data Architecture

**To:** Chief Technology Officer

**From:** Data Analyst

**Subject:** Initial Database Assessment & Operational Scale

### 1. Business Model & Scale

The business operates as a multi-category direct-to-consumer (D2C) ecommerce platform. Across the **March–June 2026** transactional period recorded in the database, the company processed **40,000 orders** across **8,800 unique ordering customers**, generating approximately **₹29.88 Cr in revenue**.

Key commercial metrics include:

- **10,000 registered customers**, with **88%** having placed at least one order
- **₹7,468.86 average order value (AOV)**
- **28.7% session-to-order conversion rate** across 100,000 sessions
- **18 product categories**
- Approximately **4.5 orders per ordering customer**

### 2. Core Relational Architecture

The core transaction engine follows a relational structure linking:

`customers` → `orders` → `order_items` → `product_variants` → `products` → `categories`

The broader `ecom` schema contains **48 tables**, extending beyond core transactions into:

- **Customer & engagement:** sessions, devices, segments, loyalty
- **Marketing:** campaigns, attribution, channels, promotions
- **Financial:** payment intents, payment transactions, refunds
- **Operations:** inventory, shipments, shipping methods and carriers
- **Product & experimentation:** reviews, pricing, experiments and variants

This architecture supports end-to-end analysis from customer acquisition and browsing behavior through purchase, fulfillment, and post-purchase activity.

### 3. Interesting Observations

The initial analysis highlights several areas requiring further investigation:

- **Revenue volatility:** Revenue peaked at **₹12.93 Cr in April**, increasing **81% MoM**, before declining **40% in May** and **74% in June**. The decline closely tracks order-volume changes.
- **Customer retention:** **43.19%** of ordering customers are repeat buyers, while **56.81% (4,999 customers)** are one-time buyers, creating a significant retention opportunity.
- **Conversion opportunity:** **28.7%** of sessions result in an order, meaning **71.3% of sessions do not convert**.
- **Returns:** Approximately **4.01% of orders** have return requests. Leading drivers include late delivery, damaged items, and missing parts.
- **Product concentration:** Smartwatches and headphones dominate the highest-revenue products, making electronics an important revenue-driving category.

Overall, the database provides a strong foundation for deeper analysis of **customer retention, conversion, marketing performance, operational efficiency, and revenue drivers**.
