create catalog if not exists retail_analytics;

create schema if not exists retail_analytics.bronze;
create schema if not exists retail_analytics.silver;
create schema if not exists retail_analytics.gold;

create table if not exists retail_analytics.bronze.customer (customer_id string, first_name string, last_name string, country string, signup_date date, email string);

insert into retail_analytics.bronze.customer (customer_id, first_name, last_name, country, signup_date, email) values('C001', 'Maria', 'Lopez','Mexico', '2026-01-15','maria@email.com'),('C002','John','Smith','USA','2026-02-10','john@email.com'),('C003','Carlos','Ruiz','Mexico','2026-02-25','carlos@email.com'),('C004','Ana','Garcia','Colombia','2026-03-03','ana@email.com'),('C005','Laura','Martinez','Mexico','2026-03-15','laura@email.com');
    
select * from retail_analytics.bronze.customer;

insert into retail_analytics.bronze.customer (customer_id, first_name, last_name, country, signup_date, email) values('C001', 'Maria', 'Lopez','Mexico', '2026-01-15','maria@email.com'),('C002','John','Smith','USA','2026-02-10','john@email.com'),('C003','Carlos','Ruiz','Mexico','2026-02-25','carlos@email.com'),('C004','Ana','Garcia','Colombia','2026-03-03','ana@email.com'),('C005','Laura','Martinez','Mexico','2026-03-15','laura@email.com');

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customer_ids,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails,
    COUNT(country) AS non_null_countries,
    COUNT(*) - COUNT(country) AS null_countries
FROM retail_analytics.bronze.customer;

INSERT INTO retail_analytics.bronze.customer
(customer_id, first_name, last_name, country, signup_date, email)
VALUES
    ('C007', ' Sofia ', 'Hernandez', ' mexico ', '2026-04-10', 'SOFIA@EMAIL.COM '),
    ('C008', 'Roberto', 'Diaz', 'USA', '2026-04-11', NULL),
    ('C003', 'Carlos', 'Ruiz', 'Mexico', '2026-04-12', 'carlos.new@email.com'),
    ('C009', 'Elena', 'Torres', 'MEXICO', '2026-04-13', 'elena@email');

SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    TRIM(country) AS country,
    LOWER(TRIM(email)) AS email,
    signup_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY signup_date DESC
    ) AS row_num
FROM retail_analytics.bronze.customer;

select
CASE
    WHEN UPPER(TRIM(country)) = 'MEXICO' THEN 'Mexico'
    WHEN UPPER(TRIM(country)) = 'USA' THEN 'USA'
    WHEN UPPER(TRIM(country)) = 'COLOMBIA' THEN 'Colombia'
    ELSE TRIM(country)
END AS country
from retail_analytics.bronze.customer;


SELECT
    email,
    CASE
        WHEN TRIM(email) RLIKE '^[^@]+@[^@]+\.[^@]+$'
            THEN LOWER(TRIM(email))
        ELSE NULL
    END AS cleaned_email
FROM retail_analytics.bronze.customer;


WITH cleaned_customers AS (

    SELECT
        customer_id,

        TRIM(first_name) AS first_name,

        TRIM(last_name) AS last_name,

        CASE
            WHEN UPPER(TRIM(country)) = 'MEXICO' THEN 'Mexico'
            WHEN UPPER(TRIM(country)) = 'USA' THEN 'USA'
            WHEN UPPER(TRIM(country)) = 'COLOMBIA' THEN 'Colombia'
            ELSE TRIM(country)
        END AS country,

        CASE
            WHEN TRIM(email) RLIKE '^[^@]+@[^@]+\.[^@]+$'
                THEN LOWER(TRIM(email))
            ELSE NULL
        END AS email,

        signup_date,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY signup_date DESC
        ) AS row_num

    FROM retail_analytics.bronze.customer
)

SELECT
    *
FROM cleaned_customers
WHERE row_num = 1;


%sql

CREATE OR REPLACE TABLE retail_analytics.silver.customer
AS

WITH cleaned_customers AS (

    SELECT
        customer_id,

        TRIM(first_name) AS first_name,

        TRIM(last_name) AS last_name,

        CASE
            WHEN UPPER(TRIM(country)) = 'MEXICO' THEN 'Mexico'
            WHEN UPPER(TRIM(country)) = 'USA' THEN 'USA'
            WHEN UPPER(TRIM(country)) = 'COLOMBIA' THEN 'Colombia'
            ELSE TRIM(country)
        END AS country,

        CASE
            WHEN TRIM(email) RLIKE '^[^@]+@[^@]+\.[^@]+$'
                THEN LOWER(TRIM(email))
            ELSE NULL
        END AS email,

        signup_date,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY signup_date DESC
        ) AS row_num

    FROM retail_analytics.bronze.customer
)

