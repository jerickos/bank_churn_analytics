
SELECT *
FROM churn
LIMIT 5;

SELECT COUNT(*) as total_customers
FROM churn;

ALTER TABLE churn
RENAME COLUMN "Geography" TO geography;

ALTER TABLE churn
RENAME COLUMN "CustomerId" TO customerID

ALTER TABLE churn
RENAME "CreditScore" TO creditScore;

ALTER TABLE churn
RENAME "Gender" TO gender;

ALTER TABLE churn
RENAME "Age" TO age;

ALTER TABLE churn
RENAME "Tenure" to tenure;

ALTER TABLE churn
RENAME "Balance" to balance;

ALTER TABLE churn
RENAME "NumOfProducts" to numProducts;

ALTER TABLE churn
RENAME "HasCrCard" to hasCrCard;

ALTER TABLE churn
RENAME "IsActiveMember" to activeMember;

ALTER TABLE churn
RENAME "EstimatedSalary" to estimatedSalary;

ALTER TABLE churn
RENAME "Exited" to exited;

ALTER TABLE churn
RENAME "AgeGroup" to ageGroup;

ALTER Table churn
RENAME "CreditScoreGroup" to creditScoreGroup;

ALTER TABLE churn
RENAME "HasBalance" to hasBalance;




SELECT "Balance"
FROM churn
ORDER BY "Balance" DESC
LIMIT 10;


--Show the first 20 rows
SELECT * 
FROM churn
LIMIT 20;

--show unique values for geography
SELECT DISTINCT geography
FROM churn;

--find min and max age
SELECT MIN(age) AS "Youngest customer", MAX(age) AS "Oldest customer"
FROM churn;

--ChurnKPI questions
--what is the ovarall churn rate?
SELECT TO_CHAR((SUM(CASE WHEN exited = 1 THEN 1 ElSE 0 END)::decimal /
	COUNT(*) *100), 'FM990.00%')  AS churnRate
FROM churn;

--How many customers churn vs stayed
WITH customerChurn AS (
    SELECT activemember, exited
    FROM churn
    WHERE activemember = 1
)
SELECT 
    COUNT(*) FILTER (WHERE exited = 0) AS "Number Customer Stay",
    COUNT(*) FILTER (WHERE exited = 1) AS "Number of Churns"
FROM customerChurn


--what is the churn rate per gender

WITH customerChurn AS (
    SELECT activemember, exited, gender
    FROM churn
    WHERE activemember = 1
)

SELECT TO_CHAR(
			(SUM(CASE WHEN gender = 'female' AND exited =1 THEN 1 ELSE 0 END)::decimal 
			/ NULLIF(SUM(CASE WHEN gender = 'female' THEN 1 ELSE 0 END), 0)) *100, '999.00%'
			)AS femaleChurnRate,
	   TO_CHAR(
	   (SUM(CASE WHEN gender = 'male' AND exited =1 THEN 1 ELSE 0 END)::decimal 
	   / NULLIF(SUM(CASE WHEN gender = 'male' THEN 1 ELSE 0 END), 0)) *100, '999.00%'
	   ) AS maleChurnRate
FROM customerChurn;

--What is the churn rate by geography?

SELECT geography,
	TO_CHAR(
		(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal /COUNT(*)) *100, '999.00%'
		) AS churn_rate
FROM churn
GROUP BY geography
ORDER BY churn_rate DESC;










--sections customer segmentations
--Which age group has the highest churn rate?
SELECT ageGroup,
	   TO_CHAR(
		(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal /NULLIF(COUNT(*),0)) *100, '99.00%'
		) AS churn_rate
FROM churn
GROUP BY ageGroup
ORDER BY churn_rate DESC
LIMIT 1;

--Which geography has the highest average credit score?
SELECT geography, ROUND(AVG(creditScore)) AS "Average Credit Score"
FROM churn
GROUP BY geography;


--Which gender has the higher average balance?
SELECT gender, ROUND(AVG(balance)::numeric, 2) AS avgBalance
FROM churn
GROUP BY gender
ORDER BY avgBalance DESC;


--What is the churn rate for customers with 1, 2, 3, and 4 products?
SELECT numProducts, TO_CHAR(
	(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal/ NULLIF(COUNT(*), 0)) * 100, '999.00%'
	) AS churn_rate
FROM churn
GROUP BY numProducts
ORDER BY churn_rate DESC;



--to verify customers with 4 products have a 100 percent churn rate
SELECT 
    numproducts,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers
FROM churn
GROUP BY numproducts
ORDER BY numproducts;




--behavior and product insight
--- What is the average balance of churned customers vs non‑churned customers?
SELECT CASE
			WHEN exited = 1 THEN 'Churned'
			ELSE 'Non-Churned'
			END AS customer_status, 
	   ROUND(AVG(balance)::numeric, 2) AS avg_balance
FROM churn
GROUP BY exited
ORDER BY avg_balance DESC;


