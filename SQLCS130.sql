--Lab ในชั้นเรียนวันที่ 13 สิงหาคม 2569
-- 1. ต้องการข้อมูล รหัสใบสั่งซื้อ ยอดเงินรวมที่หักส่วนลดแล้ว จากแต่ละใบสั่งซื้อ ทั้งหมด เรียงลำดับตามยอดเงิน จากมากไปน้อย

SELECT OrderID, FORMAT(SUM(Unitprice * Quantity * (1 - Discount)),'N2') AS NetTotal
FROM [Order Details]
GROUP BY OrderID
ORDER BY SUM(Unitprice * Quantity * (1 - Discount)) DESC;

-- 2. ต้องการ ชื่อ ประเทศ ของผู้แทนจำหน่าย (suppliers) และจำนวนผู้แทนจำหนายในแต่ละประเทศ
-- แสดงมาเฉพาะรายการที่ผู้แทนจำหน่ายมีมากกว่า 1 ราย

SELECT Country,COUNT(*) TotalSuppliers
FROM Suppliers
GROUP BY Country
HAVING COUNT(*) > 1

-- 3. รหัสสินค้า จำนวนรวมทั้งหมดที่ขายได้ ราคาสูงสุดที่ขายได้ ราคาต่ำสุดที่ขายได้
-- แสดงเฉพาะสินค้าที่ขายได้รวมมากกว่า 1500 ชิ้น

SELECT ProductID, SUM(Quantity) TotalQuantity
FROM [Order Details]
GROUP BY ProductID
HAVING SUM(Quantity) > 1500
ORDER BY SUM (Quantity) desc

--เพิ่มเติมข้อ 3 ต้องการเฉพาะ จำนวนสินค้าที่ไม่มีรายการส่วนลด

SELECT ProductID, SUM(Quantity) TotalQuantity
FROM [Order Details]
WHERE Discount > 0
GROUP BY ProductID
HAVING SUM(Quantity) > 500
ORDER BY SUM (Quantity) desc

-- การ Query ข้อมูล จากหลาย ตาราง (Join Table)

SELECT * FROM Products
SELECT * FROM Categories

--Inner Join

SELECT *
FROM products Inner join Categories
	ON products.categoryID = Categories.CategoryID

--ตัวอย่าง ต้องการชื่อหมวดหมู่สินค้า รหัสสินค้า ชื่อสินค้า ราคา
--โดยเรียงลำดับตามหมวดหมู่สินค้า และราคาสูงไปต่ำ

SELECT Products.CategoryID, CategoryName, ProductID, ProductName, UnitPrice
FROM products Inner join Categories
	ON products.categoryID = Categories.CategoryID
ORDER BY CategoryID asc ,UnitPrice desc

--แบบย่อ

SELECT p.CategoryID, CategoryName, ProductID, ProductName,UnitPrice
FROM products  p Inner join Categories  c
	ON p.categoryID = c.CategoryID
ORDER BY CategoryID asc ,UnitPrice desc

--ต้องการชื่อผู้รับผิดชอบการสั่งซื้อแต่ละรายการ

SELECT * FROM Orders
SELECT * FROM Employees

--รหัสใบสั่งซื้อ วันที่สั่งซื้อ วันที่รับสินค้า ประเทศปลายทาง ชื่อ-นามสกุลพนักงานผุ้รับผิดชอบ
--แบบไม่ใช้ FORMAT

SELECT o.OrderID, o.OrderDate, o.ShippedDate, o.ShipCountry, 
	   e.FirstName + SPACE(2) + e.LastName SaleMan
FROM Orders o inner join Employees e on o.EmployeeID = e.EmployeeID

--แบบใช้ FORMAT

SELECT 
    o.OrderID, 
    FORMAT(o.OrderDate, 'dd/MM/yyyy') AS OrderDate,        -- เช่น 15/08/2023
    FORMAT(o.ShippedDate, 'dd-MMM-yyyy') AS ShippedDate,   -- เช่น 18-Aug-2023
    o.ShipCountry,
    e.FirstName + SPACE(2)+ e.LastName  SaleMan
FROM Orders o 
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID;

--ตัวอย่าง ต้องการชื่อหมวดหมู่สินค้า รหัสสินค้า ชื่อสินค้า ราคา ประเทศที่มา
--โดยเรียงลำดับตามประเทศที่มา และสินค้ามาจากประเทศ USA,MEXICO,CANADA

SELECT c.CategoryID , c.CategoryName,
       p.ProductID , p.ProductName , p.UnitPrice,
       s.Country
FROM Products p INNER JOIN Categories c ON p.CategoryID = c. CategoryID
                INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.Country IN ('USA', 'Mexico', 'Canada')
ORDER BY Country

--แบบฝึกหัดการ JOIN ตาราง

-- 1. ต้องการ รหัสบริษัทขนส่ง, ชื่อบริษัทขนส่ง, จำนวนใบสั่งซื้อที่เกี่ยวข้อง, ยอดรวมค่าขนส่ง

