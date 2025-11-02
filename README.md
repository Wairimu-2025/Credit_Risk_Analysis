# Credit_Risk_Analysis
SQL analysis from a credit bureau analyst perspective.
Exploring credit history and customer risk patterns.


# Credit Risk Analysis: SQL Portfolio Project

## 📊 Project Overview
Analysis of 32,581 credit accounts to identify default risk patterns and develop data-driven lending recommendations. Built using SQL to demonstrate analytical capabilities relevant to credit bureau operations.

## 🎯 Business Objective
Analyze credit account data to:
- Calculate portfolio-level default rates
- Identify high-risk borrower segments
- Develop risk-based lending recommendations
- Quantify the impact of demographic and financial factors on default probability

## 🛠️ Tools & Technologies
- **Database**: SQLite
- **Query Tool**: DB Browser for SQLite
- **Dataset**: Kaggle Credit Risk Dataset (32,581 records)
- **Skills Demonstrated**: SQL querying, risk analysis, data segmentation, business insights

## 📂 Project Structure
```
├── sql_queries/          # All SQL queries organized by analysis type
├── results/              # Query results and insights
├── data/                 # Dataset (CSV)
└── setup/                # Database setup instructions
```

## 🔍 Key Analyses

### 1. Overall Default Rate
**Finding**: Portfolio shows 21.8% default rate baseline
```sql
-- See: sql_queries/02_default_rate_analysis.sql
```

### 2. Income-Based Risk Segmentation
**Finding**: Borrowers earning <$30K show 35% default rate vs 12% for >$75K earners (3x difference)
```sql
-- See: sql_queries/03_income_segmentation.sql
```

### 3. High-Risk Profile Identification  
**Finding**: 3.66% of portfolio with compounding risk factors (low income + high debt burden + short credit history) exhibits 77.97% default rate
- **1,194 accounts** identified
- **$11,045 average loan** amount
- **4x higher default rate** than portfolio average
```sql
-- See: sql_queries/05_high_risk_identification.sql
```

### 4. Home Ownership Impact
**Finding**: Home ownership is a powerful stability indicator
| Status | Default Rate | Accounts |
|--------|-------------|----------|
| Own | 7.47% | 2,584 |
| Mortgage | 12.57% | 13,444 |
| Rent | 31.57% | 16,446 |

**Insight**: Renters default at 4.2x the rate of homeowners, even when controlling for income
```sql
-- See: sql_queries/06_home_ownership_analysis.sql
```

## 💡 Business Recommendations

### 1. Risk-Based Pricing Strategy
- **Low Risk (Homeowners)**: Standard rates (7-12% default risk)
- **High Risk (Renters + low income)**: Premium rates (+4-6% adjustment)

### 2. Automated Risk Flagging
Implement auto-decline or manual review for applications with all three risk factors:
- Income < $40,000
- Debt-to-income > 30%
- Credit history < 5 years

**Impact**: Could reduce portfolio defaults by ~15%

### 3. Segmented Loan Limits
- High-risk segments: Cap at $5,000-$10,000
- Low-risk segments: Up to $50,000

## 📈 Key Metrics
- **Total Accounts Analyzed**: 32,581
- **Overall Default Rate**: 21.8%
- **High-Risk Segment**: 3.66% of portfolio, 78% default rate
- **Risk Differential**: 4.2x between renters and homeowners

## 🚀 How to Replicate This Analysis

### Prerequisites
- SQLite or any SQL database
- DB Browser for SQLite (recommended)

### Setup Instructions
1. Download the dataset from [Kaggle Credit Risk Dataset](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)
2. Import CSV into SQLite (see `setup/database_setup.sql`)
3. Run queries in order from `sql_queries/` folder
```bash
# Clone this repository
git clone https://github.com/Wairimu-2025/Credit_Risk_Analysis.git

# Navigate to project
cd Credit_Risk_Analysis

# Follow setup instructions in setup/database_setup.sql
```

## 📊 Sample Query Results
![Default Rate Analysis](results/screenshots/default_rate_analysis.png)
![Home Ownership Impact](results/screenshots/home_ownership_impact.png)

## 📝 Key Learnings
- SQL proficiency in filtering, aggregation, and segmentation
- Credit risk analysis and financial metrics
- Data-driven business recommendations
- Portfolio-level risk assessment

## 🎓 Skills Demonstrated
- CASE statements
- Aggregate functions and GROUP BY operations
- Risk segmentation and cohort analysis
- Business insight development from data
- Portfolio risk quantification

## 👤 Author
**Your Name**
- LinkedIn: Ann W.
- Email: anniekiarie07@gmail.com
- Portfolio: https://wairimu-2025.github.io/Wairimu-2025/

## 📄 Thank you.
I welcome any collaborations.

---

*This project was completed as part of my data analytics portfolio to demonstrate SQL proficiency and credit risk analysis capabilities relevant to roles at credit bureaus.*
