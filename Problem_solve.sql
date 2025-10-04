-- leetcode

-- 176. Second Highest Salary
-- OFFSET, DISTINCT 개념만 추가적으로 알고 있다면 충분히 풀이 가능

SELECT DISTINCT salary AS SecondHighestSalary
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;


-- 177: Nth Highest Salary
-- MySQL에서 인자를 넣을 때 SET을 사용한다는 걸 알고 있어야 함

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N=N-1;  -- N에서 1을 빼는 이유: OFFSET은 첫번째 행에서 얼마만큼 이동할 지를 결정하는 함수이기 때문 
  RETURN (
    SELECT DISTINCT salary 
    FROM Employee 
    ORDER BY salary DESC 
    LIMIT 1 OFFSET N
  );
END

  
-- 178. Rank scores
-- 임시 table, GROUP BY 개념 추가적으로 필요

SELECT S.score,
  COUNT(S2.SCORE) AS "rank" -- MySQL은 대소문자 구분 X -> RANK는 command라서 별칭으로 쓰려면 반드시 "" 사용
FROM SCORES S,
     (SELECT DISTINCT SCORE FROM SCORES)  S2
WHERE S.SCORE <= S2.SCORE 
GROUP BY S.ID 
ORDER BY S.SCORE DESC;

----------------------------------------------- 3WEEK----------------------------------------------------------------

-- 262. Trips and Users
-- 취소율: canceled+unbanned / total+unbanned

-- CTE(공통 테이블 표현식) -> SQL 쿼리 내에서 임시로 사용할 수 있는 결과 집합을 정의하는 문법
-- banned_users라는 임시 쿼리 생성
WITH banned_users AS (
    SELECT users_id
    FROM Users
    WHERE banned = "Yes"
)

SELECT 
    request_at AS Day,
    -- if 문 활용, ROUND로 소수점 둘째자리까지 반환
    ROUND(SUM(IF(status != "completed", 1, 0)) / COUNT(*), 2) AS "Cancellation Rate"
FROM Trips
WHERE 
    request_at BETWEEN "2013-10-01" AND "2013-10-03"
    AND client_id NOT IN (SELECT * FROM banned_users)
    AND driver_id NOT IN (SELECT * FROM banned_users)
GROUP BY request_at;


-- 550. Game Play Analysis IV
-- player별 처음 로그인한 날짜로 임시 쿼리 생성
WITH temp AS (
    SELECT player_id, MIN(event_date) AS first_login_date
    FROM Activity 
    GROUP BY player_id
);

SELECT 
  -- DATEDIFF는 두 날의 차이를 int로 변환하는 함수 -> 1이면 첫 로그인 다음 날이라는 뜻
  -- SUM(DATEDIFF = 1)일 때는 boolean으로 조건 평가를 하기 때문에 if가 없어도 DATEDIFF=1인 값만 SUM
    ROUND(
    SUM(DATEDIFF(a.event_date, t.first_login_date) = 1) / COUNT(DISTINCT a.player_id), 2
  ) AS fraction
FROM Activity a
-- 플레이어 활동에 첫 로그인 날짜를 join
JOIN temp t ON a.player_id = t.player_id;


--570. Managers with at Least 5 Direct Reports

SELECT name
FROM Employee
WHERE id IN (
  SELECT managerId
  FROM Employee
  GROUP BY managerId
  HAVING COUNT(managerId)>4
);


-- 585. Investments in 2016

SELECT
  ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
);

-- 601.Human Traffic of Stadium

WITH GroupFilterCTE AS (
    SELECT *,
          -- ROW_NUMBER() OVER(ORDER BY id): id를 오름차순으로 순번을 매기는 윈도우 함수
          id - ROW_NUMBER() OVER(ORDER BY id) groupID
    FROM Stadium
    WHERE people >= 100
)

SELECT id, visit_date, people
FROM GroupFilterCTE
WHERE groupID IN (
    SELECT groupID
    FROM GroupFilterCTE
    GROUP BY groupID
    HAVING COUNT(*) >=3
)
ORDER BY visit_date ASC
