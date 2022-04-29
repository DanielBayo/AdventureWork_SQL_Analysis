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

'''sql
SELECT 
	A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]	
	,SUM(B.[SalesAmount]) AS Revenue
FROM 
	[dbo].[DimSalesTerritory] A 
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.SalesTerritoryKey=B.SalesTerritoryKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY 
	Revenue DESC;
'''


This is an Analysis of the AdventureWork Database in Microsoft SQL Server DataBase
