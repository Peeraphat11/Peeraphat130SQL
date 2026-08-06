--Lab ในชั้นเรียนวันที่  6 สิงหาคม 2569
--ใช้ ฐานข้อมูล Northwind เพื่อ Query ข้อมูลต่อไปนี้

--1.ต้องการ คำนำหน้า ชื่อ นามสกุล พนักงาน ที่อยู่ในเมือง London

SELECT TitleOfCourtesy, FirstName, LastName
FROM Employees	
WHERE City = 'London';

--2.ข้อมูล รหัสสินค้า ชื่อสินค้า ราคา จำนวน ของสินค้าที่มีจำนวนน้อยกว่า 30
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitsInStock < 30;

--3.รหัสลูกค้า ชื่อบริษัท เบอร์โทรศัพท์ ของลูกค้าที่อยู่ในประเทศต่อไปนี้
--    Sweden, Germany, France, Spain, UK
SELECT CustomerID, CompanyName, Phone
FROM Customers
WHERE Country IN ('Sweden', 'Germany', 'France', 'Spain', 'UK');

--4.ข้อมูลลูกค้าที่ไม่มีหมายเลขโทรสาร (Fax)
SELECT *
FROM Customers
WHERE Fax IS NULL;

--5.ข้อมูลสินค้าที่มีจำนวนสินค้าต่ำกว่าจุดสั่งซื้อ และ มีจำนวนที่สั่งซื้อแล้ว
SELECT *
FROM Products
WHERE UnitsInStock < ReorderLevel 
AND UnitsOnOrder > 0;

--6.ชื่อ นามสกุล พนักงานที่เข้าทำงานในปี 1992
SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) = 1992;

--7.ต้องการข้อมูลสินค้าที่มีราคาตั้งแต่ 20-70
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 70;

--8.ข้อมูลลูกค้าที่มีชื่อบริษัทขึ้นต้นด้วย S และอยู่ประเทศ Mexico
SELECT *
FROM Customers
WHERE CompanyName LIKE 'S%' 
 AND Country = 'Mexico';

 --9.
 SELECT * FROM Customers
 WHERE contacttitle like '%manager%'


 --Aggregate Function (หรือเรียกว่า Group Function)
 --เป็น Function ที่คำนวณมาจากข้อมูลหลายแถว
 SELECT Top(5) * FROM Products

 --ใช้ AS ก็ได้ หรือไม่ใช้ก็ได้
 SELECT COUNT (*) AS จำนวนชนิดสินค้า, MAX(UnitPrice) AS ราคาสูงสุด, 
 MIN(UnitPrice) ราคาต่ำสุด, AVG(UnitPrice) ราคาเฉลี่ย, Sum(UnitsInStock) จำนวนรวมทั้งหมด
 FROM Products

 --ต้องการทราบว่าสินค้าแต่ละหมวดหมู่ (CategoryID) มีสินค้ากี่ชนิด แต่ละชนิดมีราคาเฉลี่ย มีราคาสูงสุด และต่ำสุด
 SELECT CategoryID, COUNT(*) จำนวนชนิด, 
 AVG(UnitPrice) ราคาเฉลี่ย, MAX(UnitPrice) ราคาสูงสุด, MIN(UnitPrice) ราคาต่ำสุด
 FROM Products
 GROUP BY CategoryID

 --ต้องการทราบข้อมูลว่าในแต่ละประเทศ (Country) มีลูกค้าอยู่กี่ราย (ถ้าทำได้แล้วลองเพิ่ม city เข้าไปด้วย)

SELECT Country,City, Count(*) จำนวนลูกค้า
FROM Customers
GROUP BY Country ,City
ORDER BY Country asc , COUNT(*) desc --เรียงตัวอักษร A-Z
--ORDER BY COUNT(*) DESC
--ORDER BY 3 DESC  ใช้ คอลั่มที่ 3 ในการเรียง

--ต้องการทราบข้อมูลว่าในแต่ละประเทศ (Country) แสดงเฉพาะที่มีจำนวนลูกค้า 10 รายขึ้นไป
SELECT Country, COUNT(*) จำนวนลูกค้า
FROM Customers
GROUP BY Country
HAVING COUNT (*) >=10

--ต้องการทราบว่าสินค้าที่มีมูลค่าสูง (ราคาตั้งแต่ 75 ขึ้นไป) แต่ละหมวดหมู่มีจำนวนกี่ชนิด มีราคาเฉลี่ยเท่าใด
--ให้แสดงเฉพาะสินค้าที่มีราคาเฉลี่ย มากกว่า 200
SELECT CategoryID, COUNT(*) จำนวนชนิด, AVG(UnitPrice) ราคาเฉลี่ย
FROM Products
WHERE UnitPrice >=75
GROUP BY CategoryID
HAVING AVG(UnitPrice) > 200

--จากตาราง [Order Details] ให้รวบรวมว่าในแต่ละการสั่งซื้อ มียอดเงินรวมเท่าใด
SELECT OrderID, UnitPrice,Quantity,Discount, 
	UnitPrice * Quantity  ราคาเต็ม, 
	UnitPrice * Quantity * Discount  ส่วนลด,
	(UnitPrice * Quantity) - (UnitPrice * Quantity * Discount) ราคาหักส่วนลดแล้ว,
	(UnitPrice * Quantity * (1 - Discount)) หักส่วนลดสูตรย่อ
FROM [Order Details]

--ต้องการเฉพาะใบสั่งซื้อที่มียอดเงินรวมมากกว่า 1000
SELECT OrderID, COUNT(*) จำนวนรายการ ,
	SUM((Unitprice * Quantity * (1 - Discount))) ยอดเงินรวม
FROM [Order Details]
GROUP BY OrderID
HAVING SUM((Unitprice * Quantity * (1 - Discount))) >2000
ORDER BY 3 DESC
--ORDER BY SUM((Unitprice * Quantity * (1 - Discount))) DESC