-- ================================================================
-- CREDIT RISK ANALYSIS - SQL PORTFOLIO PROJECT
-- ================================================================
-- Author: Ann Wairimu
-- Date: November 2025
-- Database: SQLite
-- Dataset: Kaggle Credit Risk Dataset (32,581 records)
-- Purpose: Analyze credit account data to identify default risk 
--          patterns and develop data-driven lending recommendations
-- ================================================================

-- ================================================================
-- QUERY 1: DATA OVERVIEW
-- Purpose: Understand dataset structure and basic statistics
-- ================================================================

-- View sample records
SELECT * 
FROM credit_risk_dataset 
LIMIT 10;

-- Count total records
SELECT COUNT(*) AS total_accounts
FROM credit_risk_dataset;

-- View table structure
PRAGMA table_info(credit_risk_dataset);

-- Basic statistics
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT person_age) as unique_ages,
    MIN(person_age) as min_age,
    MAX(person_age) as max_age,
    ROUND(AVG(person_income), 2) as avg_income,
    ROUND(AVG(loan_amnt), 2) as avg_loan_amount
FROM credit_risk_dataset;


-- ================================================================
-- QUERY 2: OVERALL DEFAULT RATE ANALYSIS
-- Purpose: Calculate baseline default rate for the entire portfolio
-- Business Context: Establishes benchmark for comparing segments
-- ================================================================

SELECT 
    COUNT(*) as total_accounts,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) as total_defaults,
    SUM(CASE WHEN loan_status = 0 THEN 1 ELSE 0 END) as total_non_defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as default_rate_percent,
    ROUND(SUM(CASE WHEN loan_status = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as non_default_rate_percent
FROM credit_risk_dataset;

-- Expected Insight: Overall portfolio default rate serves as baseline
-- for evaluating risk in specific segments


-- ================================================================
-- QUERY 3: INCOME-BASED RISK SEGMENTATION
-- Purpose: Analyze default rates across different income brackets
-- Business Context: Income is a primary factor in credit decisions
-- ================================================================

SELECT 
    CASE 
        WHEN person_income < 30000 THEN 'Under $30K'
        WHEN person_income < 50000 THEN '$30K-$50K'
        WHEN person_income < 75000 THEN '$50K-$75K'
        WHEN person_income < 100000 THEN '$75K-$100K'
        ELSE 'Over $100K'
    END AS income_bracket,
    COUNT(*) AS total_accounts,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(person_income), 2) AS avg_income,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) as defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM credit_risk_dataset
GROUP BY income_bracket
ORDER BY default_rate_percent DESC;
    

-- Expected Insight: Lower income brackets show significantly higher 
-- default rates (inverse relationship between income and default risk)


-- ================================================================
-- QUERY 4: CREDIT HISTORY LENGTH IMPACT
-- Purpose: Evaluate how credit history length affects default rates
-- Business Context: Credit history is key component of credit scores
-- ================================================================

SELECT 
	CASE
		WHEN cb_person_cred_hist_length < 3 THEN 'New (0-2 years)'
		WHEN cb_person_cred_hist_length < 6 THEN 'Moderate (3-5 years)'
		WHEN cb_person_cred_hist_length <10 THEN 'Established (6-9 years)'
		ELSE 'Experience(10+ years)'
	END AS credit_history,
	COUNT (*) AS total_accounts,
	ROUND (AVG(loan_amnt), 2) AS avg_loan_amount,
	ROUND (SUM (CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM credit_risk_dataset
GROUP BY credit_history
ORDER BY default_rate_percent DESC;

-- Expected Insight: Borrowers with shorter credit histories (0-5 years) show 
-- higher default rates, validating credit history as risk predictor


-- ================================================================
-- QUERY 5: HIGH-RISK PROFILE IDENTIFICATION
-- Purpose: Identify borrowers with multiple compounding risk factors
-- Business Context: Multiple risk factors compound to create high-risk segments
-- Risk Factors: Low income + High debt burden + Short credit history
-- ================================================================

SELECT 
    COUNT(*) as high_risk_accounts,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_risk_dataset), 2) AS pct_of_portfolio,
    ROUND(AVG(loan_amnt), 2) as avg_loan_amount,
    ROUND(AVG(person_income), 2) as avg_income,
    ROUND(AVG(loan_percent_income), 3) as avg_debt_to_income_ratio,
    ROUND(AVG(cb_person_cred_hist_length), 1) as avg_credit_history_years,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) as total_defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM credit_risk_dataset
