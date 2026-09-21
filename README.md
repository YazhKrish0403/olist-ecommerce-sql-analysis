# Olist E-Commerce SQL Analysis

## 📌 Project Overview

This project analyzes Olist e-commerce data using **MySQL** to understand order performance, customer behavior, revenue, products, sellers, payment methods, and sales trends.

The project focuses on transforming raw e-commerce data into meaningful business insights using SQL.

## 🎯 Project Objective

The main objectives of this project are to:

* Analyze overall order performance
* Understand order status distribution
* Analyze revenue and payment behavior
* Identify top-performing product categories
* Analyze seller performance
* Understand customer distribution
* Identify sales trends over time
* Answer practical business questions using SQL

## 🗂️ Dataset

The project uses the **Olist Brazilian E-Commerce Dataset**.

The dataset contains information about orders, customers, products, sellers, payments, and product categories.

## 🛠️ Tools & Technologies

* **MySQL**
* **SQL**
* **GitHub**

## 📊 Core Tables Used

The analysis uses the following tables:

* `customers`
* `orders`
* `order_item`
* `products`
* `order_payments`
* `sellers`
* `category_translation`

### Excluded Tables

The following tables were excluded from the project to keep the analysis focused on the core business data:

* `geolocation`
* `order_reviews`

## 🧹 Data Cleaning & Validation

Before performing the analysis, the data was validated using SQL.

The validation included:

* Checking total row counts
* Identifying missing values
* Checking duplicate IDs
* Validating seller ZIP code format
* Checking blank category names
* Validating key fields across the core tables

## 🔍 Business Analysis

The project answers business questions related to:

### Orders

* How many unique orders were placed?
* How many customers placed orders?
* How are orders distributed across different statuses?
* How many orders were canceled or unavailable?
* What percentage of orders belongs to each status?
* How do order volumes change over time?

### Revenue

* What is the total payment value generated?
* What is the average order value?
* How does revenue change over time?
* Which customer states generate the most revenue?

### Payments

* Which payment methods are most commonly used?
* How are payments distributed across installments?
* How much revenue is generated through each payment method?

### Products & Categories

* Which product categories generate the highest revenue?
* Which categories have the highest number of items sold?
* What is the average selling price by category?
* Which individual products generate the highest revenue?
* How does product price compare with freight cost?

### Sellers

* Which sellers generate the highest revenue?
* Which sellers have sold the most items?
* Which seller states have the highest sales?

### Customers

* Which customer states generate the most orders?
* Which customer cities have the highest number of orders?

### Additional Analysis

* Which days receive the most orders?
* During which hours are the most orders placed?
* Which orders have the highest total payment value?
* Which categories have the highest average item price?

## 🧠 SQL Skills Demonstrated

This project demonstrates practical use of:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `COUNT`
* `SUM`
* `AVG`
* `ROUND`
* `DISTINCT`
* `JOIN`
* `LEFT JOIN`
* `COALESCE`
* Subqueries
* Aggregate functions
* Date and time functions
* Conditional filtering
* Data validation techniques

## 📈 Key Insights

Key findings from the analysis will be documented here after completing the analysis and reviewing the query results.

## 📁 Project Files

```text
olist-ecommerce-sql-analysis/
│
├── olist_ecommerce_analysis.sql
└── README.md
```

## 🚀 Future Improvements

This project can be extended by:

* Building an interactive **Power BI dashboard**
* Adding advanced SQL analysis
* Creating additional business KPIs
* Performing deeper customer and seller analysis

## 👩‍💻 Author

**Yazhini Krishnasamy**

Aspiring Data Analyst | SQL | Excel | Power BI
