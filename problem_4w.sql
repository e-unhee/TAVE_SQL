-- 608
-- case문 이용 -> when then을 이용해서 조건 필터링

SELECT id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT p_id FROM Tree)THEN 'Inner'
        ELSE 'Leaf'
        END AS type
 FROM Tree;


-- 626.
-- 앞 문제와 동일하게 CASE로 조건 필터링

SELECT
    CASE
        -- 홀수이고 뒷 번호가 있을 때와 없을 때를 나누어야 하기 때문에 AND로 id+1 조건 추가
        WHEN id % 2 =1 AND id+1 IN (SELECT id FROM Seat) THEN id+1
        WHEN id % 2 =0 THEN id-1
        ELSE id
        END AS id, 
  student
FROM Seat
ORDER BY id;


-- 1045.

SELECT customer_id 
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product);


--1070.

SELECT product_id, year AS first_year, quantity, price
FROM Sales
-- 한 product에 대해 최소 year을 가져와야 하기 때문에 튜브 형태로 묶어서 비교하는 것
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year) 
    FROM Sales
    GROUP BY product_id
);


-- 1158.

SELECT 
    u.user_id AS buyer_id,
    u.join_date,
    COUNT(o.order_id) AS orders_in_2019
FROM Users u
LEFT JOIN Orders o
    ON u.user_id = o.buyer_id
    AND YEAR(o.order_date) = 2019
GROUP BY u.user_id, u.join_date;
-- 어차피 user별 join_date 하나 밖에 매칭 안되는데 굳이 groupby에 넣어야 함 ? -> MYSQL에서는 돌아갈 지 몰라도 SQL 표준 모드에서는 에러가 남
-- *SELECT 절에 있는 비집계칼럼은 반드시 GROUP BY 절에도 포함이 되어야 함


-- 1204.

With sum_weights AS (
    SELECT *,
        # SUM 함수에 특정 행에 대한 조건을 달고 싶을 때 사용하는 함수가 OVER()
        SUM(weight) OVER(ORDER BY turn) AS total_weight
    FROM Queue
)

SELECT person_name
FROM sum_weights 
WHERE total_weight<=1000
ORDER BY total_weight DESC
LIMIT 1
