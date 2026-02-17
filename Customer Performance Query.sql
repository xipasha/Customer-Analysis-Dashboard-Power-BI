SELECT
soh.CustomerID,
CONCAT (pp.FirstName,' ',pp.LastName) AS [Customer Name],
cr.Name AS [Country],
soh.OrderDate,
MIN(soh.OrderDate) OVER(PARTITION BY soh.CustomerID) AS [First Order Date],
MAX(soh.OrderDate) OVER(PARTITION BY soh.CustomerID) AS [Last Order Date],
DATEDIFF(DAY, soh.OrderDate, MAX(soh.OrderDate) OVER (PARTITION BY soh.CustomerID)) AS [Days Since Last Order],
sod.OrderQty,
MIN(YEAR(soh.OrderDate)) OVER (PARTITION BY soh.CustomerID) AS [Aquisition Year],
DATEDIFF(MONTH,soh.OrderDate, MAX(soh.OrderDate) OVER (PARTITION BY soh.CustomerID)) AS [Customer Age In Months],
DATEDIFF(DAY, soh.OrderDate, MAX(soh.OrderDate) OVER (PARTITION BY soh.CustomerID)) AS [Customer Age In Days],
MIN(sod.OrderQty) OVER(PARTITION BY soh.CustomerID) AS [Minimum Order],
MAX(sod.OrderQty) OVER(PARTITION BY soh.CustomerID) AS [Maximum Order],
SUM(sod.OrderQty) OVER(PARTITION BY soh.CustomerID) AS [Total Orders],
sod.UnitPrice,
sod.LineTotal,
CASE 
WHEN SUM(sod.OrderQty) OVER(PARTITION BY soh.CustomerID) <= 45 AND sod.LineTotal >= 1000 THEN 'Regular'
WHEN SUM(sod.OrderQty) OVER(PARTITION BY soh.CustomerID) <= 20 AND sod.LineTotal <= 1000 THEN 'Average'
END AS  [Customer Type]
-- soh is salesOrderHeader
FROM sales.SalesOrderHeader AS soh
-- sod is salesOrderDetail
INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
-- st is salesTerritory
INNER JOIN Sales.SalesTerritory AS st ON  st.TerritoryID = soh.TerritoryID
-- cr is countryRegion
INNER JOIN Person.CountryRegion AS cr ON st.CountryRegionCode = cr.CountryRegionCode
-- sp is person
INNER JOIN Sales.SalesPerson AS sp ON sp.TerritoryID = st.TerritoryID
-- pp is person.person
INNER JOIN Person.Person AS pp ON sp.BusinessEntityID = pp.BusinessEntityID
-- sc is sales customer
INNER JOIN Sales.Customer AS sc ON soh.CustomerID = sc.CustomerID