# 🚴: Case Study #1 - AdventureWorks Cycle Revenue Analysis <!-- omit in toc -->

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Adventure_logo.png" alt="AdventureWorks" width="400"/>

## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Data Description](#data-description)
- [Case Study Questions](#case-study-questions)


## Introduction

Adventure Works Cycles is a large and rapidly growing multinational manufacturer and seller of bicycles and accessories to commercial markets. In order to evaluate the company’s performance, their current marketing strategy’s effectiveness and to identify areas for marketing process improvement. The managements is interested in how revenue is generated over the years.

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
	ASC, Country ASC;
```

**The Result Set:**

|Country|Revenue|
|-------|:-------:|
|Australia|$9,061,000.58|
|Canada|$1,977,844.86|
|France|$2,644,017.71|
|Germany|$2,894,312.34|
|United Kingdom|$3,391,712.21|
|United States|$9,389,789.51|
|TOTAL|$29,358,677.22|

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q1.JPG" alt="Internet Sales by Country" width="300"/>

### 2. What is the Total Revenue by Location(Country) for Reseller Only?

**The query:**

```sql
SELECT 
	ISNULL(A.[SalesTerritoryCountry],'TOTAL') AS Country
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[DimSalesTerritory] A 
	LEFT JOIN [dbo].[FactResellerSales] B
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
	ASC, Country ASC;
```

**The Result Set:**
|Country|Revenue|
|-------|:-------:|
|Australia|$1,594,335.38|
|Canada|$14,377,925.60|
|France|$4,607,537.94|
|Germany|$1,983,988.04|
|United Kingdom|$4,279,008.83|
|United States|$53,607,801.21|
|TOTAL|$80,450,596.98|

This is an Analysis of the AdventureWork Database in Microsoft SQL Server DataBase
