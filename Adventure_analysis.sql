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

--List Revenue by Product Category
SELECT D.EnglishProductCategoryName AS CategoryName
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimProduct] A
LEFT JOIN [dbo].[FactInternetSales] B
ON A.ProductKey=B.ProductKey
LEFT JOIN [dbo].[DimProductSubcategory] C
ON A.ProductSubcategoryKey=C.ProductSubcategoryKey
LEFT JOIN [dbo].[DimProductCategory] D
ON C.ProductCategoryKey=D.ProductCategoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY D.EnglishProductCategoryName
ORDER BY Revenue DESC