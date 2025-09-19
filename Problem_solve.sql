-- leetcode
-- 176. Second Highest Salary

-- OFFSET, DISTINCT 개념만 추가적으로 알고 있다면 충분히 풀이 가능

SELECT DISTINCT salary AS SecondHighestSalary
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