SELECT
    customer_id,
    first_name,
    last_name,
    country,
    email,
    signup_date
FROM cleaned_customers
WHERE row_num = 1;

select country, count (*) as clients_per_country
from retail_analytics.silver.customer
group by country;

CREATE OR REPLACE TABLE retail_analytics.gold.customers_by_country
AS
SELECT country, count(*) as clients_per_country
from retail_analytics.silver.customer
group by country
order by clients_per_country desc;

CREATE OR REPLACE TABLE retail_analytics.bronze.product (
    product_id STRING,
    product_name STRING,
    category STRING,
    unit_price DECIMAL(10,2)
);

INSERT INTO retail_analytics.bronze.product
(product_id, product_name, category, unit_price)
VALUES
('P001', 'Laptop Pro 14', 'Electronics', 18999.99),
('P002', 'Wireless Mouse', 'Accessories', 599.90),
('P003', 'Mechanical Keyboard', 'Accessories', 1499.00),
('P004', '27 Inch Monitor', 'Electronics', 5499.50),
('P005', 'USB-C Hub', 'Accessories', 899.00),
('P006', 'Noise Cancelling Headphones', 'Audio', 3299.99);

Create or replace table retail_analytics.bronze.orders (
    order_id STRING, 
    customer_id STRING,
    product_id STRING,
    order_date DATE,
    quantity INT,
    unit_price DECIMAL(10,2)
);

INSERT INTO retail_analytics.bronze.orders
(order_id, customer_id, product_id, order_date, quantity, unit_price)
VALUES
('O001', 'C001', 'P001', '2026-05-01', 1, 18500.00),
('O002', 'C002', 'P002', '2026-05-02', 2, 599.90),
('O003', 'C003', 'P005', '2026-05-03', 3, 850.00),
('O004', 'C004', 'P004', '2026-05-04', 1, 5499.50),
('O005', 'C005', 'P003', '2026-05-05', 1, 1399.00),
('O006', 'C001', 'P006', '2026-05-06', 2, 3199.99),
('O007', 'C008', 'P002', '2026-05-07', 1, 579.90),
('O008', 'C003', 'P001', '2026-05-08', 1, 17999.00),
('O009', 'C006', 'P004', '2026-05-09', 2, 5299.50),
('O010', 'C009', 'P003', '2026-05-10', 3, 1299.00);

select o.order_id, c.first_name, c.last_name, p.product_name, o.quantity
from retail_analytics.bronze.orders o
inner join retail_analytics.silver.customer c
on o.customer_id=c.customer_id
inner join retail_analytics.bronze.product p
on o.product_id=p.product_id;

SELECT
    p.product_id,
    SUM(o.quantity) AS total_sold,
    SUM(o.quantity * o.unit_price) AS total_revenue
FROM retail_analytics.bronze.product p
INNER JOIN retail_analytics.bronze.orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;

SELECT
    o.order_id,
    o.customer_id,
    o.product_id
FROM retail_analytics.bronze.orders o
LEFT JOIN retail_analytics.silver.customer c
    ON o.customer_id = c.customer_id
LEFT JOIN retail_analytics.bronze.product p
    ON o.product_id = p.product_id
WHERE c.customer_id IS NULL
   OR p.product_id IS NULL;

CREATE OR REPLACE TABLE retail_analytics.silver.orders AS
SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.quantity,
    o.unit_price,
    o.quantity * o.unit_price AS line_total
FROM retail_analytics.bronze.orders o
INNER JOIN retail_analytics.silver.customer c
    ON o.customer_id = c.customer_id
INNER JOIN retail_analytics.bronze.product p
    ON o.product_id = p.product_id
WHERE o.quantity > 0
  AND o.unit_price > 0;

CREATE OR REPLACE TABLE retail_analytics.gold.revenue_by_product AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.line_total) AS total_revenue
FROM retail_analytics.silver.orders o
INNER JOIN retail_analytics.bronze.product p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category;

CREATE OR REPLACE TABLE retail_analytics.gold.revenue_by_category AS
SELECT
    p.category,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.line_total) AS total_revenue
FROM retail_analytics.silver.orders o
INNER JOIN retail_analytics.bronze.product p
    ON o.product_id = p.product_id
GROUP BY p.category;




