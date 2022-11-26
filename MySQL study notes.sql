-- Study Notes
-- Lixia

-- Cht1 Introduction
USE sql_store;
SELECT *
FROM customers
WHERE customer_id = 1
ORDER BY first_name;

-- Cht2 Retrieving Data From a Single Table
-- 2.1 SELECT
USE sql_store;
SELECT first_name, last_name, points, (points +10) * 100 AS 'discount factor'
FROM customers;

USE sql_store;
SELECT name, unit_price, unit_price * 1.1 AS 'new price'
FROM products;

-- 2.2 WHERE
USE sql_store;
SELECT *
FROM customers
WHERE state = 'va';

USE sql_store;
SELECT *
FROM orders
WHERE order_date > '2019-01-01';

-- 2.3 AND OR NOT
USE sql_store;
SELECT *
FROM customers
WHERE birth_date > '1990-01-01' AND points > 1000;

USE sql_store;
SELECT *
FROM customers
WHERE birth_date > '1990-01-01' OR points > 1000 AND state = 'VA';

USE sql_store;
SELECT *
FROM customers
WHERE birth_date <= '1990-01-01' AND points <= 1000;

USE sql_store;
SELECT *
FROM order_items
WHERE order_id = 6 AND unit_price * quantity >30;

-- 2.4 IN、BETWEEN、LIKE、REGEXP、IS NULL 
USE sql_store;
SELECT * FROM customers
WHERE state IN ('va', 'fl', 'ga');

USE sql_store;
SELECT * FROM customers
WHERE state NOT IN ('va', 'fl', 'ga');

USE sql_store;
SELECT * FROM products
WHERE quantity_in_stock IN (49,38,72);

-- 2.5 BEETWEEN
USE sql_store;
SELECT * FROM customers
WHERE points BETWEEN 1000 AND 3000;

USE sql_store;
SELECT * FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- 2.6 LIKE
USE sql_store;
SELECT * FROM customers
WHERE last_name LIKE 'brush%';

USE sql_store;
SELECT * FROM customers
WHERE address LIKE '%Trail%' OR address LIKE '%avenue%';

USE sql_store;
SELECT * FROM customers
WHERE phone NOT LIKE '%9';

-- 2.7 REGEXP
USE sql_store;
SELECT * FROM customers
WHERE last_name REGEXP 'field';
-- WHERE last_name REGEXP '^mac|field$|rose'
-- WHERE last_name REGEXP '[gi]e|e[fmq]'
-- WHERE last_name regexp '[a-h]e|e[c-j]'

USE sql_store;
-- SELECT * from customers
-- WHERE first_name regexp 'ELKA | AMBUR'
-- WHERE last_name REGEXP 'ey$ | on$'
-- WHERE last_name REGEXP '^my | se'
-- WHERE last_name REGEXP 'b[ru]'/'br/bu'

-- 2.8 IS NULL 
USE sql_store;
SELECT * FROM customers
where phone IS NULL;

USE sql_store;
SELECT * FROM orders
WHERE shipper_id IS NULL;

-- 2.9 ORDER BY
USE sql_store;
SELECT name, unit_price * 1.1 +10 as new_price FROM products
ORDER BY new_price DESC, product_id;

USE sql_store;
SELECT * FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;

USE sql_store;
SELECT *, quantity * unit_price AS total_price FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

-- 2.10 LIMIT
USE sql_store;
SELECT * FROM customers
LIMIT 3;

USE sql_store;
SELECT * FROM customers
ORDER BY points DESC
LIMIT 3;

-- Cht 3 Retrieving data from multiple tables
-- 3.1 Inner Joins
USE sql_store;
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;
    
USE sql_store;
SELECT order_id, p.product_id, quantity_in_stock, oi.unit_price
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id;
    
-- 3.2 Joining Across Databases 
USE sql_store;
SELECT *
FROM order_items oi
  JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;
    
USE sql_inventory;
SELECT *
FROM sql_store.order_items oi
  JOIN products p
  ON oi.product_id = p.product_id;
  
-- 3.3 Self Joins 
USE sql_hr;
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
  JOIN employees m
  ON e.reports_to = m.employee_id;

