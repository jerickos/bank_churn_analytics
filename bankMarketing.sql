CREATE DATABASE bankMarketing
CREATE TABLE bank_data (
    age INT,
    job VARCHAR(50),
    marital VARCHAR(20),
    education VARCHAR(30),
    `default` VARCHAR(10),
    balance INT,
    housing VARCHAR(10),
    loan VARCHAR(10),
    contact VARCHAR(20),
    day INT,
    month VARCHAR(10),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(20),
    y VARCHAR(10)
);
SELECT * 
FROM bank_data
LIMIT 10;

SELECT education, avg(balance) AS avg_balance
FROM bank_data
GROUP BY education
ORDER BY avg_balance DESC;
