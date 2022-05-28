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

### 7. What are the Bottom 10 Product by Revenue?

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

**The Visual:**

<img src="https://github.com/DanielBayo/AdventureWork_SQL_Analysis/blob/main/Q7.png" alt="Bottom 10 Product by revenue" width="500"/>

### 8. What is Revenue by Sales Representative?

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
|Ranjit Varkey Chudukatil|	ranjit0@adventure-works.com|	France|	$4,509,888.933|
|José Saraiva|	josé1@adventure-works.com|	United Kingdom|	$3,837,927.1902|
|David Campbell|	david8@adventure-works.com|	United States|	$3,729,945.3501|
|Garrett Vargas|	garrett1@adventure-works.com|	Canada|	$3,609,447.2163|
|Pamela Ansman-Wolfe|	pamela0@adventure-works.com|	United States|	$3,325,102.5952|
|Tete Mensa-Annan|	tete0@adventure-works.com|	United States|	$2,312,545.6905|
|José Saraiva|	josé1@adventure-works.com|	Canada|	$2,088,491.1672|
|Rachel Valdez|	rachel0@adventure-works.com|	Germany|	$1,790,640.2311|
|Lynn Tsoflias|	lynn0@adventure-works.com|	Australia|	$1,421,810.9252|


### 9. What is the Internet Sales Revenue by Year_Month?

**The query:**

```sql
SELECT 
	[MonthNumberOfYear] AS MonthNo
    ,[CalendarYear] AS Year_
	,[EnglishMonthName] AS Month_
    ,FORMAT(SUM([SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[FactInternetSales] A
	LEFT JOIN [dbo].[DimDate] B
		ON A.OrderDateKey=B.DateKey
GROUP BY 
	[MonthNumberOfYear]
	,[CalendarYear]
	,[EnglishMonthName]
ORDER BY
	[CalendarYear] DESC
	,[MonthNumberOfYear] DESC;
```

**The Result Set:**
|MonthNo|Year|MonthName|Revenue|
|-------|-------|-------|-------|
|1|	2014	|January	|$45,694.72|
|12	|2013	|December	|$1,874,360.29|
|11	|2013	|November	|$1,780,920.06|
|10	|2013	|October	|$1,673,293.41|
|9	|2013	|September	|$1,447,495.69|
|8	|2013	|August	|$1,551,065.56|
|7	|2013	|July	|$1,371,675.81|
|6	|2013	|June	|$1,643,177.78|
|5	|2013	|May	|$1,284,592.93|
|4	|2013	|April	|$1,046,022.77|
|3	|2013	|March	|$1,049,907.39|
|2	|2013	|February	|$771,348.74|
|1	|2013	|January	|$857,689.91|
|12	|2012	|December	|$624,502.17|
|11	|2012	|November	|$537,955.52|
|10	|2012	|October	|$535,159.48|
|9	|2012	|September	|$486,177.45|
|8	|2012	|August	|$523,917.38|
|7	|2012	|July	|$444,558.23|
|6	|2012	|June	|$555,160.14|
|5	|2012	|May	|$358,877.89|
|4	|2012	|April	|$400,335.61|
|3	|2012	|March	|$373,483.01|
|2	|2012	|February	|$506,994.19|
|1	|2012	|January	|$495,364.13|
|12	|2011	|December	|$669,431.50|
|11	|2011	|November	|$660,545.81|
|10	|2011	|October	|$708,208.00|
|9	|2011	|September	|$603,083.50|
|8	|2011	|August	|$614,557.94|
|7	|2011	|July	|$596,746.56|
|6	|2011	|June	|$737,839.82|
|5	|2011	|May	|$561,681.48|
|4	|2011	|April	|$502,073.85|
|3	|2011	|March	|$485,198.66|
|2	|2011	|February	|$466,334.90|
|1	|2011	|January	|$469,823.91|
|12	|2010	|December	|$43,421.04|

### 10. What is the Reseller Sales Revenue by Year_Month?

**The query:**

```sql
SELECT 
	[MonthNumberOfYear] AS MonthNo
    ,[CalendarYear] AS Year_
	,[EnglishMonthName] AS Month_
    ,FORMAT(SUM([SalesAmount]),'$#,0.00') AS Revenue
FROM 
	[dbo].[FactResellerSales] A
	LEFT JOIN [dbo].[DimDate] B
		ON A.OrderDateKey=B.DateKey
GROUP BY 
	[MonthNumberOfYear]
	,[CalendarYear]
	,[EnglishMonthName]
ORDER BY
	[CalendarYear] DESC
	,[MonthNumberOfYear] DESC;
```

