--สำรวจรายชื่อตารางใน DATABASE
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
--สำรวจโครงสร้างตาราง
EXEC sp_help 'dbo.Products'
EXEC sp_help 'employees'

DROP TABLE Categories
--คำสั่ง Select เบื้องต้น (Query DATA)
--ต้องการข้อมูลสินค้า
SELECT * FROM Products
--ต้องการรหัสสินค้า ชื่อสิ้นค้า ราคา
SELECT ProductID, ProductName, Unitprice FROM Products
--Alias Name = เรียกง่ายๆว่าชื่อเล่น
SELECT ProductID as รหัส, ProductName as ชื่อสินค้า, Unitprice as ราคา
from products
--ลบ as ออก
SELECT ProductID  รหัส, ProductName  ชื่อสินค้า, Unitprice  ราคา
from products
--ใช้ Distinct สำหรับข้อมูลที่ซ้ำกัน
SELECT DISTINCT POSITION FROM Employees
--ใช้ Top(n) สำหรับแสดงข้อมูล n รายการ (โดยปกติจะใช้ร่วมกับการเรียงลำดับ)
SELECT TOP (3) ProductID, ProductName, Unitprice FROM Products
--ปรับปรุงราคาสินค้า "ดินสอ" เป็นราคาใหม่ 17 บาท
UPDATE Products
SET UnitPrice = 17, UnitsInStock = 100
WHERE ProductName = 'ดินสอ'
--หลังจากรันโค้ดแล้วดูข้อมูลว่าเปลี่ยนหรือไม่
SELECT * FROM Products

UPDATE Products
SET UnitPrice = UnitPrice * 1.05

--ปรับปรุงจำนวนคงเหลือของน้ำส้ม เพิ่มจากเดิมอีก 100 ชิ้น
UPDATE Products
SET UnitsInStock = UnitsInStock + 100
WHERE ProductName = 'น้ำส้ม'
--ปรับปรุงราคาแชมพู ลดราคา 5 บาท
UPDATE Products
SET Unitprice = UnitPrice -5
WHERE ProductName = 'แชมพู'
--DELETE ลบข้อมูล
DELETE FROM Products
WHERE productID = 1

--การใช้ Where ในคำสั่ง SELECT
--ข้อมูลสินค้าที่มีราคาน้อยกว่า 20
SELECT * FROM Products
WHERE UnitPrice <20

--ชื่อ นามสกุล พนักงาน ที่มีตำแหน่ง 'Sale Manager'
SELECT FirstName, LastName
FROM Employees
WHERE Position = 'Sale Manager'

--รหัส ชื่อสินค้า ที่เลิกจำหน่ายแล้ว (Discontinue =1)
SELECT productID, ProductName
FROM Products
WHERE Discontinued =1
--ทดลองใช้AND
SELECT *
FROM Products
WHERE UnitPrice >=10 AND UnitsInStock <100
--ทดลองใช้OR
SELECT *
FROM Products
WHERE CategoryID =2 OR CategoryID =4
--ทดลองใช้NOT
SELECT*
FROM Products
WHERE NOT Discontinued =1
--ทดลองใช้BETWEEN
SELECT productID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20
--ทดลองใช้ IN
SELECT productID, ProductName, CategoryID
FROM Products
WHERE CategoryID IN (1, 2, 4)

--การใช้เงื่อนไขร่วมกับ WildCard %
--ต้องการข้อมูลพนักงานที่มีชื่อขึ้นต้นด้วย ก
SELECT * FROM Employees
WHERE FirstName Like 'ก%'
--ต้องการข้อมูลพนักงานที่มีนามสกุลลงท้ายด้วย "คำ"
SELECT * FROM Employees
WHERE LastName Like '%คำ'

--เตรียมข้อมูลใช้กับคำสั่ง IS NULL
INSERT INTO Employees(FirstName, UserName, Password)
VALUES('เจา','Chao','1982'),('โปเต้','Potae','9999')

--ข้อมูลพนักงานที่ไม่ทราบนามสกุล
SELECT * FROM Employees
WHERE LastName IS NULL or LastName=''

--ปรับปรุงข้อมูลก่อนทดสอบช่องว่าง
UPDATE Employees SET LastName = ''
WHERE FirstName = 'เจา'

--ปัญหาเบื้องต้นจากค่า NULL คือ ไปรวมกับใครก็เป็น NULL ไปหมด
SELECT FirstName+' '+LastName as ชื่อพนักงาน
FROM Employees

--ต้องการข้อมูลใบเสร็จที่ขายสินค้าก่อนวันที่ 10 ก.พ. 2013
SELECT * FROM Receipts
WHERE ReceiptDate < '2013-02-10'

--บางกรณีใช้ Function Year() หรือ Month() ร่วมกับเงื่อนไขได้
--ต้องการข้อมูลใบเสร็จที่ขายสินค้าในเดือนกุมภาพันธ์ ปี 2013
SELECT * FROM Receipts
WHERE YEAR(ReceiptDate) = 2013 
and MONTH(ReceiptDate)=02

--ASC ย่อมาจาก ASCENDING น้อยไปมาก

SELECT productID, ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice ASC

--DESC ย่อมาจาก Descending มากไปน้อย

SELECT productID, ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--ต้องการข้อมูลใบเสร็จ อันใหม่ที่สุดขึ้นก่อน
SELECT* FROM Receipts
ORDER BY ReceiptDate DESC