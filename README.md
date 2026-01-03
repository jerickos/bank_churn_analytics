

# 🏦 **Bank Customer Churn Analytics Dashboard**

A complete end‑to‑end analytics project using **SQL**, **Python**, and **Power BI** to analyze customer churn, identify high‑risk segments, and highlight high‑value customers at risk.  
This project demonstrates data cleaning, feature engineering, segmentation, dashboard design, and business insight generation.

---

## 📌 **Project Overview**

This project analyzes a synthetic dataset of 10,000 retail banking customers to understand **why customers churn**, which segments are most at risk, and what actions a bank can take to reduce churn.  
The final deliverable is a **five‑page Power BI dashboard** supported by SQL and Python preprocessing.

---

## 🎯 **Objectives**

- Identify key drivers of customer churn  
- Segment customers by demographics, tenure, credit score, and product usage  
- Analyze product behavior and high‑risk product combinations  
- Highlight high‑value customers who churned  
- Provide actionable recommendations for reducing churn  

---

## 🛠️ **Tools & Skills Demonstrated**

### **SQL**
- Data cleaning and preprocessing  
- Feature engineering (age groups, credit score groups, tenure groups)  
- Aggregation and segmentation queries  
- Product combination analysis  

### **Python (Pandas)**
- Data wrangling and cleaning  
- Mapping dictionaries for categorical IDs  
- Exploratory analysis  
- Exporting clean datasets for Power BI  

### **Power BI**
- Multi‑page dashboard design  
- DAX calculations (CLV proxy, risk segments, product combos)  
- Heatmaps, matrix visuals, segmentation charts  
- Slicers, navigation, formatting, storytelling  

### **Business Analytics**
- Churn modeling logic  
- Customer segmentation  
- Product behavior analysis  
- Value & risk assessment  
- Executive‑level insight communication  

---

## 📊 **Dashboard Structure**

### **🟦 Page 1 — Executive Summary**
- Churn rate  
- Total churned  
- Average balance (churned vs stayed)  
- Churn by age group  
- Key KPIs and slicers  


---

### **🟩 Page 2 — Customer Segmentation**
- Churn by credit score group  
- Churn by number of products  
- Churn by tenure group  
- Geography × gender interaction  



---

### **🟧 Page 3 — Product Behavior**
- Churn by number of products  
- Average balance by product count  
- High‑risk product combinations  
- Geography × product count  



---

### **🟨 Page 4 — Customer Value & Risk**
- Top 10 high‑value churners  
- Credit score × balance churn heatmap  
- CLV proxy analysis  
- Risk segments (High Value × High Risk)  


---

### **🟫 Page 5 — Final Insight Summary**
- Key churn drivers  
- High‑value customer risk  
- Product behavior insights  
- Geographic/demographic patterns  
- Recommended actions  


---

## 📈 **Key Insights**

- Customers with **low credit scores**, **short tenure**, and **3–4 products** churn the most  
- Several **high‑value customers** (balances > \$100k) still churned  
- Certain product combinations (e.g., “Card | 3 Products”) are high‑risk  
- Churn patterns vary by **region and gender**  
- Early‑stage customers (0–2 years) are the most vulnerable  

---

## 📝 **Recommendations**

- Strengthen onboarding for new customers  
- Reevaluate product bundles for customers with 3–4 products  
- Prioritize high‑value churners for retention outreach  
- Target regions with elevated churn  
- Monitor high‑risk product combinations  

---

## 📁 **Repository Structure**

```
📁 bank_churn_analytics/
│
├── README.md
│
├── 📁 data/
│     ├── customer_shopping_behavior.csv
│     
│
├── 📁 python/
│     ├── bankCustomer.ipynb
│    
│   
│
├── 📁 sql/
│     ├── customer_shopping_behavior.sql
│   
│     
│
├── 📁 powerbi/
│     └── churn_BI.pbix
│
└── 📁 images/
      ├── page1_overview.png
      ├── page2_segmentation.png
      ├── page3_product_behavior.png
      ├── page4_value_risk.png
      └── page5_summary.png
```

