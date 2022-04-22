--This is an Analysis of the AdventureWorks Sales
USE [AdventureWorksDW2019]
--List the Revenue by Location(Country) for Internet Sales Only
SELECT A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]	
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimSalesTerritory] A LEFT JOIN [dbo].[FactInternetSales] B
ON A.SalesTerritoryKey=B.SalesTerritoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY Revenue DESC

--List the Revenue by Location(Country) for Reseller Only
SELECT A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]	
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimSalesTerritory] A LEFT JOIN [dbo].[FactResellerSales] B
ON A.SalesTerritoryKey=B.SalesTerritoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY Revenue DESC

--List the Revenue by Location(Country) for Internet Sales and Reseller Sales
SELECT A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]	
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimSalesTerritory] A 
LEFT JOIN [dbo].[FactInternetSales] B
ON A.SalesTerritoryKey=B.SalesTerritoryKey
LEFT JOIN [dbo].[FactResellerSales] C
ON B.SalesTerritoryKey=C.SalesTerritoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY Revenue DESC

--List the Revenue by Location(Country) for Internet Sales and Reseller Sales on separate columns
SELECT A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]	
	,SUM(B.[SalesAmount]) AS internetRevenue
	,SUM(C.[SalesAmount]) AS resellerRevenue
FROM [dbo].[DimSalesTerritory] A 
LEFT JOIN [dbo].[FactInternetSales] B
ON A.SalesTerritoryKey=B.SalesTerritoryKey
LEFT JOIN [dbo].[FactResellerSales] C
ON B.SalesTerritoryKey=C.SalesTerritoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY internetRevenue,resellerRevenue

--List Revenue by Product Category for both Internet and Reseller Sales
SELECT E.EnglishProductCategoryName AS CategoryName
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimProduct] A
LEFT JOIN [dbo].[FactInternetSales] B
ON A.ProductKey=B.ProductKey
LEFT JOIN [dbo].[FactResellerSales] C
ON B.ProductKey=C.ProductKey
LEFT JOIN [dbo].[DimProductSubcategory] D
ON A.ProductSubcategoryKey=D.ProductSubcategoryKey
LEFT JOIN [dbo].[DimProductCategory] E
ON D.ProductCategoryKey=E.ProductCategoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY E.EnglishProductCategoryName
ORDER BY Revenue DESC

--List Top 10 Product by Revenue for both Internet and Reseller Sales
SELECT TOP 10 A.EnglishProductName AS Product
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimProduct] A
LEFT JOIN [dbo].[FactInternetSales] B
ON A.ProductKey=B.ProductKey
LEFT JOIN [dbo].[FactResellerSales] C
ON B.ProductKey=C.ProductKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.EnglishProductName
ORDER BY Revenue DESC

--List Bottom 10 Product by Revenue for both Internet and Reseller Sales
SELECT TOP 10 A.EnglishProductName AS Product
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimProduct] A
LEFT JOIN [dbo].[FactInternetSales] B
ON A.ProductKey=B.ProductKey
LEFT JOIN [dbo].[FactResellerSales] C
ON B.ProductKey=C.ProductKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.EnglishProductName
ORDER BY Revenue ASC