-- 3.4 Joining Multiple Tables
USE sql_store;
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM orders o 
JOIN customers c
     ON o.customer_id = c.customer_id
JOIN order_statuses os
     ON o.order_id = os.order_status_id;
     
USE sql_invoicing;
SELECT p.invoice_id, p.date, p.amount, c.name, pm.name AS payment_method
FROM payments p
JOIN clients c
  ON p.client_id = c.client_id
JOIN payment_methods pm
  ON p.payment_method = pm.payment_method_id;
  
-- 3.5 Compound Join Conditions
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
     ON oi.order_id = oin.order_Id
     AND oi.product_id = oin.product_id;
     
-- 3.6 Implicit Join Syntax 
USE sql_store;
SELECT *
FROM orders o
JOIN customers c
     ON o.customer_id = c.customer_id;
  
USE sql_store;
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- 3.7 Outer Joins LEFT/RIGHT (OUTER) JOIN 
USE sql_store;
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
JOIN orders o
   ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

USE sql_store;
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
   ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

USE sql_store;
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o
   ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

USE sql_store;
SELECT p.product_id, p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
     ON p.product_id = oi.product_id;
     
-- 3.8 Outer Join Between Multiple Tables  
USE sql_store;
SELECT c.customer_id, c.first_name, o.order_id, sh.shipper_id AS shipper
FROM customers c
LEFT JOIN orders o
   ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
    ON o.shipper_id = sh.shipper_id;
    
USE sql_store;
SELECT o.order_date, o.order_id, c.first_name, sh.name AS shipper, os.name AS status
FROM orders o
JOIN customers c
   ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
   ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
   ON o.status = os.order_status_id;

-- 3.9 Self Outer Joins 
USE sql_hr;
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
LEFT JOIN employees m
    on e.reports_to = m.employee_id;
    
-- 3.10 USING  
USE sql_store;
SELECT
    o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
    USING (customer_id)
LEFT JOIN shippers sh
    USING (shipper_id)
ORDER BY o.order_id;

-- SELECT *
-- FROM order_items oi
-- JOIN order_item_notes oin
-- ON oi.order_id = oin.order_Id AND
-- oi.product_id = oin.product_id
-- /USING (order_id, product_id)

USE sql_invoicing;
SELECT p.date, c.name AS client, p.amount, pm.name
FROM payments p
JOIN clients c
     USING (client_id)
JOIN payment_methods pm
      ON p.payment_method = pm.payment_method_id;

-- 3.11 Natural Joins 
USE sql_store;
SELECT o.order_id, c.first_name
FROM  orders o
NATURAL JOIN customers c;

-- 3.12 Cross Joins 
USE sql_store;
SELECT 
    c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

USE sql_store;
SELECT c.first_name, p.name
FROM customers c, products p
ORDER BY c.first_name;

USE sql_store;
SELECT sh.name AS shippers, p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

USE sql_store;
SELECT sh.name AS shippers, p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;

-- 3.13 Unions
USE sql_store;
SELECT order_id, order_date, 'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT order_id, order_date, 'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

USE sql_store;
SELECT first_name AS name_of_all
FROM customers
UNION
SELECT name
FROM products;

USE sql_store;
SELECT  customer_id, first_name, points, 'Bronze' AS type
FROM customers
WHERE points < 2000 
UNION
SELECT  customer_id, first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT  customer_id, first_name, points, 'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;

-- Cht4 Inserting, Updating, and Deleting Data
-- 4.1 Column Attributes
-- 4.2 Inserting a Row 
USE sql_store;
INSERT INTO customers
VALUES (DEFAULT, 'Michael', 'Jackson','1958-08-29', DEFAULT, '5225 Figueroa Mountain Rd', 'Los Olivos','CA', DEFAULT);

USE sql_store;
INSERT INTO customers (address, city, state, last_name, first_name, birth_date)
VALUES ('5225 Figueroa Mountain Rd','Los Olivos','CA','Jackson','Michael','1958-08-29');

-- 4.3 Inserting Multiple Rows
USE sql_store;
INSERT INTO shippers (name)
VALUES ('shipper1'),
	   ('shipper2'),
       ('shipper3');
   
USE sql_store;
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('product1', 10, 1.95),
       ('product2', 11, 1.95),
       ('product3', 12, 1.95);
       
