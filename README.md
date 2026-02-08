# SQL JOINs & Window Functions Project
Student Name: Rumanyika Arthur  
Student ID:28944
Course: Database Development with PL/SQL (INSY 8311)  
**Instructor:** Eric Maniraguha  
Group:C
## Problem Definition

Business Context:
Rwanda Electronics is a retail company selling electronic devices across multiple regions. The company’s departments include Sales, Marketing, and Inventory.

Data Challenge:  
The company wants to analyze customer purchase data to identify top-selling products, detect low-performing products, and segment customers based on their buying behavior.

Expected Outcome:  
Management wants actionable insights to improve marketing campaigns, optimize inventory, and target high-value customers with personalized offers.
## Step 2: Success Criteria

The following measurable goals will guide the SQL window function analysis:

1. Top 5 products per region 
   - Use `RANK()` to identify the highest-selling products in each region.

2. Running monthly sales totals
   - Use `SUM() OVER(PARTITION BY month ORDER BY sale_date)` to calculate cumulative sales.

3. Month-over-month sales growth  
   - Use `LAG()` and `LEAD()` to compare sales between consecutive months.

4. Customer quartile segmentation 
   - Use `NTILE(4)` to divide customers into four groups based on total purchases.

5. Three-month moving average of sales
   - Use `AVG() OVER(ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)` to analyze sales trends over time.


