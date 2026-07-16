--เริ่มจาก Master สร้างฐานข้อมูลชื่อ CSMinimart
Create Database CSMinimart
--ปรับให้ฐานข้อมูลสามารถเพิ่มข้อมูลที่เป็นภาษาไทยได้
Alter Database CSMinimart Collate Thai_CI_AS;
--สร้างตารางเก็บข้อมูลพนักงาน ชื่อ Employees
Create Table Employees (
EmployeeID int identity (1,1) Primary Key,
title varchar(20) null,
firstname varchar(50) not null,
lastname varchar(50) null,
position varchar(50) null,
username varchar(50) Unique,
passwordhash varchar (255) not null,
IsActive bit not null default 1
)
--สำหรับคนที่สร้างผิด ใช้ Database เดิม (master)

--ทดสอบการเพิ่มข้อมูลในตาราง Employees
INSERT INTO Employees
(title, firstname, lastname, position, username, passwordhash)
VALUES
('นางสาว', 'กาญจนา', 'พวงแก้ว','Sale Manager', 'user1', 'hashed1');
--เมื่อเพิ่มแล้ว ทดสอบเรียกข้อมูลออกมาดู
Select * from Employees
--ทดสอบเพิ่มข้อมูลรายการใหม่ ใส่ชื่อใหม่
INSERT INTO Employees
(title, firstName, lastName, position, username, passwordhash)
VALUES
('นาย', 'พีรพัฒน์', 'จันที','Sale Manager', 'user2', 'hashed2');
--สร้างตตารางหมวดหมู่สินค้า Categories
Create Table Categories (
CategoryID INT IDENTITY(1,1) PRIMARY KEY,
CategoryName VARCHAR(50) NOT NULL UNIQUE,
Description VARCHAR(200) 
);


Insert into categories(CategoryName, Description)
Values('เครื่องดิ่มเย็น','โออิชิ สปอนเซอร์ แบรนด์ น้ำอัดลม')
Insert into Categories(CategoryName, Description)
Values('อุปกรณ์ไฟฟ้า','พัดลม หม้อหุ่งข้าวไฟฟ้า หลอดไฟ ไดร์เป่าผม')
Insert into categories(CategoryName, Description)
Values('เครื่องปรุง','ผงชูรส รสดี เกลือ น้ำตาล')
Insert into Categories(CategoryName, Description)
Values('อาหารสำเร็จรูป','มาม่า ปลากระป๋อง')
Insert into Categories(CategoryName, Description)
Values('เวชภัณฑ์','ยารักษาโรค ยาสามัญประจำบ้าน ยาใช้ภายนอก')

--ดูข้อมูลในตาราง Categories
Select * from Categories

--สร้างตาราง Products

Create Table Products (
ProductID VARCHAR(13) PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
UnitsInStock INT NOT NULL DEFAULT 0,
CategoryID INT NOT NULL,
Discontinued BIT NOT NULL DEFAULT 0,

CONSTRAINT CK_Products_UnitPrice
CHECK (UnitPrice >= 0),
CONSTRAINT CK_Products_UnitsInStock
CHECK (UnitsInStock >= 0),
CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)
);

--ทดสอบเพิ่มข้อมูลในตาราง Products

INSERT INTO Products
(ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
('8858757001948','โค้ก', 15.00, 290, 1);

INSERT INTO Products
(ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
('8858638009283','น้ำผลไม้อัดลม', 15.00, 20, 1);

INSERT INTO Products
(ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
('8859126002458','ยาดมหงษ์ไทย', 32.00, 160, 1);

INSERT INTO Products
(ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
('8858998581047','เป๊บซี่', 19.00, 30, 1);

INSERT INTO Products
(ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
('8850051019573','แก้วน้ำแข็ง', 9.00, 300, 1);

--ทดสอบ Products
Select * from Products
 
 --สร้างตาราง Receipts

 CREATE TABLE Receipts (
    ReceiptID INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptDate DATETIME NOT NULL
        DEFAULT GETDATE(),
    EmployeeID INT NOT NULL,
    TotalCash DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT CK_Receipts_TotalCash
        CHECK (TotalCash >= 0),

    CONSTRAINT FK_Receipts_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

--select getdate()

--เพิ่มข้อมูลใน Receipts

INSERT INTO Receipts
    (EmployeeID, TotalCash)
VALUES
    (1, 115.00);
-- ทดสอบข้อมูลชุดที่ 2 
--SQL ข้อมูลผิด (ไม่มี Employee ID =99)
INSERT INTO Receipts
(EmployeeID, TotalCash)
VALUES
(99, 100.00);
--ทดสอบ Receipts
SELECT * FROM Receipts;

--สร้างตาราง Details
CREATE TABLE Details (
ReceiptID INT NOT NULL,
ProductID VARCHAR(13) NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL,
Quantity INT NOT NULL,

CONSTRAINT PK_Details
PRIMARY KEY (ReceiptID, ProductID),
CONSTRAINT CK_Details_UnitPrice
CHECK (UnitPrice >= 0),
CONSTRAINT CK_Details_Quantity
CHECK (Quantity > 0),
CONSTRAINT FK_Details_Receipts
FOREIGN KEY (ReceiptID)
REFERENCES Receipts(ReceiptID),
CONSTRAINT FK_Details_Products
FOREIGN KEY (ProductID)
REFERENCES Products(ProductID)
);
--เพิ่มข้อมูลใน Details
INSERT INTO Details
(ReceiptID, ProductID, UnitPrice, Quantity)
VALUES
(1, '8858757001948', 13.00, 3);

--ข้อมูลชุดที่ 2
INSERT INTO Details
(ReceiptID, ProductID, UnitPrice, Quantity)
VALUES
(1, '8858757001948', 14.00, 0);

--ทดสอบ Details

Select * from Details