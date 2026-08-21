

SELECT orderID, ProductID, UnitPrice, Quantity, Discount, 
       UnitPrice*Quantity*(1-Discount) as TotalPrice
FROM [Order Details];

--ต้องการ รหัส ชื่อเต็มพนักงาน(คำนำหน้า ชื่อ นามสกุล) ตำแหน่ง โทร ของพนักงาน
    Select EmployeeID, TitleOfCourtesy+ FirstName+space(2)+LastName as EmpName, 
            Title,HomePhone
    from Employees
--ต้องการ รหัสสินค้า ราคา จำนวนที่ขายได้ ยอดเงินที่ขายได้ เรียงตามลำดับรหัสสินค้า
SELECT ProductID, SUM(Quantity) AS จำนวนที่ขายได้,
       CAST(SUM(UnitPrice*Quantity*(1-Discount)) AS numeric(10,2)) AS ยอดเงินที่ขายได้
FROM [Order Details]
GROUP BY ProductID
ORDER BY SUM(UnitPrice*Quantity*(1-Discount)) DESC;
--CAST(5634.6334 as nummeric(10,2))
-- ต้องการชื่อและปีที่พนักงานเข้าทำงาน
Select TitleOfCourtesy+ FirstName + SPACE(2) + LastName as EmpName,
        year(hiredate)+543 [ปี พ.ศ. ที่เข้าทำงาน]
from Employees

--รหัสสินค้า ชื่อสินค้า ราคา และ ช่วงราคา(สูง ปานกลาง ต่ำ)
Select ProductID, ProductName,UnitPrice,
        case when UnitPrice >=75 then 'High'
             when UnitPrice >=35 then 'Medium'
        else 'Low'
    end as PriceLevel

from products

--การ Join ตารางที่มีความสัมพันธ์กัน
-- Join 2 ตาราง
-- ต้องการชื่อสินค้าทั้งหมด และชื่อหมวดหมู่สินค้า
Select products.ProductName, Categories.CategoryName
from Products join Categories
on products.CategoryID = Categories.CategoryID

--เขียนแบบย่อ
Select p.ProductName, c.CategoryName
from Products as p join Categories as c
on p.CategoryID = c.CategoryID

----------------------------------------
Select
    p.ProductName,
    s.CompanyName as Supplier
From Products as p
Join Suppliers as s
    on p.SupplierID = s.SupplierID;

-----------------------------------------
Select
    o.OrderID,
    FORMAT(OrderDate, 'dd/MM/yyyy') as Date,
    c.CompanyName
From orders As o
join Customers As c
        on o.CustomerID = c.CustomerID;

------------------------------------------
Select
    o.OrderID,
    Convert(varchar,OrderDate,6) as [order date] ,
    c.CompanyName
From orders As o
join Customers As c
        on o.CustomerID = c.CustomerID
order by 3 asc
--convert(varchar, getdate(), 6)

--1. ต้องการชื่อบริษัทขนส่ง และจำนวนใบสั่งซื้อที่เกี่ยวข้อง.
select 
    s.Companyname as ShipperName,
    count (o.OrderID) as Totalorders
    from Orders as o
    join Shippers as s
    on o.ShipVia = s.ShipperID
group by s.CompanyName

--2.1. ต้องการชื่อเต็มพนักงาน และจำนวนใบสั่งซื้อที่เกี่ยวข้อง
select
    e.EmployeeID,
    e.TitleofCourtesy+e.FirstName+space(2)+e.LastName as empname,
    count(o.OrderID) as จำนวนใบสั่งซื้อ
from Employees as e
join Orders as o
    on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.TitleOfCourtesy, e.FirstName, e.LastName
order by จำนวนใบสั่งซื้อ desc

--2.2. ชื่อบริษัทลูกค้า ประเทศลูกค้า และจำนวนใบสั่งซื้อที่เกี่ยวข้อง
select
c.CompanyName,
c.Country,
count(orderID) as Ordercount
from orders as o
join customers as c
    on o.CustomerID = c.CustomerID
    group by c.CompanyName, c.Country
    order by Ordercount

--3.1. หมายเลขใบสั่งซื้อ และ ชื่อบริษัทขนส่ง
select o.OrderID, s.CompanyName as shipper
from Orders as o
join shippers as s
    on o.ShipVia = s.ShipperID;

--3.2. รหัสสินค้า(ProductID) ชื่อสินค้า(ProductName) และชื่อบริษัทผู้จัดจำหน่าย Supplier (companyname)
Select
    p.ProductID   as "รหัสสินค้า (ProductID)",
    p.ProductName as "สินค้า (Product Name)",
    s.CompanyName as "บริษัทผู้จัดจำหน่าย (Supplier)"
From Products as p
Join Suppliers as s
    on p.SupplierID = s.SupplierID;

--4. รหัสหมวดหมู่ ชื่อหมวดหมู่สินค้า และจำนวนชนิดสินค้าในแต่ละหมวดหมู่
select
    c.CategoryID as 'รหัสหมวดหมู่',
    c.CategoryName as 'ชื่อหมวดหมู่สินค้า',
    Count(p.ProductID) as 'จำนวนชนิดสินค้า'
    from Categories c
    join Products p on c.CategoryID = p.CategoryID


--Join แบบ 3 ตารางขึ้นไป
--ต้องการหมายเลขคำสั่งซื้อ วันที่สั่งซื้อ บริษัทลูกค้า ชื่อสกุลพนักงานผู้ชาย
    select orderID, Convert(varchar,OrderDate,6) as [order date],
           c.CompanyName, e.FirstName + Space(2) + e.LastName as 'Male Employee Name'
    from orders o
            inner join Customers c on o.CustomerID = c.CustomerID
            inner join Employees e on o.EmployeeID = e.EmployeeID

-- ต้องการรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย ชื่อหมวดหมู่ ชื่อบริษัทผู้จัดจำหน่าย
select ProductID, ProductName, UnitPrice, CategoryName, CompanyName
from products p join Categories c on p.CategoryID = c.CategoryID
               join Suppliers s on p.SupplierID = s.SupplierID

-- ต้องการ รหัสหมวดหมู่ ชื่อหมวดหมู่ ยอดขายทั้งหมดในหมวดหมู่ แสดงเฉพาะยอดขายสูงสุด 3 อันดับแรก
select
    c.CategoryID,
    c.CategoryName,
    CAST(SUM(od.UnitPrice*Quantity*(1-Discount)) AS numeric(10,2)) as TotalPrice

    from Categories c
    join products p on c.CategoryID = p.CategoryID
    join [Order Details] od on od.ProductID = p.ProductID

group by c.CategoryID, c.CategoryName
order by 3 desc

--Join 4 ตาราง ในแต่ละรายการสั่งซื้อ มีบริษัทลูกค้าใดซื้อสืนค้า ชื่ออะไร จำนวน และยอดขายเท่าใด
select o.orderID, c.CompanyName, p.ProductName, od.Quantity,
       od.UnitPrice*Quantity*(1-Discount) as [TotalSale]
from orders o   join Customers c        on o.CustomerID = c.CustomerID
                join [Order Details] od on o.OrderID  = od.OrderID
                join products p         on p.ProductID  = od.ProductID

--ลูกค้าบริษัทใด ซื้อสินค้าที่มาจาก USA (5 ตาราง)
select c.CompanyName
from Customers as c join Orders          o     on c.CustomerID = o.CustomerID
                    join [Order Details] od    on o.OrderID = od.OrderID
                    join Products        p     on od.ProductID = p.ProductID
                    join Suppliers       s     on p.SupplierID = s.SupplierID and s.Country = 'USA'
group by c.CompanyName
