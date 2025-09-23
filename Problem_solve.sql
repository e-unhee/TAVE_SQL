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