-- 4.4 Inserting Hierarchical Rows
USE sql_store;
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

USE sql_store;
INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1,2.95),
       (LAST_INSERT_ID(), 2, 1,3.95);
       
-- 4.5 Creating a Copy of a Table
USE sql_store;
CREATE TABLE orders_archived AS
       SELECT * FROM orders;
       
USE sql_store;
INSERT INTO orders_archived
SELECT * FROM orders
WHERE order_date < '2019-01-01';

USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT i.invoice_id, i.number, c.name AS client, i.invoice_total, i.payment_total, i.invoice_date, i.due_date, i.payment_date
FROM invoices i
JOIN clients c
     USING (client_id)
WHERE i.payment_date IS NOT NULL;

-- 4.6 Updating a Row
-- UPDATE invoices
-- SET payment_total = 100/0/DEFAULT/0.5 * invoice_total, 
-- payment_date = '2019-03-01'/NULL/due_date
-- WHERE invoice_id = 1/3

-- 4.7 Updating Multiple Rows
USE sql_invoicing;
UPDATE invoices
SET payment_total = 200, 
payment_date = due_date
WHERE client_id = 3;

USE sql_store;
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- 4.8 Using Subqueries in Updates
USE sql_invoicing; 
UPDATE invoices
SET payment_total = 200, 
payment_date = due_date
WHERE client_id = 
     (SELECT client_id
      FROM clients
      WHERE name = 'Myworks');
  
USE sql_invoicing;
UPDATE invoices
SET payment_total = 200, 
payment_date = due_date
WHERE client_id IN
     (SELECT client_id
      FROM clients
      WHERE state IN ('CA','NY'));
  
USE sql_store;
UPDATE orders
SET comments = 'Gold Customer'
WHERE customer_id IN 
     (SELECT customer_id
      FROM customers
      WHERE points > 3000);

-- 4.9 Deleting Rows
USE sql_invoicing;
DELETE FROM invoices
WHERE client_id = 
	(SELECT client_id
    FROM clients
    WHERE name = 'Myworks');

-- 4.10 Restoring the Databases


-- cht5 Summarizing Data
-- 5.1 Aggregate Functions 
USE sql_invoicing;
SELECT
     MAX(invoice_total) AS highest,
     MIN(invoice_total) AS lowest,
     AVG(invoice_total) AS average,
     SUM(invoice_total) AS total,
     COUNT(invoice_total) AS number_of_invoices,
     COUNT(*) AS total_record,
     COUNT(payment_date) AS number_of_payments,
     COUNT(DISTINCT client_id) AS number_of_distinct_clients
FROM invoices
WHERE invoice_date > '2019-07-01';

USE sql_invoicing;
SELECT 
      'First_half_of 2019' AS date_range,
      SUM(invoice_total) AS total_sales,
      SUM(payment_total) AS total_payments,
      SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN 2019-01-01 AND 2019-06-30
UNION
SELECT 
        'Second_half_of_2019' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS what_we_expect
    FROM invoices
    WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 
        'Total' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS what_we_expect
    FROM invoices
    WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';
    
-- cht 5.2 Group By
USE sql_invoicing;
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoice_date >= '2019-07-01'
GROUP BY client_id
ORDER BY total_sales DESC;

USE sql_invoicing;
SELECT state, city, SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING(client_id)
GROUP BY state, city;

USE sql_invoicing;
SELECT date, SUM(amount) AS total_payments, pm.name AS payment_method
FROM payments p
JOIN payment_methods pm
   ON p.payment_method = pm.payment_method_id
GROUP BY date, p.payment_method
ORDER BY date;
       
-- 5.3 Having
USE sql_invoicing;
SELECT client_id, SUM(invoice_total) AS total_sales, COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;

USE sql_store;
SELECT c.customer_id, c.first_name, c.last_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE state = 'VA'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_sales > 100;

-- 5.4 ROLLUP
USE sql_invoicing;
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;

USE sql_invoicing;
SELECT state, city, SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING(client_id)
GROUP BY state, city WITH ROLLUP;

USE sql_invoicing;
SELECT pm.name AS payment_method, SUM(amount) AS total
FROM payments p
JOIN payment_methods pm 
    ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;

