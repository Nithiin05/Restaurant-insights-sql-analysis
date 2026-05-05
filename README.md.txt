# 🍽️ Restaurant & Consumer Data Analysis (SQL)

## 📌 Project Overview
This project analyzes restaurant performance and consumer behavior using a relational database built entirely with SQL.  
The focus is on understanding consumer preferences, restaurant ratings, and service patterns by applying structured database design and analytical SQL queries.

---

## 🎯 Project Objectives
- 📐 Design a normalized relational database using SQL
- 🔗 Maintain data integrity with Primary & Foreign Keys
- 📊 Extract business insights from consumer and restaurant data
- 🧠 Apply advanced SQL concepts for real-world analysis

---

## 🧱 Database Design
The database is designed using **ER modeling** and consists of the following tables:

- 👤 **consumers** – demographic and lifestyle information  
- ❤️ **consumer_preferences** – preferred cuisines of consumers  
- 🏪 **restaurants** – restaurant details including location and services  
- 🍕 **restaurant_cuisines** – cuisines offered by each restaurant  
- ⭐ **ratings** – overall, food, and service ratings given by consumers  

All tables are connected using **primary and foreign key constraints** to ensure referential integrity.

📌 The complete database structure is illustrated in `ER_Diagram.png`.

---

## 📊 Analysis & Insights
Using SQL queries, the following insights were derived:

- ⭐ Identified restaurants with high overall satisfaction ratings  
- 🍽️ Analyzed cuisine popularity and consumer preferences  
- 👥 Segmented consumers based on age, occupation, budget, and lifestyle  
- 🏙️ Compared restaurant performance across different cities  
- 📈 Ranked restaurants and consumers using window functions  
- 🔍 Detected rating behavior patterns using joins and subqueries  

The analysis ranges from basic filtering to advanced SQL operations, including:
- JOINs & Subqueries  
- Common Table Expressions (CTEs)  
- Window Functions (`RANK`, `ROW_NUMBER`, `LEAD`)  
- Views and Stored Procedures  

---

## 🛠️ Tools & Technologies
- 🧮 **SQL (MySQL)**
- 🖥️ **MySQL Workbench**
- 🧩 **ER Diagram for Database Design**

---

## 📁 Project Structure
📂 Restaurant-Consumer-Analysis
├── schema.sql 🧱 Database schema & constraints
├── queries.sql 📊 Analytical SQL queries
├── ER_Diagram.png 🧩 ER diagram
└── README.md 📄 Project documentation

---

## 💡 Key Learnings
- 📌 Structured schema design simplifies complex analysis  
- 📊 SQL alone is powerful enough for meaningful insights  
- 🔍 Advanced queries help compare individual behavior with overall trends  
- 🏗️ Proper database design improves scalability and readability  

---

## 🚀 Conclusion
This project demonstrates end-to-end SQL skills — from database design to advanced data analysis.  
It reflects practical experience in working with relational data and solving analytical problems using SQL without external BI tools.

---

## 🔗 GitHub Repository
👉 https://github.com/Lovelyscoder/restaurant-consumer-analysis