**The Result Set:**
|MonthNo|Year|MonthName|Revenue|
|-------|-------|-------|-------|
|11|	2013	|November	|$3,416,234.85|
|10	|2013	|October	|$3,314,600.78|
|9	|2013	|September	|$2,206,725.22|
|8	|2013	|August		|$2,738,653.62|
|7	|2013	|July		|$2,699,300.79|
|6	|2013	|June		|$1,662,547.32|
|5	|2013	|May		|$3,510,948.73|
|4	|2013	|April		|$3,483,161.40|
|3	|2013	|March		|$2,282,115.88|
|2	|2013	|Febraury	|$4,047,574.04|
|1	|2013	|January	|$4,212,971.51|
|12	|2012	|December	|$2,665,650.54|
|11	|2012	|November	|$1,987,872.71|
|10	|2012	|October	|$2,880,752.68|
|9	|2012	|September	|$1,865,278.43|
|8	|2012	|August		|$1,563,955.08|
|7	|2012	|July		|$2,384,846.59|
|6	|2012	|June		|$1,317,541.83|
|5	|2012	|May		|$2,185,213.21|
|4	|2012	|April		|$3,053,816.33|
|3	|2012	|March		|$1,802,154.21|
|2	|2012	|February	|$2,885,359.20|
|1	|2012	|January	|$3,601,190.71|
|12	|2011	|December	|$1,001,803.77|
|11	|2011	|November	|$2,269,116.71|
|10	|2011	|October	|$882,899.94|
|9	|2011	|September	|$3,356,069.34|
|8	|2011	|August		|$713,116.69|
|7	|2011	|July		|$4,027,080.34|
|5	|2011	|May		|$2,010,618.07|
|4	|2011	|April		|$1,538,408.31|
|3	|2011	|March		|$489,328.58|

### 11. What is the Month over Month Growth for Internet sales since the beginning of the Business?

**The query:**

```sql
SELECT [CalendarYear] AS [Year] 
       ,[MonthNumberOfYear] AS [Month] 
       ,FORMAT(SUM([SalesAmount]), '$#,0.00') AS Revenue 
       ,CONCAT(
		   100*(SUM([SalesAmount])-LAG(SUM([SalesAmount]), 1, 0) OVER(ORDER BY [CalendarYear],[MonthNumberOfYear] ASC))/LAG(SUM([SalesAmount]), 1) OVER(ORDER BY [CalendarYear],[MonthNumberOfYear] ASC)
		   ,'%'
		) AS [MoM Growth]
FROM [dbo].[FactInternetSales] A
LEFT JOIN [dbo].[DimDate] B ON A.OrderDateKey=B.DateKey
GROUP BY [CalendarYear] ,
         [MonthNumberOfYear]
ORDER BY [Year] DESC,
         [Month] DESC;
```

**The Result Set:**
|Year|Month|Revenue|MoM Growth|
|-------|-------|-------|-------|
|2014	|1|	$45,694.72|	-97.56%|
|2013	|12|$1,874,360.29 |5.25%|
|2013	|11	|$1,780,920.06|	6.43%|
|2013	|10	|$1,673,293.41|	15.60%|
|2013|	9	|$1,447,495.69|	-6.68%|
|2013	|8	|$1,551,065.56	|13.08%|
|2013	|7|	$1,371,675.81|	-16.52%|
|2013	|6|	$1,643,177.78|	27.91%|
|2013	|5|	$1,284,592.93|	22.81%|
|2013	|4|	$1,046,022.77|	-0.37%|
|2013	|3	|$1,049,907.39|	36.11%|
|2013|	2	|$771,348.74|	-10.07%|
|2013|	1	|$857,689.91|	37.34%|
|2012|	12	|$624,502.17|	16.09%|
|2012|	11	|$537,955.52|	0.52%|
|2012|	10	|$535,159.48|	10.07%|
|2012|	9	|$486,177.45|	-7.20%|
|2012|	8	|$523,917.38|	17.85%|
|2012|	7	|$444,558.23|	-19.92%|
|2012|	6	|$555,160.14|	54.69%|
|2012|	5	|$358,877.89|	-10.36%|
|2012|	4	|$400,335.61|	7.19%|
|2012|	3	|$373,483.01|	-26.33%|
|2012|	2	|$506,994.19|	2.35%|
|2012|	1	|$495,364.13|	-26.00%|
|2011|	12	|$669,431.50|	1.35%|
|2011|	11	|$660,545.81|	-6.73%|
|2011|	10	|$708,208.00|	17.43%|
|2011|	9	|$603,083.50|	-1.87%|
|2011|	8	|$614,557.94|	2.98%|
|2011|	7	|$596,746.56|	-19.12%|
|2011|	6	|$737,839.82|	31.36%|
|2011|	5	|$561,681.48|	11.87%|
|2011|	4	|$502,073.85|	3.48%|
|2011|	3	|$485,198.66|	4.05%|
|2011|	2	|$466,334.90|	-0.74%|
|2011|	1	|$469,823.91|	982.02%|
|2010|	12	|$43,421.04	|          |

