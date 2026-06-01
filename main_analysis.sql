USE project_churn;


/* 
 * Assessing credit and spend by customer segment
 */

SELECT 
    Education_Level, 
    Income_Category, 
    ROUND(AVG(Credit_Limit), 2) AS Avg_Limit,
    ROUND(AVG(Total_Trans_Amt), 2) AS Avg_Spend
FROM BankChurners
GROUP BY Education_Level, Income_Category
ORDER BY Avg_Spend DESC;


/* 
 * Financial impact of customer churn
 * NOTE: 'attrited' means they have closed their account
 */

SELECT
	Attrition_Flag,
	COUNT(*) AS Total_Customers,
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS Customer_Percentage,
	ROUND(SUM(Total_Trans_Amt), 2) AS Total_Revenue,
	ROUND(AVG(Total_Trans_Amt), 2) AS Avg_Customer_Spend,
	ROUND(AVG(Total_Revolving_Bal), 2) AS Avg_Ending_Balance
FROM BankChurners
GROUP BY Attrition_Flag;


/*
 * Segmentation Analysis:
 * 		Finding churn patterns across income categories.
 * 		Finding the average age and product holdings to identify risk profiles.
 */

SELECT
	Income_Category,
	COUNT(*) AS Total_Customers,
	ROUND(AVG(Customer_Age), 0) AS Avg_Age,
	ROUND(AVG(Total_Relationship_Count), 0) AS Avg_Products_Held,
	SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churned_Customer_Count
FROM BankChurners
GROUP BY Income_Category
ORDER BY Churned_Customer_Count DESC;


/* 
 * View created for Tableau dashboard to standardise the data for visualisation.
 * Added utilisation tiers for easier analysis
 */

CREATE OR REPLACE VIEW v_Customer_Risk_Profile AS
SELECT
	CLIENTNUM,
	Attrition_Flag,
	Customer_Age,
	Gender,
	Income_Category,
	Card_Category,
	Credit_Limit,
	Total_Trans_Amt,
	CASE
		WHEN Avg_Utilization_Ratio < 0.2 THEN 'Low'
		WHEN Avg_Utilization_Ratio BETWEEN 0.2 AND 0.5 THEN 'Medium'
		ELSE 'High'
	END AS Utilization_Tier
FROM
	BankChurners;
	
	
