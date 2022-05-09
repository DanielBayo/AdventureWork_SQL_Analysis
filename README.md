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
	,SUM(B.[SalesAmount]) AS Revenue
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
|Mountain-200 Black, 38|	$428,863,632.9916|
|Mountain-200 Black, 42|	$361,345,273.0446|
|Mountain-200 Silver, 38|	$314,967,971.7216|
|Mountain-200 Black, 46|	$298,453,039.435|
|Mountain-200 Silver, 46|	$286,538,979.9384|
|Mountain-200 Silver, 42|	$283,256,857.0944|
|Road-150 Red, 56|	$190,006,137.00|
|Road-150 Red, 62|	$161,108,028.48|
|Road-250 Black, 48|	$142,851,679.425|
|Road-350-W Yellow, 40|	$136,831,037.58|

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q6.png" alt="Top 10 Product by revenue" width="500"/>

### 6. What are the Bottom 10 Product by Revenue?

**The query:**

```sql
SELECT TOP 10 
	A.EnglishProductName AS Product
	,SUM(B.[SalesAmount]) AS Revenue
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
|Touring Tire Tube	|$7,425.12|
|Road Tire Tube	|$9,480.24|
|Road Bottle Cage	|$15,390.88|
|Mountain Tire Tube	|$15,444.05|
|Mountain Bottle Cage	|$20,229.75|
|Long-Sleeve Logo Jersey, S	|$21,445.71|
|LL Mountain Tire	|$21,541.38|
|Short-Sleeve Classic Jersey, M|$21,973.93|
|LL Road Tire	|$22,435.56|
|ML Road Tire	|$23,140.74|

### 7. What is Revenue by Sales Representative?

**The query:**

```sql
SELECT
	CONCAT(A.FirstName,' ',A.LastName) AS FullName
	,A.EmailAddress
	,C.SalesTerritoryCountry
	,SUM(B.SalesAmount) AS Revenue
FROM 
	[dbo].[DimEmployee] A
	LEFT JOIN [dbo].[FactResellerSales] B
		ON A.EmployeeKey=B.EmployeeKey
	LEFT JOIN [dbo].[DimSalesTerritory] C
		ON B.SalesTerritoryKey=C.SalesTerritoryKey
WHERE 
	Title LIKE 'Sales Representative'
GROUP BY 
	CONCAT(A.FirstName,' ',A.LastName)
	,A.EmailAddress
	,C.SalesTerritoryCountry
ORDER BY 
	Revenue DESC
	,FullName
```

**The Result Set:**
|FullName|EmailAddress|Country|Revenue|
|-------|-------|-------|-------|
|Linda Mitchell|	linda3@adventure-works.com|	United States|	$10,367,007.4286|
|Jillian Carson|	jillian0@adventure-works.com|	United States|	$10,065,803.5429|
|Michael Blythe|	michael9@adventure-works.com|	United States|	$9,293,903.0055|
|Jae Pak|	jae0@adventure-works.com|	Canada|	$8,503,338.6472|
|Tsvi Reiter|	tsvi0@adventure-works.com|	United States|	$7,171,012.7514|
|Shu Ito	|shu0@adventure-works.com|	United States|	$6,427,005.5556|
|Ranjit Varkey Chudukatil|	ranjit0@adventure-works.com	France|	$4,509,888.933|
|José Saraiva|	josé1@adventure-works.com|	United Kingdom|	$3,837,927.1902|
|David Campbell|	david8@adventure-works.com|	United States|	$3,729,945.3501|
|Garrett Vargas|	garrett1@adventure-works.com|	Canada|	$3,609,447.2163|
|Pamela Ansman-Wolfe|	pamela0@adventure-works.com|	United States|	$3,325,102.5952|
|Tete Mensa-Annan|	tete0@adventure-works.com|	United States|	$2,312,545.6905|
|José Saraiva|	josé1@adventure-works.com|	Canada|	$2,088,491.1672
|Rachel Valdez|	rachel0@adventure-works.com|	Germany|	$1,790,640.2311|
|Lynn Tsoflias|	lynn0@adventure-works.com|	Australia|	$1,421,810.9252|