### 12. What is the Month over Month Growth for Reseller sales since the beginning of the Business?

**The query:**

```sql
SELECT [CalendarYear] AS [Year] 
       ,[MonthNumberOfYear] AS [Month] 
       ,FORMAT(SUM([SalesAmount]), '$#,0.00') AS Revenue 
       ,CONCAT(
		   100*(SUM([SalesAmount])-LAG(SUM([SalesAmount]), 1, 0) OVER(ORDER BY [CalendarYear],[MonthNumberOfYear] ASC))/LAG(SUM([SalesAmount]), 1) OVER(ORDER BY [CalendarYear],[MonthNumberOfYear] ASC)
		   ,'%'
		) AS [MoM Growth]
FROM [dbo].[FactResellerSales] A
LEFT JOIN [dbo].[DimDate] B ON A.OrderDateKey=B.DateKey
GROUP BY [CalendarYear] ,
         [MonthNumberOfYear]
ORDER BY [Year] DESC,
         [Month] DESC;
```

**The Result Set:**
| Year | Month | ResellerRevenue | MoM Growth |
|------|-------|-----------------|------------|
| 2013 | 11    | $3,416,234.85   | 3.07%      |
| 2013 | 10    | $3,314,600.78   | 50.20%     |
| 2013 | 9     | $2,206,725.22   | -19.42%    |
| 2013 | 8     | $2,738,653.62   | 1.46%      |
| 2013 | 7     | $2,699,300.79   | 62.36%     |
| 2013 | 6     | $1,662,547.32   | -52.65%    |
| 2013 | 5     | $3,510,948.73   | 0.80%      |
| 2013 | 4     | $3,483,161.40   | 52.63%     |
| 2013 | 3     | $2,282,115.88   | -43.62%    |
| 2013 | 2     | $4,047,574.04   | -3.93%     |
| 2013 | 1     | $4,212,971.51   | 58.05%     |
| 2012 | 12    | $2,665,650.54   | 34.10%     |
| 2012 | 11    | $1,987,872.71   | -30.99%    |
| 2012 | 10    | $2,880,752.68   | 54.44%     |
| 2012 | 9     | $1,865,278.43   | 19.27%     |
| 2012 | 8     | $1,563,955.08   | -34.42%    |
| 2012 | 7     | $2,384,846.59   | 81.01%     |
| 2012 | 6     | $1,317,541.83   | -39.71%    |
| 2012 | 5     | $2,185,213.21   | -28.44%    |
| 2012 | 4     | $3,053,816.33   | 69.45%     |
| 2012 | 3     | $1,802,154.21   | -37.54%    |
| 2012 | 2     | $2,885,359.20   | -19.88%    |
| 2012 | 1     | $3,601,190.71   | 50.45%     |
| 2011 | 12    | $2,393,689.53   | 138.94%    |
| 2011 | 11    | $1,001,803.77   | -55.85%    |
| 2011 | 10    | $2,269,116.71   | 157.01%    |
| 2011 | 9     | $882,899.94     | -73.69%    |
| 2011 | 8     | $3,356,069.34   | 370.62%    |
| 2011 | 7     | $713,116.69     | -82.29%    |
| 2011 | 5     | $4,027,080.34   | 100.29%    |
| 2011 | 3     | $2,010,618.07   | 30.69%     |
| 2011 | 1     | $1,538,408.31   | 214.39%    |
| 2010 | 12    | $489,328.58     | %          |


### 13. What is the Monthly Active Customers for Internet Sales ?

**The query:**

```sql
SELECT 
	[MonthNumberOfYear]
    ,[CalendarYear] AS Year
	,[EnglishMonthName] AS Month
    ,COUNT(DISTINCT[CustomerKey]) AS TotalCustomer
FROM 
	[dbo].[FactInternetSales] A
	LEFT JOIN [dbo].[DimDate] B
		ON A.OrderDateKey=B.DateKey
GROUP BY 
	[MonthNumberOfYear]
	,[CalendarYear]
	,[EnglishMonthName]
ORDER BY
	[CalendarYear] DESC
	,[MonthNumberOfYear] DESC;
```

