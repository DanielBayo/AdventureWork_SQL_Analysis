--This is an Analysis of the AdventureWorks Sales
USE [AdventureWorksDW2019]
--List the Revenue by Location(Country)
SELECT A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]	
	,SUM(B.[SalesAmount]) AS Revenue
FROM [dbo].[DimSalesTerritory] A LEFT JOIN [dbo].[FactInternetSales] B
ON A.SalesTerritoryKey=B.SalesTerritoryKey
WHERE B.[SalesAmount] Is NOT NULL
GROUP BY A.[SalesTerritoryCountry]
	,A.[SalesTerritoryGroup]
ORDER BY Revenue DESC