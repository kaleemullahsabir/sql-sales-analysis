-- 1. Top-Selling Products
SELECT 
    t.Name AS ProductName,
    SUM(il.Quantity) AS TotalSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY TotalSold DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;  -- top 10


-- 2. Revenue per Region
SELECT 
    c.Country,
    SUM(i.Total) AS TotalRevenue
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY TotalRevenue DESC;


-- 3. Monthly Performance
SELECT 
    YEAR(i.InvoiceDate) AS Year,
    MONTH(i.InvoiceDate) AS Month,
    SUM(i.Total) AS MonthlyRevenue
FROM Invoice i
GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
ORDER BY Year, Month;


-- 4. Product Ranking with RANK()
SELECT 
    c.Country,
    t.Name AS Product,
    SUM(il.Quantity) AS TotalSold,
    RANK() OVER (PARTITION BY c.Country ORDER BY SUM(il.Quantity) DESC) AS RankInCountry
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY c.Country, t.Name
ORDER BY c.Country, RankInCountry;