-- Cht6 Writing Complex Query 
-- 6.1 Introduction
-- 6.2 Subqueries
USE sql_store;
SELECT *
FROM products
WHERE unit_price > (SELECT unit_price FROM products WHERE product_id = 3);

USE sql_hr;
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 6.3 IN
USE sql_store;
SELECT *
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN (SELECT DISTINCT client_id FROM invoices);

-- 6.4 Subqueries vs Joins
USE sql_invoicing;
SELECT *
FROM clients
LEFT JOIN invoices USING(client_id)
WHERE invoice_id IS NULL;

USE sql_store;
SELECT *
FROM customers
WHERE customer_id IN (SELECT o.customer_id FROM orders o JOIN order_items oi USING(order_id) WHERE product_id = 3);

USE sql_store;
SELECT DISTINCT customer_id, first_name, last_name
FROM customers c
JOIN orders o USING(customer_id)
JOIN order_items oi USING(order_id)
WHERE oi.product_id = 3;

-- 6.5 ALL
USE sql_invoicing;
SELECT *
FROM invoices
WHERE invoice_total > (SELECT MAX(invoice_total) FROM invoices WHERE client_id = 3);

USE sql_invoicing;
SELECT *
FROM invoices
WHERE invoice_total > ALL (SELECT invoice_total FROM invoices WHERE client_id = 3);

-- 6.6 ANY
USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id IN(SELECT client_id FROM invoices GROUP BY client_id HAVING COUNT(*) > 2);

USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id = ANY(SELECT client_id FROM invoices GROUP BY client_id HAVING COUNT(*) > 2);

-- 6.7 Correlated Subqueries
USE sql_hr;
SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE office_id = e.office_id);

USE sql_invoicing;
SELECT *
FROM invoices i
WHERE  invoice_total > (SELECT AVG(invoice_total) FROM invoices WHERE client_id = i.client_id);

-- 6.8 EXISTS
USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id IN (SELECT DISTINCT client_id FROM invoices);

USE sql_invoicing;
SELECT * 
FROM clients c
WHERE EXISTS (SELECT * FROM invoices WHERE client_id = c.client_id);

USE sql_store;
SELECT *
FROM products
WHERE product_id NOT IN (SELECT product_id FROM order_items);

USE sql_store;
SELECT * 
FROM products p
WHERE NOT EXISTS (SELECT * FROM order_items WHERE product_id = p.product_id);

-- 6.9 Subqueries in the SELECT Clause
USE sql_invoicing;
SELECT invoice_id, invoice_total, (SELECT AVG(invoice_total) FROM invoices) AS invoice_average, invoice_total-(SELECT invoice_average) AS difference
FROM invoices;