-- Do customers with a credit card churn more or less than those without one?
SELECT CASE
			WHEN hasCrCard = 1 THEN 'CCHolder'
			ELSE 'nonCCHolder'
			END AS ccHolderStatus,
		TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal/ NULLIF(COUNT(*), 0)) * 100, '999.00%'
			) AS churn_rate
FROM churn
GROUP BY ccHolderStatus
ORDER BY churn_rate DESC;


-- What is the churn rate for customers who have a balance vs those with zero balance?
SELECT CASE
			WHEN balance = 0 THEN 'zero balance'
			ELSE 'non-zero balance'
			END AS churnCustomer,
		TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal/ NULLIF(COUNT(*), 0)) * 100, '999.00%'
			) AS churn_rate
FROM churn
GROUP BY churnCustomer
ORDER BY (SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal/ NULLIF(COUNT(*), 0)) DESC;


-- What is the average estimated salary for churned customers?

SELECT 'Churned Customers' AS customer_status,
		ROUND(AVG(estimatedsalary)::numeric,2) AS avg_Salary
FROM churn
WHERE exited = 1;




-- High‑Value Customer Analysis
-- Among customers with a balance over 100,000, what percentage churned?
SELECT 'Over 100K' AS churnBalance,
	   TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal
			/ NULLIF(COUNT(*), 0)) * 100, 'FM999.00%'
			) AS churn_rate
FROM churn
WHERE balance > 100000;




-- Which geography has the highest number of high‑balance customers?
SELECT geography, COUNT(*) AS high_balance_customers
FROM churn
WHERE balance >= 100000
GROUP BY geography
ORDER BY high_balance_customers DESC;


--What is the average credit score of customers who churned?
SELECT 'Churned Customers' AS customerStatus,
	    ROUND(AVG(creditScore)::numeric) AS avg_creditScore
FROM churn
WHERE exited =1;


-- Which age group has the highest average balance?
SELECT ageGroup, ROUND(AVG(balance)::numeric, 2) AS avg_balance
FROM churn
GROUP BY ageGroup
ORDER BY avg_balance DESC;




--Advanced / Portfolio‑Level
-- For each geography, what is the churn rate broken down by gender?
SELECT geography, 
       gender,
	   TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal
			/ NULLIF(COUNT(*), 0)) * 100, 'FM999.00%'
			) AS churn_rate
FROM churn
GROUP BY geography, gender
ORDER BY geography, gender;


-- For each number of products, what is the average balance and churn rate?
SELECT numProducts,
	   COUNT(*) AS num_customers,
	   ROUND(AVG(balance)::numeric, 2) AS avg_balance,
	   TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal
			/ NULLIF(COUNT(*), 0)) * 100, 'FM999.00%'
			) AS churn_rate
FROM churn
GROUP BY numProducts
ORDER BY numProducts;

--Which combination of geography + number of products has the highest churn?
SELECT 
		geography,
		numProducts,
		TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal
			/ NULLIF(COUNT(*), 0)) * 100, 'FM999.00%'
			) AS churn_rate
FROM churn
GROUP BY geography, numProducts
ORDER BY geography, numProducts ASC;



-- Which customers (top 10) have the highest balance among those who churned?
SELECT customerID,
	   balance
FROM churn
WHERE exited =1
ORDER BY balance DESC
LIMIT 10;



-- What is the correlation‑style summary: average age, balance, credit score, and salary for churned vs non‑churned customers?
SELECT 
    CASE WHEN exited = 1 THEN 'Churned' ELSE 'Stayed' END AS customer_status,
    ROUND(AVG(age)::numeric, 2) AS avg_age,
    ROUND(AVG(balance)::numeric, 2) AS avg_balance,
    ROUND(AVG(creditScore)::numeric, 2) AS avg_credit_score,
    ROUND(AVG(estimatedSalary)::numeric, 2) AS avg_salary
FROM churn
GROUP BY exited;




--Risk segmentation
--churn rate by credit score band
SELECT creditScoreGroup,
	   TO_CHAR(
			(SUM(CASE WHEN exited =1 THEN 1 ELSE 0 END)::decimal
			/ NULLIF(COUNT(*), 0)) * 100, '999.00%'
			) AS churn_rate
FROM churn
GROUP BY creditScoreGroup
ORDER BY churn_rate DESC;


--behavior
--which customers have high balances but low product usages
SELECT customerid,
	   balance,
	   numproducts
FROM churn
WHERE balance >= 100000 AND numproducts <= 1;


--Which customers have low credit scores but high balances?
SELECT customerid,
	   creditScoreGroup,
	   balance
FROM churn
WHERE creditScoreGroup in ('Poor', 'Fair') AND balance >= 100000;

SELECT COUNT(*) AS low_credit_high_balance_customers
FROM churn
WHERE creditScoreGroup IN ('Poor', 'Fair') 
  AND balance >= 100000;


SELECT COUNT(exited)
FROM churn
WHERE exited =1;