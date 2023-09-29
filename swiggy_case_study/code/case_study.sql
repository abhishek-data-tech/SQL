USE swiggy;

-- find the customers who never ordered

SELECT user_id, name FROM users
WHERE user_id NOT IN (SELECT DISTINCT(user_id) FROM orders);

-- average price for each dish

SELECT f_name , AVG(price) AS avg_price FROM menu M
INNER JOIN food F
ON M.f_id = F.f_id
GROUP BY F.f_name
ORDER BY avg_price DESC;

-- find the top restaurants in terms of number of orders for a given month

SELECT * FROM (
SELECT MONTHNAME(DATE),R.r_name,COUNT(order_id),
DENSE_RANK() OVER(ORDER BY COUNT(order_id) DESC) AS top_res
FROM orders O
INNER JOIN restaurants R
ON O.r_id = R.r_id
GROUP BY MONTHNAME(date),R.r_name
ORDER BY MONTHNAME(date) ASC , COUNT(order_id) DESC ) T 
WHERE T.top_res = 1;

-- restaurants with monthly sales

SELECT MONTHNAME(date),R.r_name,SUM(amount) FROM orders O
INNER JOIN restaurants R 
ON O.r_id = R.r_id
GROUP BY MONTHNAME(date),R.r_name
ORDER BY MONTHNAME(date);

-- show all orders with order details for particular customer in specific date range (Pick any user)
SELECT U.name,O.order_id,R.r_name,F.f_name FROM users U 
INNER JOIN orders O
ON U.user_id = O.user_id
JOIN restaurants R
ON O.r_id = R.r_id
JOIN order_details OD 
ON O.order_id = OD.order_id
JOIN food F 
ON OD.f_id = F.f_id
WHERE U.name like "Ankit" AND Date BETWEEN "2022-06-10" AND "2022-07-10";

-- find restaurants with max repeated customers
SELECT t.r_id ,count(*) FROM 
(SELECT r_id,user_id,count(order_id) AS visit FROM orders
GROUP BY r_id,user_id
HAVING visit > 1 ) t 
INNER JOIN restaurants R 
ON t.r_id = R.r_id 
GROUP BY t.r_id
ORDER BY COUNT(*) DESC LIMIT 1;


-- find customer favourite food 
select * from (
SELECT f.f_name,O.user_id,count(OD.f_id),
DENSE_RANK() OVER(partition by user_id order by count(OD.f_id) DESC) as fav_food
FROM ORDERS O 
INNER JOIN order_details OD
ON O.order_id = OD.order_id
Inner JOIN food f 
ON f.f_id = OD.f_id
group by O.user_id,f.f_name ) t 
where t.fav_food = 1;





























 








