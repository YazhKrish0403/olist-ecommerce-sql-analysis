-- ============================================================
-- OLIST E-COMMERCE DATA ANALYSIS
-- SQL PORTFOLIO PROJECT
-- ============================================================
--
-- Author: Yazhini Krishnasamy
-- Database: MySQL
--
-- Project Objective:
-- Analyze Olist e-commerce data to understand orders, customers,
-- revenue, products, sellers, payment behavior, and sales trends.
--
-- PROJECT WORKFLOW
-- 1. Data Cleaning & Validation
-- 2. Exploratory Data Analysis
-- 3. Business Questions
-- 4. Business Insights
--
-- CORE TABLES USED:
-- customers
-- orders
-- order_item
-- products
-- order_payments
-- sellers
-- category_translation
--
-- EXCLUDED:
-- geolocation
-- order_reviews
-- ============================================================

-- ============================================================
-- SECTION 1: DATA CLEANING & VALIDATION
-- ============================================================
-- 1. CUSTOMERS - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_unique_id IS NULL) AS missing_customer_unique_id,
    SUM(customer_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(customer_city IS NULL) AS missing_city,
    SUM(customer_state IS NULL) AS missing_state
FROM customers;

-- Check duplicate customer_id

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- ============================================================
-- 2. ORDERS - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_status IS NULL) AS missing_order_status,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date
FROM orders;

-- Check duplicate order_id

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- ============================================================
-- 3. ORDER ITEM - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_item_id IS NULL) AS missing_order_item_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(price IS NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight
FROM order_item;

-- ============================================================
-- 4. PRODUCTS - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM products;

-- Check duplicate product_id

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- ============================================================
-- 5. ORDER_PAYMENTS - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(payment_sequential IS NULL) AS missing_payment_sequential,
    SUM(payment_type IS NULL) AS missing_payment_type,
    SUM(payment_installments IS NULL) AS missing_installments,
    SUM(payment_value IS NULL) AS missing_payment_value
FROM order_payments;

-- ============================================================
-- 6. SELLERS - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(seller_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(seller_city IS NULL) AS missing_city,
    SUM(seller_state IS NULL) AS missing_state
FROM sellers;

-- Check duplicate seller_id

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Validate ZIP code format

SELECT *
FROM sellers
WHERE seller_zip_code_prefix NOT REGEXP '^[0-9]{5}$';

-- ============================================================
-- 7. CATEGORY TRANSLATION - DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(product_category_name IS NULL) AS missing_category_name,
    SUM(product_category_name_english IS NULL) AS missing_english_name
FROM category_translation;

-- Check duplicate categories

SELECT
    product_category_name,
    COUNT(*) AS duplicate_count
FROM category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

-- Check blank category names

SELECT *
FROM category_translation
WHERE TRIM(product_category_name) = ''
   OR TRIM(product_category_name_english) = '';

-- ============================================================
-- SECTION 2: BASIC BUSINESS ANALYSIS
-- ============================================================
-- 1. UNIQUE ORDERS
-- Business Question:
-- How many unique orders were placed?
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

-- ============================================================
-- 2. UNIQUE CUSTOMERS
-- Business Question:
-- How many customers placed at least one order?
-- ============================================================

SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;

-- ============================================================
-- 3. ORDER STATUS DISTRIBUTION
-- Business Question:
-- How many orders are there for each order status?
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- ============================================================
-- 4. CANCELED AND UNAVAILABLE ORDERS
-- Business Question:
-- How many orders were canceled or unavailable?
-- ============================================================

SELECT
    COUNT(*) AS canceled_or_unavailable_orders
FROM orders
WHERE order_status IN ('canceled', 'unavailable');

-- ============================================================
-- 5. ORDER STATUS PERCENTAGE
-- Business Question:
-- What percentage of total orders belongs to each status?
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- ============================================================
-- 6. YEARLY ORDER TREND
-- Business Question:
-- How many orders were placed each year?
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS order_count
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

-- ============================================================
-- 7. MONTHLY ORDER TREND
-- Business Question:
-- How many orders were placed each month?
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS order_count
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;

-- ============================================================
-- SECTION 3: REVENUE ANALYSIS
-- ============================================================
-- 8. TOTAL REVENUE
-- Business Question:
-- What is the total payment value generated?
-- ============================================================

SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;

-- ============================================================
-- 9. AVERAGE ORDER VALUE
-- Business Question:
-- What is the average payment value per order?
-- ============================================================

SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS order_total
    FROM order_payments
    GROUP BY order_id
) AS order_values;

-- ============================================================
-- 10. MONTHLY REVENUE
-- Business Question:
-- How does revenue change over time?
-- ============================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;

-- ============================================================
-- 11. REVENUE BY CUSTOMER STATE
-- Business Question:
-- Which customer states generate the most revenue?
-- ============================================================

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- ============================================================
-- SECTION 4: PAYMENT ANALYSIS
-- ============================================================
-- 12. PAYMENT TYPE ANALYSIS
-- Business Question:
-- Which payment methods are most commonly used?
-- ============================================================

SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- ============================================================
-- 13. PAYMENT INSTALLMENT ANALYSIS
-- Business Question:
-- How are payments distributed across installments?
-- ============================================================

SELECT
    payment_installments,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- ============================================================
-- SECTION 5: PRODUCT & CATEGORY ANALYSIS
-- ============================================================
-- 14. TOP PRODUCT CATEGORIES BY REVENUE
-- Business Question:
-- Which product categories generate the highest revenue?
-- ============================================================

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_item oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )
ORDER BY product_revenue DESC
LIMIT 10;