WHERE person_income < 40000 
  AND loan_percent_income > 0.30
  AND cb_person_cred_hist_length < 5;

-- Expected Insight: Small segment (3-4% of portfolio) with extremely 
-- high default rate (75-80%), demonstrating compound risk effect

-- Business Recommendation: Implement stricter approval criteria or 
-- risk-based pricing for this segment


-- ================================================================
-- QUERY 6: HOME OWNERSHIP IMPACT ANALYSIS
-- Purpose: Analyze default rates by home ownership status
-- Business Context: Home ownership indicates financial stability
-- ================================================================

SELECT 
    person_home_ownership,
    COUNT(*) AS total_accounts,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_risk_dataset), 2) AS pct_of_portfolio,
    ROUND(AVG(person_income), 2) AS avg_income,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(loan_percent_income), 3) AS avg_debt_to_income,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) as defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM credit_risk_dataset
GROUP BY person_home_ownership
ORDER BY default_rate_percent DESC;

-- Expected Insight: Clear hierarchy of risk by ownership status
-- Renters: ~31% default rate (highest risk)
-- Mortgage: ~12% default rate (moderate risk)  
-- Own: ~7% default rate (lowest risk)

-- Business Recommendation: Use home ownership as significant factor
-- in credit scoring; homeowners qualify for better rates


-- ================================================================
-- QUERY 7: LOAN PURPOSE RISK ANALYSIS
-- Purpose: Identify which loan purposes have highest default rates
-- Business Context: Loan intent can indicate risk level
-- ================================================================

SELECT 
    loan_intent,
    COUNT(*) AS total_loans,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_risk_dataset), 2) AS pct_of_portfolio,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(person_income), 2) AS avg_income,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) as defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM credit_risk_dataset
GROUP BY loan_intent
ORDER BY default_rate_percent DESC;

-- Expected Insight: Certain loan purposes (e.g., debt consolidation)
-- show higher default rates than others (e.g., home improvement)


-- ================================================================
-- QUERY 8: LOAN GRADE RISK DISTRIBUTION
-- Purpose: Validate loan grade assignments against actual defaults
-- Business Context: Loan grades should correlate with default risk
-- ================================================================

SELECT 
    loan_grade,
    COUNT(*) AS total_loans,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_risk_dataset), 2) AS pct_of_portfolio,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) as defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM credit_risk_dataset
GROUP BY loan_grade
ORDER BY loan_grade;

-- Expected Insight: Default rates should increase as loan grade 
-- decreases (A = best, G = worst), validating grade assignments


SELECT 
    COUNT(*) as similar_cases,
    ROUND(AVG(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100, 2) as predicted_default_rate,
    CASE 
        WHEN AVG(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) > 0.50 THEN 'DENY'
        WHEN AVG(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) > 0.30 THEN 'APPROVE - High Risk Rate'
        ELSE 'APPROVE - Standard Rate'
    END as lending_decision
FROM credit_risk_dataset
WHERE person_income < 40000 
  AND cb_person_cred_hist_length < 5
  AND loan_percent_income > 0.30;

-- Historical default rate: 77.97%
-- Decision : DENIED




-- ================================================================
-- SUMMARY STATISTICS FOR PORTFOLIO REPORT
-- Purpose: Generate executive summary metrics
-- ================================================================

SELECT 
    'Portfolio Overview' AS metric_category,
    COUNT(*) as total_accounts,
    ROUND(AVG(person_age), 1) as avg_age,
    ROUND(AVG(person_income), 2) as avg_income,
    ROUND(AVG(loan_amnt), 2) as avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) as avg_interest_rate,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as overall_default_rate,
    ROUND(SUM(loan_amnt), 2) as total_portfolio_value
FROM credit_risk_dataset;


-- ================================================================
-- END OF CREDIT RISK ANALYSIS QUERIES
-- ================================================================
-- 
-- KEY FINDINGS SUMMARY:
-- 1. Portfolio default rate: ~22%
-- 2. Income strongly predicts default risk (3x difference high vs low)
-- 3. Home ownership reduces default risk by 4.2x
-- 4. High-risk segment (3.66% of accounts) has 78% default rate
-- 5. Credit history length inversely correlates with default rate
--
-- BUSINESS RECOMMENDATIONS:
-- 1. Implement risk-based pricing by home ownership status
-- 2. Auto-flag/decline applications with 3+ compounding risk factors
-- 3. Set loan amount caps for high-risk segments
-- 4. Require co-signers for renters with income <$40K
-- 5. Weight home ownership heavily in credit scoring models
--
-- ================================================================