SELECT 
    s.ShipperID  รหัสบริษัทขนส่ง,
    s.CompanyName  ชื่อบริษัทขนส่ง,
    COUNT(*)  จำนวนใบสั่งซื้อ,
    SUM(o.Freight)  ยอดรวมค่าขนส่ง
FROM Shippers s
INNER JOIN Orders o ON s.ShipperID = o.ShipVia
GROUP BY 
    s.ShipperID, 
    s.CompanyName

-- 2. รหัสใบสั่งซื้อ วันที่สั่งซื้อ ชื่อบริษัทลูกค้า ให้แสดงเฉพาะ ลูกค้าที่อยู่ในประเทศ USA

SELECT 
    o.OrderID  รหัสใบสั่งซื้อ,
     FORMAT(o.OrderDate, 'dd/MM/yyyy')  วันที่สั่งซื้อ,
    c.CompanyName  ชื่อบริษัทลูกค้า,
    c.Country  ประเทศ
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- 3. รหัสพนักงาน ชื่อนามสกุล จำนวนใบสั่งซื้อที่เกี่ยวข้อง

SELECT 
    e.EmployeeID  รหัสพนักงาน,
    e.FirstName + SPACE(2) + e.LastName  ชื่อนามสกุล,
    COUNT(*)  จำนวนใบสั่งซื้อ
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName;

-- 4. รหัสใบสั่งซื้อ วันที่สั่งซื้อ ชื่อพนักงาน ชื่อบริษัทลูกค้า ชื่อบริษัทขนส่ง
--  ยอดรวมในใบสั่งซิ้อ เฉพาะรายการที่ขายในปี 1997 เรียงตามลำดับ ยอดเงินจากมากไปน้อย

SELECT 
    o.OrderID  รหัสใบสั่งซื้อ,
   FORMAT(o.OrderDate, 'dd/MM/yyyy')  วันที่สั่งซื้อ,
    e.FirstName + SPACE(2) + e.LastName  ชื่อพนักงาน,
    c.CompanyName  ชื่อบริษัทลูกค้า,
    s.CompanyName  ชื่อบริษัทขนส่ง,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))  ยอดรวมในใบสั่งซื้อ
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY 
    o.OrderID, 
    o.OrderDate, 
    e.FirstName, 
    e.LastName, 
    c.CompanyName, 
    s.CompanyName
ORDER BY 
    ยอดรวมในใบสั่งซื้อ DESC;




--ต้องการ รหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ เฉพาะสินค้าที่ขายดีที่สุด 5 อันดับแรก ในปี 1997

SELECT TOP 5
p.ProductID รหัสสินค้า,
p.ProductName ชื่อสินค้า,
SUM(od.Quantity) จำนวนที่ขายได้
FROM Products p 
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1997

GROUP BY 
p.ProductID,
p.ProductName

ORDER By 
จำนวนที่ขายได้ DESC

--ข้อมูล ชื่อบริษัทลูกค้า และประเทศลูกค้า ที่ซื้อสินค้าที่มาจากบริษัทชื่อ Exotic Liquids

SELECT 
c.CompanyName ชื่อบริษัทลูกค้า,
c.Country ชื่อประเทศลูกค้า
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.CompanyName = 'Exotic Liquids'
ORDER BY c.CompanyName

--ชื่อบริษัทลูกค้าที่ซื้อสินค้าหมวดหมู่ Seafood

SELECT DISTINCT
c.CompanyName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE cat.CategoryName = 'Seafood'
ORDER BY c.CompanyName 

-- SUB QUERY (QUERY ซ้อนกัน)
--ชื่อพนักงานที่มีตำแหน่งเดียวกับ Nancy (nancy ตำแหน่งอะไร)

SELECT Firstname
FROM Employees
WHERE title = (SELECT title FROM Employees WHERE FirstName = 'nancy' )  --ตำแหน่งของ nancy


--ชื่อพนักงานที่อายุน้อยกว่า Robert (robert เกิดเมื่อไหร่)

SELECT Firstname
FROM Employees
WHERE BirthDate > (SELECT BirthDate FROM Employees WHERE FirstName = 'robert') --วันเกิดของ Robert

--รหัสสินค้า ชื่อสินค้า ที่มีราคาสูงกว่าค่าเฉลี่ยทั้งหมดของราคาสินค้า (ค่าเฉลี่ยของราคาสินค้าคืออะไร)

SELECT ProductID, ProductName, Unitprice
FROM Products
WHERE UnitPrice > (SELECT AVG(Unitprice) FROM products) --ราคาเฉลี่ยของสินค้าทั้งหมด

--ชื่อ นามสกุล พนักงานที่ อายุมากที่สุด

SELECT FirstName ชื่อ , LastName นามสกุล , BirthDate วันเกิด
FROM Employees
WHERE BirthDate = (SELECT MIN(BirthDate)FROM Employees)


--ชื่อ นามสกุล พนักงานที่ เข้าทำงานหลังสุด

SELECT FirstName ชื่อ , LastName นามสกุล, HireDate วันที่เข้าทำงาน
FROM Employees  
WHERE HireDate = (SELECT MAX(HireDate)FROM Employees)