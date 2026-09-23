/*Part 1*/

select customerID,CompanyName from Customers
where customerid ='ALFKI'

begin transaction

insert into orders
(customerid,employeeid,orderdate,RequiredDate,Freight)
values
('ALFKI',1,GETDATE()
,DATEADD(day,7,GETDATE()),50.00)

select SCOPE_IDENTITY()
as NewOrderID

insert into [Order Details]
(Orderid,productid,unitprice,Quantity,discount)
select
11078,productid,unitprice,2,0
from Products
where productid =1

insert into [Order Details]
(Orderid,productid,unitprice,Quantity,discount)
select
11078,productid,unitprice,3,0
from Products
where productid =2

select * from orders where orderid = '11078'
select * from [Order Details] where orderid = '11078'

commit

/*Part 2*/
begin transaction

insert into Orders
(CustomerID,EmployeeID,orderdate,RequiredDate,Freight)
values
('ALFKI',1,getdate(),DATEADD(day,7,getdate()),75.00)

select SCOPE_IDENTITY()
as RollbackOrderid

insert into [Order Details]
(Orderid,productid,unitprice,Quantity,discount)
select
11079,productid,unitprice,1,0
from Products
where productid =1

insert into [Order Details]
(Orderid,productid,unitprice,Quantity,discount)
select
11079,productid,unitprice,2,0
from Products
where productid =2

select * from orders 
where orderid='11079'

select * from [Order Details] 
where orderid='11079'

rollback

select * from orders 
where orderid='11079'

select * from [Order Details] 
where orderid='11079'