**The Result Set:**
| MonthNumberOfYear | Year | Month     | TotalCustomer |
|-------------------|------|-----------|---------------|
| 1                 | 2014 | January   | 834           |
| 12                | 2013 | December  | 2133          |
| 11                | 2013 | November  | 2036          |
| 10                | 2013 | October   | 2073          |
| 9                 | 2013 | September | 1832          |
| 8                 | 2013 | August    | 1900          |
| 7                 | 2013 | July      | 1796          |
| 6                 | 2013 | June      | 1948          |
| 5                 | 2013 | May       | 1719          |
| 4                 | 2013 | April     | 1564          |
| 3                 | 2013 | March     | 1631          |
| 2                 | 2013 | February  | 1373          |
| 1                 | 2013 | January   | 627           |
| 12                | 2012 | December  | 354           |
| 11                | 2012 | November  | 324           |
| 10                | 2012 | October   | 313           |
| 9                 | 2012 | September | 269           |
| 8                 | 2012 | August    | 294           |
| 7                 | 2012 | July      | 246           |
| 6                 | 2012 | June      | 318           |
| 5                 | 2012 | May       | 207           |
| 4                 | 2012 | April     | 219           |
| 3                 | 2012 | March     | 212           |
| 2                 | 2012 | February  | 260           |
| 1                 | 2012 | January   | 252           |
| 12                | 2011 | December  | 222           |
| 11                | 2011 | November  | 208           |
| 10                | 2011 | October   | 221           |
| 9                 | 2011 | September | 185           |
| 8                 | 2011 | August    | 193           |
| 7                 | 2011 | July      | 188           |
| 6                 | 2011 | June      | 230           |
| 5                 | 2011 | May       | 174           |
| 4                 | 2011 | April     | 157           |
| 3                 | 2011 | March     | 150           |
| 2                 | 2011 | February  | 144           |
| 1                 | 2011 | January   | 144           |
| 12                | 2010 | December  | 14            |

### 14. What is the Monthly Active Reseller for Reseller Sales ?

**The query:**

```sql
SELECT 
	SELECT 
	[MonthNumberOfYear]
    ,[CalendarYear] AS Year
	,[EnglishMonthName] AS Month
    ,COUNT(DISTINCT[ResellerKey]) AS TotalReseller
FROM 
	[dbo].[FactResellerSales] A
	LEFT JOIN [dbo].[DimDate] B
		ON A.OrderDateKey=B.DateKey
GROUP BY 
	[MonthNumberOfYear]
	,[CalendarYear]
	,[EnglishMonthName]
ORDER BY
	[CalendarYear] DESC
	,[MonthNumberOfYear] DESC;
```

**The Result Set:**
| MonthNumberOfYear | Year | Month     | TotalReseller |
|-------------------|------|-----------|---------------|
| 11                | 2013 | November  | 179           |
| 10                | 2013 | October   | 178           |
| 9                 | 2013 | September | 91            |
| 8                 | 2013 | August    | 173           |
| 7                 | 2013 | July      | 174           |
| 6                 | 2013 | June      | 93            |
| 5                 | 2013 | May       | 174           |
| 4                 | 2013 | April     | 177           |
| 3                 | 2013 | March     | 96            |
| 2                 | 2013 | February  | 174           |
| 1                 | 2013 | January   | 183           |
| 12                | 2012 | December  | 93            |
| 11                | 2012 | November  | 102           |
| 10                | 2012 | October   | 134           |
| 9                 | 2012 | September | 74            |
| 8                 | 2012 | August    | 106           |
| 7                 | 2012 | July      | 132           |
| 6                 | 2012 | June      | 65            |
| 5                 | 2012 | May       | 114           |
| 4                 | 2012 | April     | 133           |
| 3                 | 2012 | March     | 73            |
| 2                 | 2012 | February  | 111           |
| 1                 | 2012 | January   | 139           |
| 12                | 2011 | December  | 72            |
| 11                | 2011 | November  | 68            |
| 10                | 2011 | October   | 85            |
| 9                 | 2011 | September | 37            |
| 8                 | 2011 | August    | 143           |
| 7                 | 2011 | July      | 40            |
| 5                 | 2011 | May       | 153           |
| 3                 | 2011 | March     | 100           |
| 1                 | 2011 | January   | 75            |
| 12                | 2010 | December  | 38            |
