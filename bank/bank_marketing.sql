CREATE TABLE public.bank_data_raw (
    age integer,
    job varchar(50),
    marital varchar(20),
    education varchar(30),
    "default" varchar(10),
    balance integer,
    housing varchar(10),
    loan varchar(10),
    contact varchar(20),
    day integer,
    month varchar(10),
    duration integer,
    campaign integer,
    pdays integer,
    previous integer,
    poutcome varchar(20),
    y varchar(10)
);

SELECT *
FROM bank_data_raw
LIMIT 10;

ALTER TABLE bank_marketing
RENAME TO bank_data;


SELECT education, avg(balance) AS avg_balance
FROM bank_data
GROUP BY education
ORDER BY avg_balance DESC;

SELECT job,
	COUNT(*) AS Total,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribed,
    ROUND(SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2) AS subscription_rate
FROM bank_data
GROUP BY job
ORDER BY subscription_rate DESC
LIMIT 5;

SELECT DISTINCT y, LENGTH(y) AS len
FROM bank_data;