-- ============================================================
-- 15. TOP PRODUCT CATEGORIES BY ITEMS SOLD
-- Business Question:
-- Which categories have the highest number of items sold?
-- ============================================================

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS product_category,
    COUNT(*) AS items_sold
FROM order_item oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )
ORDER BY items_sold DESC
LIMIT 10;

-- ============================================================
-- 16. AVERAGE PRODUCT PRICE BY CATEGORY
-- Business Question:
-- What is the average selling price by product category?
-- ============================================================

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS product_category,
    ROUND(AVG(oi.price), 2) AS average_price
FROM order_item oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )
ORDER BY average_price DESC;

-- ============================================================
-- 17. TOP PRODUCTS BY REVENUE
-- Business Question:
-- Which individual products generate the highest revenue?
-- ============================================================

SELECT
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    COUNT(*) AS items_sold
FROM order_item oi
GROUP BY oi.product_id
ORDER BY product_revenue DESC
LIMIT 10;

-- ============================================================
-- 18. PRODUCT PRICE VS FREIGHT
-- Business Question:
-- What is the average product price compared with freight cost?
-- ============================================================

SELECT
    ROUND(AVG(price), 2) AS average_product_price,
    ROUND(AVG(freight_value), 2) AS average_freight_value
FROM order_item;

-- ============================================================
-- SECTION 6: SELLER ANALYSIS
-- ============================================================
-- 19. TOP SELLERS BY REVENUE
-- Business Question:
-- Which sellers generate the highest product revenue?
-- ============================================================

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(oi.price), 2) AS seller_revenue
FROM sellers s
JOIN order_item oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY seller_revenue DESC
LIMIT 10;

-- ============================================================
-- 20. TOP SELLERS BY ITEMS SOLD
-- Business Question:
-- Which sellers have sold the most items?
-- ============================================================

SELECT
    seller_id,
    COUNT(*) AS items_sold
FROM order_item
GROUP BY seller_id
ORDER BY items_sold DESC
LIMIT 10;

-- ============================================================
-- 21. SELLER PERFORMANCE BY STATE
-- Business Question:
-- Which seller states have the highest sales?
-- ============================================================

SELECT
    s.seller_state,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM sellers s
JOIN order_item oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC;

-- ============================================================
-- SECTION 7: CUSTOMER ANALYSIS
-- ============================================================
-- 22. ORDERS BY CUSTOMER STATE
-- Business Question:
-- Which customer states generate the most orders?
-- ============================================================

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY order_count DESC;

-- ============================================================
-- 23. CUSTOMERS BY CITY
-- Business Question:
-- Which customer cities have the highest number of orders?
-- ============================================================

SELECT
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_city,
    c.customer_state
ORDER BY order_count DESC
LIMIT 10;

-- ============================================================
-- SECTION 8: ADDITIONAL BUSINESS ANALYSIS
-- ============================================================
-- 24. ORDERS BY DAY OF WEEK
-- Business Question:
-- Which days receive the most orders?
-- ============================================================

SELECT
    DAYNAME(order_purchase_timestamp) AS day_of_week,
    COUNT(*) AS order_count
FROM orders
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY order_count DESC;

-- ============================================================
-- 25. ORDERS BY HOUR
-- Business Question:
-- During which hours are the most orders placed?
-- ============================================================

SELECT
    HOUR(order_purchase_timestamp) AS order_hour,
    COUNT(*) AS order_count
FROM orders
GROUP BY HOUR(order_purchase_timestamp)
ORDER BY order_count DESC;

-- ============================================================
-- 26. REVENUE BY PAYMENT TYPE
-- Business Question:
-- How much revenue is generated through each payment method?
-- ============================================================

SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS average_payment
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- ============================================================
-- 27. HIGH-VALUE ORDERS
-- Business Question:
-- Which orders have the highest total payment value?
-- ============================================================

SELECT
    order_id,
    ROUND(SUM(payment_value), 2) AS order_value
FROM order_payments
GROUP BY order_id
ORDER BY order_value DESC
LIMIT 10;

-- ============================================================
-- 28. TOP CATEGORIES BY AVERAGE ORDER ITEM PRICE
-- Business Question:
-- Which categories have the highest average item price?
-- ============================================================

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS product_category,
    ROUND(AVG(oi.price), 2) AS average_item_price,
    COUNT(*) AS items_sold
FROM order_item oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )
ORDER BY average_item_price DESC
LIMIT 10;

-- ============================================================
-- PROJECT END
-- ============================================================


