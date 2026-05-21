-- ============================================================
-- Mitron Bank — Credit Card Campaign Analytics
-- SQL Analysis Queries
-- Author: Rajath Gowda
-- Tools: MySQL | Database: mitron_bank
-- ============================================================


-- ============================================================
-- Q1: DEMOGRAPHIC ANALYSIS
-- ============================================================

-- 1a. Customer distribution by age group
SELECT 
    age_group,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / 4000, 1) AS pct_of_total
FROM mitron_bank.dim_customers
GROUP BY age_group
ORDER BY total_customers DESC;

-- 1b. Customer distribution by city
SELECT 
    city,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / 4000, 1) AS pct_of_total
FROM mitron_bank.dim_customers
GROUP BY city
ORDER BY total_customers DESC;

-- 1c. Customer distribution by occupation
SELECT 
    occupation,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / 4000, 1) AS pct_of_total
FROM mitron_bank.dim_customers
GROUP BY occupation
ORDER BY total_customers DESC;

-- 1d. Customer distribution by gender
SELECT 
    gender,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / 4000, 1) AS pct_of_total
FROM mitron_bank.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;


-- ============================================================
-- Q2: INCOME UTILISATION %
-- Key metric: measures what % of income customers are spending
-- Formula: Total Spend / (Avg Income × 6 months) × 100
-- ============================================================

-- 2a. Income utilisation by occupation
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(spend) AS total_spend
    FROM mitron_bank.fact_spends
    GROUP BY customer_id
)
SELECT 
    C.occupation,
    ROUND(AVG(C.avg_income), 0) AS avg_income,
    ROUND(SUM(CS.total_spend), 0) AS total_spend,
    ROUND(SUM(CS.total_spend) / 
        (AVG(C.avg_income) * 6 * COUNT(C.customer_id)) * 100.0, 1) AS income_utilisation_pct
FROM mitron_bank.dim_customers C
JOIN customer_spend CS ON C.customer_id = CS.customer_id
GROUP BY C.occupation
ORDER BY income_utilisation_pct DESC;

-- 2b. Income utilisation by age group
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(spend) AS total_spend
    FROM mitron_bank.fact_spends
    GROUP BY customer_id
)
SELECT 
    C.age_group,
    ROUND(AVG(C.avg_income), 0) AS avg_income,
    ROUND(SUM(CS.total_spend), 0) AS total_spend,
    ROUND(SUM(CS.total_spend) / 
        (AVG(C.avg_income) * 6 * COUNT(C.customer_id)) * 100.0, 1) AS income_utilisation_pct
FROM mitron_bank.dim_customers C
JOIN customer_spend CS ON C.customer_id = CS.customer_id
GROUP BY C.age_group
ORDER BY income_utilisation_pct DESC;

-- 2c. Income utilisation by city
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(spend) AS total_spend
    FROM mitron_bank.fact_spends
    GROUP BY customer_id
)
SELECT 
    C.city,
    ROUND(AVG(C.avg_income), 0) AS avg_income,
    ROUND(SUM(CS.total_spend), 0) AS total_spend,
    ROUND(SUM(CS.total_spend) / 
        (AVG(C.avg_income) * 6 * COUNT(C.customer_id)) * 100.0, 1) AS income_utilisation_pct
FROM mitron_bank.dim_customers C
JOIN customer_spend CS ON C.customer_id = CS.customer_id
GROUP BY C.city
ORDER BY income_utilisation_pct DESC;


-- ============================================================
-- Q3: SPEND INSIGHTS BY CATEGORY
-- ============================================================

-- 3a. Total spend by category
SELECT 
    category,
    SUM(spend) AS total_spend,
    ROUND(SUM(spend) / 
        (SELECT SUM(spend) FROM mitron_bank.fact_spends) * 100.0, 1) AS pct_of_total
FROM mitron_bank.fact_spends
GROUP BY category
ORDER BY total_spend DESC;

-- 3b. Spend by category and occupation
SELECT 
    C.occupation,
    S.category,
    SUM(S.spend) AS total_spend
FROM mitron_bank.dim_customers C
JOIN mitron_bank.fact_spends S ON C.customer_id = S.customer_id
GROUP BY C.occupation, S.category
ORDER BY C.occupation, total_spend DESC;


-- ============================================================
-- Q4: PAYMENT TYPE ANALYSIS
-- ============================================================

-- 4a. Spend split by payment type
SELECT 
    payment_type,
    SUM(spend) AS total_spend,
    ROUND(SUM(spend) / 
        (SELECT SUM(spend) FROM mitron_bank.fact_spends) * 100.0, 1) AS pct_of_total
FROM mitron_bank.fact_spends
GROUP BY payment_type
ORDER BY total_spend DESC;

-- 4b. Payment type usage by occupation
SELECT 
    C.occupation,
    S.payment_type,
    SUM(S.spend) AS total_spend
FROM mitron_bank.dim_customers C
JOIN mitron_bank.fact_spends S ON C.customer_id = S.customer_id
GROUP BY C.occupation, S.payment_type
ORDER BY C.occupation, total_spend DESC;


-- ============================================================
-- Q5: MONTHLY SPEND TREND
-- ============================================================

SELECT 
    month,
    SUM(spend) AS total_spend
FROM mitron_bank.fact_spends
GROUP BY month
ORDER BY 
    CASE month
        WHEN 'May' THEN 1
        WHEN 'June' THEN 2
        WHEN 'July' THEN 3
        WHEN 'August' THEN 4
        WHEN 'September' THEN 5
        WHEN 'October' THEN 6
    END;
