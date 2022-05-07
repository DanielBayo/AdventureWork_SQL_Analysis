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

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q1.PNG" alt="Internet Sales Revenue by Country" width="500"/>

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

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q2.PNG" alt="Reseller Sales Revenue by Country" width="500"/>

### 3. What is the Total Revenue by Location(Country and Continent) for Internet Sales and Reseller Sales?

**The query:**

```sql
SELECT 
	A.[SalesTerritoryCountry] AS Country
	,A.[SalesTerritoryGroup] AS Continent	
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[DimSalesTerritory] A 
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.SalesTerritoryKey=B.SalesTerritoryKey
	LEFT JOIN [dbo].[FactResellerSales] C
		ON B.SalesTerritoryKey=C.SalesTerritoryKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY 
	Revenue DESC;
```

**The Result Set:**
|Country|Continent|Revenue|
|-------|-------|:-------:|
|France|Europe|$9,333,382,531.48|
|Germany|Europe|$5,322,640,389.95|
|Canada|North America|$22,634,456,601.87|
|Australia|Pacific|$15,521,494,001.08|
|United Kingdom|Europe|$11,938,826,982.37|
|United States|North America|$105,362,939,186.95|

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q3.png" alt="Total Revenue by Country" width="500"/>

### 4. What is the Total Revenue by Location(Country and Continent) for Internet Sales and Reseller Sales (in separate columns)?

**The query:**

```sql
SELECT 
	A.[SalesTerritoryCountry] AS Country
	,A.[SalesTerritoryGroup] AS Continent
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS internetRevenue
	,FORMAT(SUM(C.[SalesAmount]),'$#,0.00') AS resellerRevenue
FROM 
	[dbo].[DimSalesTerritory] A 
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.SalesTerritoryKey=B.SalesTerritoryKey
	LEFT JOIN [dbo].[FactResellerSales] C
		ON B.SalesTerritoryKey=C.SalesTerritoryKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY 
	internetRevenue DESC
	,resellerRevenue DESC;
```

**The Result Set:**
|Country|Continent|internetRevenue|resellerRevenue|
|-------|-------|-------|-------|
France|Europe|$9,333,382,531.48|$25,608,695,842.73|
|Germany|Europe|$5,322,640,389.95|$11,159,932,709.81|
|Canada|North America|$22,634,456,601.87|$109,559,793,045.33|
|Australia|Pacific|$15,521,494,001.08|$21,276,405,602.06|
|United Kingdom|Europe|$11,938,826,982.37|$29,550,834,956.50|
|United States|North America|$105,362,939,186.95|$338,971,891,689.64|

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q4.PNG" alt="Revenue by Country with Reseller and Internet sales in separate column" width="500"/>

### 5. What is the Total Revenue by Product Category for Internet Sales and Reseller Sales (in separate columns)?

**The query:**

```sql
SELECT 
	E.EnglishProductCategoryName AS CategoryName
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[DimProduct] A
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.ProductKey=B.ProductKey
	LEFT JOIN [dbo].[FactResellerSales] C
		ON B.ProductKey=C.ProductKey
	LEFT JOIN [dbo].[DimProductSubcategory] D
		ON A.ProductSubcategoryKey=D.ProductSubcategoryKey
	LEFT JOIN [dbo].[DimProductCategory] E
		ON D.ProductCategoryKey=E.ProductCategoryKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	E.EnglishProductCategoryName
ORDER BY 
	Revenue DESC;
```

**The Result Set:**
|CategoryName|Revenue|
|-------|-------|
|Bikes|$5,514,174,492.66|
|Accessories|$128,262,539.07|
|Clothing|$101,053,213.75|

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q5.png" alt="Revenue by Category" width="500"/>

### 6. What are the Top 10 Product by Revenue?

**The query:**

```sql
SELECT TOP 10 
	A.EnglishProductName AS Product
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[DimProduct] A
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.ProductKey=B.ProductKey
	LEFT JOIN [dbo].[FactResellerSales] C
		ON B.ProductKey=C.ProductKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	A.EnglishProductName
ORDER BY 
	Revenue DESC;
```

**The Result Set:**
|Product|Revenue|
|-------|-------|
|Touring-1000 Yellow, 60|$97,794,551.40|
|Touring-3000 Yellow, 62|$9,984,607.50|
|Touring-3000 Yellow, 50|$9,679,501.65|
|Road-650 Black, 44|$9,554,435.43|
|Road Tire Tube|$9,480.24|
|Water Bottle - 30 oz.|$9,402,836.64|
|Road-650 Red, 52|$9,303,822.70|
|Touring-3000 Blue, 54|$9,227,410.50|
|Touring-3000 Blue, 50|$9,193,262.40|
|AWC Logo Cap|$9,056,526.00|

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q6.png" alt="Top 10 Product by revenue" width="500"/>

### 6. What are the Bottom 10 Product by Revenue?

**The query:**

```sql
SELECT TOP 10 
	A.EnglishProductName AS Product
	,FORMAT(SUM(B.[SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[DimProduct] A
	LEFT JOIN [dbo].[FactInternetSales] B
		ON A.ProductKey=B.ProductKey
	LEFT JOIN [dbo].[FactResellerSales] C
		ON B.ProductKey=C.ProductKey
WHERE 
	B.[SalesAmount] Is NOT NULL
GROUP BY 
	A.EnglishProductName
ORDER BY 
	Revenue ASC;
```

**The Result Set:**
|Product|Revenue|
|-------|-------|
|Patch Kit/8 Patches|$1,191,104.57|
|Half-Finger Gloves, L|$1,442,926.31|
|Mountain-400-W Silver, 42|$10,124,949.42|
|Long-Sleeve Logo Jersey, L|$10,190,561.48|
|Mountain-400-W Silver, 46|$10,725,151.62|
|Short-Sleeve Classic Jersey, XL|$10,930,545.45|
|Touring-1000 Blue, 60|$102,333,820.68|
|Touring-1000 Yellow, 46|$109,896,090.72|
|Touring-3000 Yellow, 44|$11,343,850.35|
|Road-650 Black, 60|$11,532,659.65|
