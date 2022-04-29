# 🚴: Case Study #1 - AdventureWorks Cycle Revenue Analysis <!-- omit in toc -->

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Adventure_logo.png" alt="AdventureWorks" width="400"/>

## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Data Description](#data-description)
- [Case Study Questions](#case-study-questions)


## Case Study Questions

### 1. What is the Total Revenue by Location(Country) for Internet Sales Only?

**The query:**

```sql
SELECT 
	ISNULL(A.[SalesTerritoryCountry],'TOTAL') AS Country
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[DimSalesTerritory] A 
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.SalesTerritoryKey=B.SalesTerritoryKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	A.[SalesTerritoryCountry] WITH ROLLUP
ORDER BY          /* Order by the country and have the group total at the bottom*/
	CASE 
		WHEN SalesTerritoryCountry IS NULL THEN 1
		ELSE 0
	END
	ASC, country ASC;
```
|Country|Revenue|
|-------|:-------:|
|Australia|$9,061,000.58|
|Canada|$1,977,844.86|
|France|$2,644,017.71|
|Germany|$2,894,312.34|
|United Kingdom|$3,391,712.21|
|United States|$9,389,789.51|
|TOTAL|$29,358,677.22|

This is an Analysis of the AdventureWork Database in Microsoft SQL Server DataBase
