-- leetcode
-- 176. Second Highest Salary

-- OFFSET, DISTINCT 개념만 추가적으로 알고 있다면 충분히 풀이 가능

SELECT DISTINCT salary AS SecondHighestSalary
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- 178. Rank scores
-- 임시 table, GROUP BY 개념 추가적으로 필요

SELECT S.score,
  COUNT(S2.SCORE) AS `rank`
FROM SCORES S,
     (SELECT DISTINCT SCORE FROM SCORES)  S2
WHERE S.SCORE <= S2.SCORE 
GROUP BY S.ID 
ORDER BY S.SCORE DESC;
