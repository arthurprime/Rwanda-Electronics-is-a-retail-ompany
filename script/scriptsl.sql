-- ==================================================
-- 01. CREATE TABLES
-- ==================================================
CREATE TABLE Customers (
    customer_id   NUMBER(5) PRIMARY KEY,   -- Unique ID for each customer
    customer_name          VARCHAR2(50) NOT NULL,  -- Customer full name
    region        VARCHAR2(50),           -- Customer region
    join_date     DATE DEFAULT SYSDATE     -- Date customer joined
);
CREATE TABLE Products (
    product_id     NUMBER(5) PRIMARY KEY,      -- Unique product ID
    product_name   VARCHAR2(50) NOT NULL,      -- Name of the product
    category       VARCHAR2(50),               -- Product category
    price          NUMBER(10,2) NOT NULL       -- Product price
);
CREATE TABLE Sales (
    sale_id       NUMBER(5) PRIMARY KEY,        -- Unique sale ID
    customer_id   NUMBER(5) NOT NULL,           -- References Customers
    product_id    NUMBER(5) NOT NULL,           -- References Products
    sale_date     DATE DEFAULT SYSDATE,         -- Date of sale
    quantity      NUMBER(5) DEFAULT 1,          -- Quantity sold
    total_amount  NUMBER(10,2)                  -- Total amount = quantity * price
);

-- ==================================================
-- 02. INSERT DATA
-- ==================================================
INSERT INTO Customers (customer_id, name, region) VALUES (1, 'Alice Mukasa', 'Kigali');
INSERT INTO Customers (customer_id, name, region) VALUES (2, 'John Nkurunziza', 'Butare');
INSERT INTO Customers (customer_id, name, region) VALUES (3, 'Grace Uwimana', 'Kigali');
INSERT INTO Customers (customer_id, name, region) VALUES (4, 'Samuel Habimana', 'Gisenyi');
INSERT INTO Customers (customer_id, name, region) VALUES (5, 'Esther Iradukunda', 'Ruhengeri');
INSERT INTO Customers (customer_id, name, region) VALUES (6, 'Eric Munyaneza', 'Kigali');
INSERT INTO Customers (customer_id, name, region) VALUES (7, 'Diane Uwitonze', 'Butare');
INSERT INTO Customers (customer_id, name, region) VALUES (8, 'Paul Niyonsaba', 'Kigali');
INSERT INTO Customers (customer_id, name, region) VALUES (9, 'Claire Uwamahoro', 'Ruhengeri');
INSERT INTO Customers (customer_id, name, region) VALUES (10, 'Jean Bosco', 'Gisenyi');

INSERT INTO Products (product_id, product_name, category, price) VALUES (1, 'Smartphone X', 'Mobile', 450.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (2, 'Laptop Pro', 'Computers', 1200.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (3, 'Bluetooth Speaker', 'Audio', 80.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (4, 'Tablet Plus', 'Tablet', 300.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (5, 'Smartwatch A', 'Wearable', 150.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (6, 'Wireless Headphones', 'Audio', 120.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (7, 'Gaming Laptop', 'Computers', 1500.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (8, 'Desktop PC', 'Computers', 1000.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (9, 'HD TV', 'Electronics', 800.00);
INSERT INTO Products (product_id, product_name, category, price) VALUES (10, 'Camera Pro', 'Photography', 650.00);

INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (1, 1, 1, 2, 900.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (2, 2, 2, 1, 1200.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (3, 3, 3, 3, 240.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (4, 4, 4, 1, 300.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (5, 5, 5, 2, 300.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (6, 6, 6, 1, 120.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (7, 7, 7, 1, 1500.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (8, 8, 8, 1, 1000.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (9, 9, 9, 1, 800.00);
INSERT INTO Sales (sale_id, customer_id, product_id, quantity, total_amount) VALUES (10, 10, 10, 1, 650.00);






-- ==================================================
-- 03. JOIN QUERIES
-- ==================================================
-- INNER JOIN 

SELECT s.sale_id,
       c.customer_name,
       p.product_name,
       s.sale_date,
       s.quantity,
       s.total_amount
FROM Sales s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Products p ON s.product_id = p.product_id;


-- LEFT JOIN 
SELECT c.customer_name,
       s.sale_id
FROM Customers c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

--RIGHT JOIN
SELECT p.product_name,
       s.sale_id
FROM Products p
LEFT JOIN Sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- FULL OUTER JOIN
SELECT c.customer_name,
       p.product_name,
       s.sale_id
FROM Customers c
FULL OUTER JOIN Sales s ON c.customer_id = s.customer_id
FULL OUTER JOIN Products p ON s.product_id = p.product_id;
--SELF JOIN
SELECT c1.customer_name AS customer_1,
       c2.customer_name AS customer_2,
       c1.region
FROM Customers c1
INNER JOIN Customers c2
   ON c1.region = c2.region
   AND c1.customer_id < c2.customer_id;
--

-- ==================================================
-- 04. WINDOW FUNCTION QUERIES
-- ==================================================
-- Top 5 products per region
SELECT *
FROM (
    SELECT 
        region,
        product_id,
        SUM(amount) AS total_sales,
        RANK() OVER (
            PARTITION BY region 
            ORDER BY SUM(amount) DESC
        ) AS rnk
    FROM sales
    GROUP BY region, product_id
) ranked
WHERE rnk <= 5;

-- Running totals
SELECT 
    DATE_TRUNC('month', sale_date) AS month,
    SUM(amount) AS monthly_sales,
    SUM(SUM(amount)) OVER (
        ORDER BY DATE_TRUNC('month', sale_date)
    ) AS running_total
FROM sales
GROUP BY month;
--month growth
SELECT 
    month,
    monthly_sales,
    monthly_sales 
      - LAG(monthly_sales) OVER (ORDER BY month) 
      AS growth
FROM (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month,
        SUM(amount) AS monthly_sales
    FROM sales
    GROUP BY month
) t;
--customer quitile
SELECT 
    customer_id,
    SUM(amount) AS total_spent,
    NTILE(4) OVER (
        ORDER BY SUM(amount) DESC
    ) AS customer_quartile
FROM sales
GROUP BY customer_id;

