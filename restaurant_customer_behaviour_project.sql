-- Viewing the Menu items table.

SELECT * FROM menu_items;

-- Finding the number of items on the menu
SELECT count(*) FROM menu_items;

-- What are the least and most expensive items on the menu?
SELECT max(price) FROM menu_items;

SELECT min(price) FROM menu_items;

-- How many italian dishes are on the menu?
SELECT count(*) FROM menu_items
WHERE category = 'Italian';

-- What are the least and most expensive Italian dishes on the menu?
SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price desc;

-- How many dishes are in each category?
SELECT category, count(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category;

-- What is the average dish price within each category?
SELECT category, avg(price) AS avg_price
FROM menu_items
GROUP BY category;





## Exploring the Orders table

SELECT * FROM order_details;

-- Looking at the date range of the table
SELECT min(order_date) FROM order_details;
SELECT max(order_date) FROM order_details;

-- How many orders were made within this date range?
SELECT count(distinct order_id) FROM order_details;

-- How many items were ordered within this date range?
SELECT count(*) FROM order_details;

--  Which orders had the most number of items?
SELECT order_id, count(item_id) AS num_items FROM order_details
GROUP BY order_id
ORDER BY num_items desc;

-- How many orders had more than 12 items?
SELECT COUNT(*) FROM

(SELECT order_id, count(item_id) AS num_items 
FROM order_details
GROUP BY order_id
HAVING num_items > 12) AS num_orders; 




## Analysing Customer Behaviour

-- Combining the menu_items and order_details table into a single table
SELECT *
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id;

-- What were the least and most ordered items? What categories where they in?
SELECT item_name, category, count(order_id) as items_ordered
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY items_ordered desc;

-- What were the top 5 orders that spent the most money?
SELECT order_id, sum(price)
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY sum(price) DESC
LIMIT 5;

-- View the details of the highest spend order. What insights can you gather from the data?
SELECT*
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id = 440;

SELECT category, count(order_id) as num_orders
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category
ORDER BY num_orders DESC;

-- View the details of the top 5 highest spend orders. What insights can you gather from this?
SELECT order_id, category, count(order_id) as num_orders
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1975, 330, 2675)
GROUP BY order_id, category;