USE sql_invoicing;
SELECT client_id, name, 
      (SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
      (SELECT AVG(invoice_total) FROM invoices) AS average,
      (SELECT total_sales - average) AS difference
FROM clients c;

-- 6.10 Subqueries in the FROM Clause
USE sql_invoicing;
SELECT * 
FROM (
    SELECT client_id, name, 
      (SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
      (SELECT AVG(invoice_total) FROM invoices) AS average,
      (SELECT total_sales - average) AS difference
    FROM clients c
    ) AS sales_summury
WHERE total_sales IS NOT NULL;

-- cht 7
-- 7.1 Numeric Functions
SELECT ROUND(5.7365, 2);
SELECT TRUNCATE(5.7365, 2); 
SELECT CEILING(5.2);
SELECT FLOOR(5.6);
SELECT ABS(-5.2);
SELECT RAND();
-- GOOGLE mysql numeric function 

-- 7.2 String Functions GOOGLE mysql string functions
-- SELECT LENGTH('sky') 
-- SELECT UPPER('sky')  
-- SELECT LOWER('Sky')  
  
-- SELECT LTRIM('  Sky');
-- SELECT RTRIM('Sky  ');
-- SELECT TRIM(' Sky ');

-- SELECT LEFT('Kindergarden', 4)  
-- SELECT RIGHT('Kindergarden', 6)  
-- SELECT SUBSTRING('Kindergarden', 7, 6)  

-- SELECT LOCATE('gar', 'Kindergarden') 
-- SELECT REPLACE('Kindergarten', 'garten', 'garden')

USE sql_store;
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- 7.3 Date Functions in MySQL
-- SELECT NOW()  -- 2020-09-12 08:50:46
-- SELECT CURDATE()  -- current date, 2020-09-12
-- SELECT CURTIME()  -- current time, 08:50:46
-- SELECT YEAR(NOW())  -- 2020
-- SELECT MONTH(NOW())  -- 2020
-- SELECT DAYNAME(NOW())  -- Saturday
-- SELECT MONTHNAME(NOW())  -- September
-- SELECT EXTRACT(YEAR FROM NOW())

USE sql_store;
SELECT * FROM orders WHERE YEAR(order_date) = YEAR(now());

-- 7.4 Formatting Dates and Times GOOGLE mysql date format functions
-- SELECT DATE_FORMAT(NOW(), '%M %d, %Y')  -- September 12, 2020
-- SELECT TIME_FORMAT(NOW(), '%H:%i %p')  -- 11:07 AM

-- 7.5 Calculating Dates and Times
-- SELECT DATE_ADD(NOW(), INTERVAL -1 DAY)
-- SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR)
-- SELECT DATEDIFF('2019-01-01 09:00', '2019-01-05')  -- -4

-- TIME_TO_SEC：计算从 00:00 到
-- SELECT TIME_TO_SEC('09:00')  -- 32400
-- SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02')  -- -120

-- 7.6 IFNULL and COALESCE 
USE sql_store;
SELECT order_id, IFNULL(shipper_id, 'Not Assigned') AS shipper
FROM orders;

USE sql_store;
SELECT order_id, COALESCE(shipper_id, comments, 'Not Assigned') AS shipper
FROM orders;

USE sql_store;
SELECT CONCAT(first_name, '', last_name) AS customer, COALESCE(phone,'Unknown') AS phone
FROM customers;

-- 7.7 The IF Function
USE sql_store;
SELECT order_id, order_date, IF(YEAR(order_date) = YEAR(NOW()), 'Active', 'Archived') AS category
FROM orders;

USE sql_store;
SELECT product_id, name, count(*) AS orders, IF(count(*) > 1, 'Many Times', 'Once') AS frequency
 FROM products
 JOIN order_items USING (product_id)
 GROUP BY product_id, name;
 
 -- 7.8 CASE 
 -- CASE 
    -- WHEN …… THEN ……
    -- WHEN …… THEN ……
    -- WHEN …… THEN ……
    -- ……
    -- [ELSE ……] 
-- END

USE sql_store;
SELECT order_id,
    CASE WHEN YEAR(order_date) = YEAR(now()) THEN 'Active'
         WHEN YEAR(order_date) = YEAR(now())- 1 THEN 'Last Year'
         WHEN YEAR(order_date) < YEAR(now()) - 1 THEN 'Archived'
         ELSE 'Future'
	END AS category
FROM orders;

USE sql_store;
SELECT CONCAT(first_name, '', last_name) AS customer, points, 
       CASE WHEN points > 3000 THEN 'Gold'
            WHEN points >= 2000 THEN 'Silver'
            ELSE 'Bronze'
	   END AS category
FROM customers;

-- PART 3 Cht 8 Views
-- 8.1 Creating Views
USE sql_invoicing;
CREATE VIEW sales_by_client AS
    SELECT 
        client_id,
        name,
        SUM(invoice_total) AS total_sales
    FROM clients c
    JOIN invoices i USING(client_id)
    GROUP BY client_id, name;
    
USE sql_invoicing;
SELECT 
    s.name,
    s.total_sales,
    phone
FROM sales_by_client s
JOIN clients c USING(client_id)
WHERE s.total_sales > 500;

USE sql_invoicing;
CREATE VIEW clients_balance AS
    SELECT 
        client_id,
        c.name,
        SUM(invoice_total - payment_total) AS balance
    FROM clients c
    JOIN invoices USING(client_id)
    GROUP BY client_id;
    
-- 8.3 Updatable Views
USE sql_invoicing;
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT 
    invoice_id, 
    number, 
    client_id, 
    invoice_total, 
    payment_total, 
    invoice_date,
    invoice_total - payment_total AS balance,  
    due_date, 
    payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;
DELETE FROM invoices_with_balance
WHERE invoice_id = 1;
UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;

-- 8.4 WITH CHECK OPTION
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;

-- cht9 Stored Procedures
-- 9.1 What are Stored Procedures 
-- 9.2 Creating a Stored Procedure
-- DELIMITER $$
-- CREATE PROCEDURE get_clients()
  -- BEGIN
  -- SELECT * FROM clients;
  -- END $$
-- DELIMITER;

-- USE sql_invoicing;
-- CALL get_clients()

DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
	SELECT *
	FROM invoices_with_balance 
	WHERE balance > 0;
END$$
DELIMITER ;

CALL get_invoices_with_balance();

DELIMITER $$
    CREATE PROCEDURE get_clients()  
        BEGIN
            SELECT * FROM clients;
        END$$
DELIMITER ;

-- 9.3 Creating Procedures Using MySQLWorkbench
CALL get_payments();
-- 9.4 Dropping Stored Procedures
USE sql_invoicing;

DROP PROCEDURE IF EXISTS get_clients;

DELIMITER $$

    CREATE PROCEDURE get_clients()
        BEGIN
            SELECT * FROM clients;
        END$$

DELIMITER ;

CALL get_clients();

-- 9.5 Parameters 
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
( state CHAR(2) )
BEGIN
  SELECT * FROM clients c
  WHERE c.state=state;
END $$
DELIMITER ;
  
CALL get_clients_by_state('CA')

DELIMITER $$

CREATE PROCEDURE get_invoices_by_client
(
    client_id INT  
)
BEGIN
SELECT * 
FROM invoices i
WHERE i.client_id = client_id;
END$$

DELIMITER ;

CALL get_invoices_by_client(1);

-- 9.6 Parameters with Default Value
USE sql_invoicing;
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(state CHAR(2) )
BEGIN
    IF state IS NULL THEN 
        SET state = 'CA';  
    END IF;
    SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;
CALL get_clients_by_state(NULL)

/* 
BEGIN
    IF state IS NULL THEN 
        SELECT * FROM clients c;
    ELSE
        SELECT * FROM clients c
        WHERE c.state = state;
    END IF;    
END$$
*/

/* BEGIN
    SELECT * FROM clients c
    WHERE c.state = IFNULL(state, c.state)
END$$
*/

DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments
(
    client_id INT,  
    payment_method_id TINYINT
)
BEGIN
    SELECT * FROM payments p
    WHERE 
        p.client_id = IFNULL(client_id, p.client_id) AND
        p.payment_method = IFNULL(payment_method_id, p.payment_method);
END$$
DELIMITER ;

CALL get_payments(NULL, NULL);

-- 9.7 Parameter Validation
-- 9.8 Output Parameters x
-- 9.9 Variables
-- 9.10 Functions

-- cht 10 Triggers and Events
-- 10.1 Triggers 
DELIMITER $$
CREATE TRIGGER payments_after_insert
    AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
    UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END$$
DELIMITER ;
INSERT INTO payments
VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1);

DELIMITER $$
CREATE TRIGGER payments_after_delete
    AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
    UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END$$
DELIMITER ;

DELETE FROM payments
WHERE payment_id = 9;

-- 10.2 Viewing Triggers
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'payments';

-- 10.3 DROP TRIGGERS
DROP TRIGGER IF EXISTS payments_after_insert;

-- 10.4 Using Triggers for Auditing 
-- 10.5 events
SHOW VARIABLES;
SHOW VARIABLES LIKE 'event%';
DELIMITER $$
CREATE EVENT yearly_delete_stale_audit_row
ON SCHEDULE
    EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01' 
DO BEGIN
    DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END$$
DELIMITER ;
-- 10.6 Viewing, Dropping and Altering Events
SHOW EVENTS;

-- Cht 11 Transactions and Concurrency 
USE sql_store;
START TRANSACTION;
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-01', 1);
INSERT INTO order_items 
VALUES (last_insert_id(), 1, 2, 3);
COMMIT;

-- 11.3 Concurrency and Locking
USE sql_store;
START TRANSACTION;
UPDATE customers
SET points = points + 10
WHERE customer_id = 1;
COMMIT;

SHOW VARIABLES LIKE 'transaction_isolation';